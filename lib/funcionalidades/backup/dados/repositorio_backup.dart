import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/provedores/provedores_banco.dart';

final provedorRepositorioBackup = Provider<RepositorioBackup>((ref) {
  return RepositorioBackup(ref.watch(provedorBancoDendro));
});

final provedorBackupsLocais = FutureProvider.autoDispose<List<BackupLocal>>((
  ref,
) {
  return ref.watch(provedorRepositorioBackup).listarBackupsLocais();
});

class BackupLocal {
  const BackupLocal({
    required this.caminho,
    required this.nomeArquivo,
    required this.criadoEm,
    required this.tamanhoBytes,
  });

  final String caminho;
  final String nomeArquivo;
  final DateTime criadoEm;
  final int tamanhoBytes;
}

class ExcecaoBackup implements Exception {
  const ExcecaoBackup(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

class RepositorioBackup {
  RepositorioBackup(
    this._bancoDados, {
    Future<Directory> Function()? obterDiretorioDocumentos,
  }) : _obterDiretorioDocumentos =
           obterDiretorioDocumentos ?? getApplicationDocumentsDirectory;

  final BancoDendro _bancoDados;
  final Future<Directory> Function() _obterDiretorioDocumentos;

  static const _formato = 'dendro_mobile_backup';
  static const _versaoFormato = 1;
  static const extensaoArquivo = 'dendrobackup';
  static const tipoMime = 'application/json';

  static const _ordemInsercao = [
    'propriedades',
    'especies',
    'modelos_matematicos',
    'variaveis_modelo',
    'coeficientes_modelo',
    'especies_modelos',
    'coeficientes_especie_modelo',
    'talhoes',
    'levantamentos',
    'talhao_levantamentos',
    'coeficientes_talhao_levantamento',
    'parcelas',
    'arvores',
    'registros_atividade',
  ];

  Future<BackupLocal> criarBackup({bool antesDaRestauracao = false}) async {
    final agora = DateTime.now();
    final tabelas = <String, List<Map<String, Object?>>>{};

    for (final nomeTabela in _ordemInsercao) {
      final linhas = await _bancoDados
          .customSelect('SELECT * FROM ${_identificador(nomeTabela)}')
          .get();
      tabelas[nomeTabela] = [
        for (final linha in linhas) Map<String, Object?>.from(linha.data),
      ];
    }

    final conteudo = <String, Object?>{
      'formato': _formato,
      'versao_formato': _versaoFormato,
      'versao_schema': _bancoDados.schemaVersion,
      'criado_em': agora.toUtc().toIso8601String(),
      'tabelas': tabelas,
    };
    final diretorio = await _diretorioBackups();
    final prefixo = antesDaRestauracao
        ? 'dendro_antes_restauracao'
        : 'dendro_backup';
    final nomeArquivo = '${prefixo}_${_dataNoNome(agora)}.$extensaoArquivo';
    final arquivo = File(
      '${diretorio.path}${Platform.pathSeparator}$nomeArquivo',
    );
    await arquivo.writeAsString(jsonEncode(conteudo), flush: true);
    return _arquivoParaBackupLocal(arquivo);
  }

  Future<List<BackupLocal>> listarBackupsLocais() async {
    final diretorio = await _diretorioBackups();
    final arquivos = await diretorio
        .list()
        .where(
          (item) => item is File && item.path.endsWith('.$extensaoArquivo'),
        )
        .cast<File>()
        .toList();
    final backups = await Future.wait(arquivos.map(_arquivoParaBackupLocal));
    backups.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return backups;
  }

  Future<void> restaurar(String caminho) async {
    final arquivo = File(caminho);
    if (!await arquivo.exists()) {
      throw const ExcecaoBackup('O arquivo de backup não foi encontrado.');
    }

    final Object? decodificado;
    try {
      decodificado = jsonDecode(await arquivo.readAsString());
    } on FormatException {
      throw const ExcecaoBackup(
        'O arquivo selecionado não é um backup válido.',
      );
    }
    if (decodificado is! Map<String, dynamic> ||
        decodificado['formato'] != _formato ||
        decodificado['versao_formato'] != _versaoFormato) {
      throw const ExcecaoBackup(
        'O arquivo selecionado não é um backup DENDRO.',
      );
    }
    if (decodificado['versao_schema'] != _bancoDados.schemaVersion) {
      throw const ExcecaoBackup(
        'Este backup pertence a uma versão incompatível do banco de dados.',
      );
    }

    final tabelasBrutas = decodificado['tabelas'];
    if (tabelasBrutas is! Map<String, dynamic>) {
      throw const ExcecaoBackup('O backup não contém as tabelas esperadas.');
    }

    final tabelas = <String, List<Map<String, Object?>>>{};
    for (final nomeTabela in _ordemInsercao) {
      final linhasBrutas = tabelasBrutas[nomeTabela];
      if (linhasBrutas is! List) {
        throw ExcecaoBackup('A tabela $nomeTabela está ausente no backup.');
      }
      final colunas = await _colunasDaTabela(nomeTabela);
      final linhas = <Map<String, Object?>>[];
      for (final linhaBruta in linhasBrutas) {
        if (linhaBruta is! Map<String, dynamic> ||
            linhaBruta.keys.toSet().difference(colunas).isNotEmpty ||
            colunas.difference(linhaBruta.keys.toSet()).isNotEmpty) {
          throw ExcecaoBackup(
            'A estrutura da tabela $nomeTabela não é compatível.',
          );
        }
        linhas.add(Map<String, Object?>.from(linhaBruta));
      }
      tabelas[nomeTabela] = linhas;
    }

    await criarBackup(antesDaRestauracao: true);
    await _bancoDados.transaction(() async {
      for (final nomeTabela in _ordemInsercao.reversed) {
        await _bancoDados.customStatement(
          'DELETE FROM ${_identificador(nomeTabela)}',
        );
      }
      for (final nomeTabela in _ordemInsercao) {
        for (final linha in tabelas[nomeTabela]!) {
          await _inserirLinha(nomeTabela, linha);
        }
      }
    });
    _bancoDados.markTablesUpdated(_bancoDados.allTables);
  }

  Future<void> excluirBackup(String caminho) async {
    final arquivo = File(caminho);
    if (await arquivo.exists()) await arquivo.delete();
  }

  Future<Set<String>> _colunasDaTabela(String nomeTabela) async {
    final linhas = await _bancoDados
        .customSelect('PRAGMA table_info(${_identificador(nomeTabela)})')
        .get();
    return {for (final linha in linhas) linha.read<String>('name')};
  }

  Future<void> _inserirLinha(String nomeTabela, Map<String, Object?> linha) {
    final colunas = linha.keys.toList();
    final nomes = colunas.map(_identificador).join(', ');
    final marcadores = List.filled(colunas.length, '?').join(', ');
    return _bancoDados.customStatement(
      'INSERT INTO ${_identificador(nomeTabela)} ($nomes) VALUES ($marcadores)',
      [for (final coluna in colunas) linha[coluna]],
    );
  }

  Future<Directory> _diretorioBackups() async {
    final documentos = await _obterDiretorioDocumentos();
    final diretorio = Directory(
      '${documentos.path}${Platform.pathSeparator}backups',
    );
    if (!await diretorio.exists()) await diretorio.create(recursive: true);
    return diretorio;
  }

  Future<BackupLocal> _arquivoParaBackupLocal(File arquivo) async {
    final estado = await arquivo.stat();
    DateTime criadoEm = estado.modified;
    try {
      final conteudo = jsonDecode(await arquivo.readAsString());
      final data = conteudo is Map<String, dynamic>
          ? DateTime.tryParse(conteudo['criado_em']?.toString() ?? '')
          : null;
      if (data != null) criadoEm = data.toLocal();
    } catch (_) {
      // A validação completa ocorre apenas quando o usuário restaura o arquivo.
    }
    return BackupLocal(
      caminho: arquivo.path,
      nomeArquivo: arquivo.uri.pathSegments.last,
      criadoEm: criadoEm,
      tamanhoBytes: estado.size,
    );
  }

  static String _identificador(String valor) {
    return '"${valor.replaceAll('"', '""')}"';
  }

  static String _dataNoNome(DateTime data) {
    String dois(int valor) => valor.toString().padLeft(2, '0');
    return '${data.year}${dois(data.month)}${dois(data.day)}_'
        '${dois(data.hour)}${dois(data.minute)}${dois(data.second)}_'
        '${data.millisecond.toString().padLeft(3, '0')}';
  }
}
