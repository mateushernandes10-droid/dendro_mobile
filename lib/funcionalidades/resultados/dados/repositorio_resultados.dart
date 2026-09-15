import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_volume_florestal.dart';
import '../../../nucleo/provedores/provedores_banco.dart';

final provedorRepositorioResultados = Provider<RepositorioResultados>((ref) {
  return RepositorioResultados(ref.watch(provedorBancoDendro));
});

final provedorFiltroPropriedadeResultados = StateProvider.autoDispose<int?>((
  ref,
) {
  return null;
});

final provedorFiltroTalhoesResultados = StateProvider.autoDispose<Set<int>>((
  ref,
) {
  return <int>{};
});

final provedorFiltroEspecieResultados = StateProvider.autoDispose<int?>((ref) {
  return null;
});

final provedorOpcoesFiltrosResultados =
    StreamProvider.autoDispose<OpcoesFiltrosResultados>((ref) {
      return ref.watch(provedorRepositorioResultados).observarOpcoesFiltros();
    });

final provedorPainelResultados = StreamProvider.autoDispose<PainelResultados>((
  ref,
) {
  final filtros = FiltrosResultados(
    propriedadeId: ref.watch(provedorFiltroPropriedadeResultados),
    talhaoIds: ref.watch(provedorFiltroTalhoesResultados),
    especieId: ref.watch(provedorFiltroEspecieResultados),
  );

  return ref.watch(provedorRepositorioResultados).observarPainel(filtros);
});

class FiltrosResultados {
  const FiltrosResultados({
    required this.propriedadeId,
    required this.talhaoIds,
    required this.especieId,
  });

  final int? propriedadeId;
  final Set<int> talhaoIds;
  final int? especieId;

  bool get possuiBaseFiltro => propriedadeId != null || especieId != null;
}

class OpcoesFiltrosResultados {
  const OpcoesFiltrosResultados({
    required this.propriedades,
    required this.talhoes,
    required this.especies,
  });

  final List<Propriedade> propriedades;
  final List<OpcaoTalhaoResultados> talhoes;
  final List<Especie> especies;

  List<OpcaoTalhaoResultados> talhoesVisiveis({
    int? propriedadeId,
    int? especieId,
  }) {
    if (propriedadeId == null && especieId == null) {
      return const [];
    }

    return talhoes.where((opcao) {
      if (propriedadeId != null &&
          opcao.talhao.propriedadeId != propriedadeId) {
        return false;
      }
      if (especieId != null && opcao.especie.id != especieId) {
        return false;
      }
      return true;
    }).toList();
  }
}

class OpcaoTalhaoResultados {
  const OpcaoTalhaoResultados({required this.talhao, required this.especie});

  final Talhao talhao;
  final Especie especie;
}

class PainelResultados {
  const PainelResultados({
    required this.parcelaQuantidade,
    required this.coletadaParcelaQuantidade,
    required this.medidaParcelaQuantidade,
    required this.arvoreQuantidade,
    required this.medidaAreaHa,
    required this.mediaDapCm,
    required this.mediaAlturaM,
    required this.amostraVolumeM3,
    required this.volumePorHaM3,
    required this.estimadoVolumeM3,
    required this.arvoresPorHa,
    required this.diametroClasses,
    required this.talhoes,
  });

  final int parcelaQuantidade;
  final int coletadaParcelaQuantidade;
  final int medidaParcelaQuantidade;
  final int arvoreQuantidade;
  final double medidaAreaHa;
  final double? mediaDapCm;
  final double? mediaAlturaM;
  final double amostraVolumeM3;
  final double? volumePorHaM3;
  final double? estimadoVolumeM3;
  final double? arvoresPorHa;
  final List<ResumoClasseDiametro> diametroClasses;
  final List<ResumoResultadosTalhao> talhoes;

  bool get possuiMedicoes => arvoreQuantidade > 0;

  factory PainelResultados.vazio() {
    return const PainelResultados(
      parcelaQuantidade: 0,
      coletadaParcelaQuantidade: 0,
      medidaParcelaQuantidade: 0,
      arvoreQuantidade: 0,
      medidaAreaHa: 0,
      mediaDapCm: null,
      mediaAlturaM: null,
      amostraVolumeM3: 0,
      volumePorHaM3: null,
      estimadoVolumeM3: null,
      arvoresPorHa: null,
      diametroClasses: [],
      talhoes: [],
    );
  }
}

class ResumoClasseDiametro {
  const ResumoClasseDiametro({
    required this.iniciarCm,
    required this.fimCm,
    required this.quantidade,
  });

  final int iniciarCm;
  final int fimCm;
  final int quantidade;

  String get rotulo => '$iniciarCm-$fimCm';
}

class ResumoResultadosTalhao {
  const ResumoResultadosTalhao({
    required this.talhao,
    required this.especie,
    required this.parcelaQuantidade,
    required this.coletadaParcelaQuantidade,
    required this.medidaParcelaQuantidade,
    required this.arvoreQuantidade,
    required this.medidaAreaHa,
    required this.mediaDapCm,
    required this.mediaAlturaM,
    required this.amostraVolumeM3,
    required this.volumePorHaM3,
    required this.estimadoVolumeM3,
    required this.convertidoEstimadoVolume,
    required this.convertidoVolumePorHa,
    required this.convertidoUnidade,
    required this.arvoresPorHa,
  });

  final Talhao talhao;
  final Especie especie;
  final int parcelaQuantidade;
  final int coletadaParcelaQuantidade;
  final int medidaParcelaQuantidade;
  final int arvoreQuantidade;
  final double medidaAreaHa;
  final double? mediaDapCm;
  final double? mediaAlturaM;
  final double amostraVolumeM3;
  final double? volumePorHaM3;
  final double? estimadoVolumeM3;
  final double? convertidoEstimadoVolume;
  final double? convertidoVolumePorHa;
  final String convertidoUnidade;
  final double? arvoresPorHa;
}

class RepositorioResultados {
  RepositorioResultados(this._bancoDados);

  final BancoDendro _bancoDados;

  Stream<OpcoesFiltrosResultados> observarOpcoesFiltros() {
    final consulta =
        _bancoDados.select(_bancoDados.propriedades).join([
          leftOuterJoin(
            _bancoDados.talhoes,
            _bancoDados.talhoes.propriedadeId.equalsExp(
              _bancoDados.propriedades.id,
            ),
          ),
          leftOuterJoin(
            _bancoDados.especies,
            _bancoDados.especies.id.equalsExp(_bancoDados.talhoes.especieId),
          ),
        ])..orderBy([
          OrderingTerm.asc(_bancoDados.propriedades.nome),
          OrderingTerm.asc(_bancoDados.talhoes.identificacao),
        ]);

    return consulta.watch().map((linhas) {
      final propriedadesPorId = <int, Propriedade>{};
      final talhoesPorId = <int, OpcaoTalhaoResultados>{};
      final especiePorId = <int, Especie>{};

      for (final linha in linhas) {
        final propriedade = linha.readTable(_bancoDados.propriedades);
        propriedadesPorId[propriedade.id] = propriedade;

        final talhao = linha.readTableOrNull(_bancoDados.talhoes);
        final especie = linha.readTableOrNull(_bancoDados.especies);
        if (talhao == null || especie == null) continue;

        talhoesPorId[talhao.id] = OpcaoTalhaoResultados(
          talhao: talhao,
          especie: especie,
        );
        especiePorId[especie.id] = especie;
      }

      final propriedades = propriedadesPorId.values.toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));
      final talhoes = talhoesPorId.values.toList()
        ..sort(
          (a, b) => a.talhao.identificacao.compareTo(b.talhao.identificacao),
        );
      final especies = especiePorId.values.toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));

      return OpcoesFiltrosResultados(
        propriedades: propriedades,
        talhoes: talhoes,
        especies: especies,
      );
    });
  }

  Stream<PainelResultados> observarPainel(FiltrosResultados filtros) {
    if (!filtros.possuiBaseFiltro) {
      return Stream.value(PainelResultados.vazio());
    }

    final consulta =
        _bancoDados.select(_bancoDados.parcelas).join([
          innerJoin(
            _bancoDados.talhaoLevantamentos,
            _bancoDados.talhaoLevantamentos.id.equalsExp(
              _bancoDados.parcelas.talhaoLevantamentoId,
            ),
          ),
          innerJoin(
            _bancoDados.levantamentos,
            _bancoDados.levantamentos.id.equalsExp(
              _bancoDados.talhaoLevantamentos.levantamentoId,
            ),
          ),
          innerJoin(
            _bancoDados.talhoes,
            _bancoDados.talhoes.id.equalsExp(
              _bancoDados.talhaoLevantamentos.talhaoId,
            ),
          ),
          innerJoin(
            _bancoDados.propriedades,
            _bancoDados.propriedades.id.equalsExp(
              _bancoDados.talhoes.propriedadeId,
            ),
          ),
          innerJoin(
            _bancoDados.especies,
            _bancoDados.especies.id.equalsExp(
              _bancoDados.talhaoLevantamentos.especieId,
            ),
          ),
          innerJoin(
            _bancoDados.modelosMatematicos,
            _bancoDados.modelosMatematicos.id.equalsExp(
              _bancoDados.talhaoLevantamentos.modeloMatematicoId,
            ),
          ),
          leftOuterJoin(
            _bancoDados.arvores,
            _bancoDados.arvores.parcelaId.equalsExp(_bancoDados.parcelas.id),
          ),
        ])..orderBy([
          OrderingTerm.asc(_bancoDados.propriedades.nome),
          OrderingTerm.asc(_bancoDados.talhoes.identificacao),
          OrderingTerm.asc(_bancoDados.parcelas.identificacao),
          OrderingTerm.asc(_bancoDados.arvores.numero),
        ]);

    final condicoes = <Expression<bool>>[];
    if (filtros.propriedadeId != null) {
      condicoes.add(_bancoDados.propriedades.id.equals(filtros.propriedadeId!));
    }
    if (filtros.talhaoIds.isNotEmpty) {
      condicoes.add(_bancoDados.talhoes.id.isIn(filtros.talhaoIds));
    }
    if (filtros.especieId != null) {
      condicoes.add(
        _bancoDados.talhaoLevantamentos.especieId.equals(filtros.especieId!),
      );
    }
    if (condicoes.isNotEmpty) {
      consulta.where(condicoes.reduce((valor, elemento) => valor & elemento));
    }

    return consulta.watch().asyncMap(_montarPainelDasLinhas);
  }

  Future<PainelResultados> _montarPainelDasLinhas(
    List<TypedResult> linhas,
  ) async {
    final vistosParcelas = <int>{};
    final vistosArvores = <int>{};
    final diametroFaixas = <int, int>{};
    final talhoesPorId = <int, _TalhaoResultadosAcumulador>{};
    final coeficienteCache = <int, Map<String, double?>>{};

    var parcelaQuantidade = 0;
    var coletadaParcelaQuantidade = 0;
    var medidaParcelaQuantidade = 0;
    var arvoreQuantidade = 0;
    var medidaAreaHa = 0.0;
    var dapSoma = 0.0;
    var alturaSoma = 0.0;
    var amostraVolumeM3 = 0.0;

    for (final linha in linhas) {
      final parcela = linha.readTable(_bancoDados.parcelas);
      final talhaoLevantamento = linha.readTable(
        _bancoDados.talhaoLevantamentos,
      );
      final talhao = linha.readTable(_bancoDados.talhoes);
      final especie = linha.readTable(_bancoDados.especies);
      final modeloMatematico = linha.readTable(_bancoDados.modelosMatematicos);
      final arvore = linha.readTableOrNull(_bancoDados.arvores);

      final talhaoAcumulador = talhoesPorId.putIfAbsent(
        talhaoLevantamento.id,
        () => _TalhaoResultadosAcumulador(
          talhaoLevantamento: talhaoLevantamento,
          talhao: talhao,
          especie: especie,
          modeloMatematico: modeloMatematico,
        ),
      );

      if (vistosParcelas.add(parcela.id)) {
        parcelaQuantidade++;
        talhaoAcumulador.adicionarParcela(parcela);

        if (parcela.situacao == SituacaoParcela.coletada) {
          coletadaParcelaQuantidade++;
        }
        if (parcela.situacao != SituacaoParcela.pendente) {
          medidaParcelaQuantidade++;
          medidaAreaHa += parcela.areaHa ?? 0;
        }
      }

      if (arvore == null || !vistosArvores.add(arvore.id)) continue;

      arvoreQuantidade++;
      dapSoma += arvore.dapCm;
      alturaSoma += arvore.alturaM;
      final coeficientes = coeficienteCache.putIfAbsent(
        talhaoLevantamento.id,
        () => const <String, double?>{},
      );
      if (coeficientes.isEmpty) {
        coeficienteCache[talhaoLevantamento.id] = await _coeficientesParaTalhao(
          talhaoLevantamentoId: talhaoLevantamento.id,
          especieId: talhaoLevantamento.especieId,
          modeloMatematicoId: talhaoLevantamento.modeloMatematicoId,
        );
      }
      final volumeArvoreM3 = CalculadoraVolumeFlorestal.volumeArvoreM3(
        dapCm: arvore.dapCm,
        alturaM: arvore.alturaM,
        coeficientes: coeficienteCache[talhaoLevantamento.id]!,
        modeloMatematicoCodigo: modeloMatematico.codigo,
        modeloMatematicoExpressao: modeloMatematico.expressao,
      );
      amostraVolumeM3 += volumeArvoreM3;
      talhaoAcumulador.adicionarArvore(arvore, volumeArvoreM3);

      final faixaIniciar = (arvore.dapCm ~/ 5) * 5;
      diametroFaixas[faixaIniciar] = (diametroFaixas[faixaIniciar] ?? 0) + 1;
    }

    final diametroClasses = [
      for (final registro
          in diametroFaixas.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)))
        ResumoClasseDiametro(
          iniciarCm: registro.key,
          fimCm: registro.key + 4,
          quantidade: registro.value,
        ),
    ];

    final talhoes =
        talhoesPorId.values.map((item) => item.paraResumo()).toList()..sort(
          (a, b) => a.talhao.identificacao.compareTo(b.talhao.identificacao),
        );
    final estimadoVolumeM3 = talhoes.fold<double>(
      0,
      (total, talhao) => total + (talhao.estimadoVolumeM3 ?? 0),
    );

    return PainelResultados(
      parcelaQuantidade: parcelaQuantidade,
      coletadaParcelaQuantidade: coletadaParcelaQuantidade,
      medidaParcelaQuantidade: medidaParcelaQuantidade,
      arvoreQuantidade: arvoreQuantidade,
      medidaAreaHa: medidaAreaHa,
      mediaDapCm: arvoreQuantidade == 0 ? null : dapSoma / arvoreQuantidade,
      mediaAlturaM: arvoreQuantidade == 0
          ? null
          : alturaSoma / arvoreQuantidade,
      amostraVolumeM3: amostraVolumeM3,
      volumePorHaM3: medidaAreaHa == 0 ? null : amostraVolumeM3 / medidaAreaHa,
      estimadoVolumeM3: medidaAreaHa == 0 ? null : estimadoVolumeM3,
      arvoresPorHa: medidaAreaHa == 0 ? null : arvoreQuantidade / medidaAreaHa,
      diametroClasses: diametroClasses,
      talhoes: talhoes,
    );
  }

  Future<Map<String, double?>> _coeficientesParaTalhao({
    required int talhaoLevantamentoId,
    required int especieId,
    required int modeloMatematicoId,
  }) async {
    final linhas = await _bancoDados
        .customSelect(
          '''
SELECT simbolo, valor
FROM coeficientes_talhao_levantamento
WHERE talhao_levantamento_id = ?
''',
          variables: [Variable<int>(talhaoLevantamentoId)],
          readsFrom: {_bancoDados.talhaoLevantamentos},
        )
        .get();

    final values = {
      for (final linha in linhas)
        linha.read<String>('simbolo'): linha.readNullable<double>('valor'),
    };
    if (values.isNotEmpty) return values;

    final globalLinhas =
        await (_bancoDados.select(_bancoDados.coeficientesModelo)..where(
              (tabela) => tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();
    final especieLinhas =
        await (_bancoDados.select(_bancoDados.coeficientesEspecieModelo)..where(
              (tabela) =>
                  tabela.especieId.equals(especieId) &
                  tabela.modeloMatematicoId.equals(modeloMatematicoId),
            ))
            .get();
    final especieValores = {
      for (final coeficiente in especieLinhas)
        coeficiente.simbolo: coeficiente.valor,
    };
    return {
      for (final coeficiente in globalLinhas)
        coeficiente.simbolo:
            especieValores[coeficiente.simbolo] ??
            coeficiente.valor ??
            CalculadoraVolumeFlorestal.valorPadraoCoeficiente(
              modeloMatematicoCodigo: await _bancoDados.codigoModeloPorId(
                modeloMatematicoId,
              ),
              simbolo: coeficiente.simbolo,
            ),
    };
  }
}

class _TalhaoResultadosAcumulador {
  _TalhaoResultadosAcumulador({
    required this.talhaoLevantamento,
    required this.talhao,
    required this.especie,
    required this.modeloMatematico,
  });

  final TalhaoLevantamento talhaoLevantamento;
  final Talhao talhao;
  final Especie especie;
  final ModeloMatematico modeloMatematico;
  int parcelaQuantidade = 0;
  int coletadaParcelaQuantidade = 0;
  int medidaParcelaQuantidade = 0;
  int arvoreQuantidade = 0;
  double medidaAreaHa = 0;
  double dapSoma = 0;
  double alturaSoma = 0;
  double amostraVolumeM3 = 0;

  void adicionarParcela(Parcela parcela) {
    parcelaQuantidade++;
    if (parcela.situacao == SituacaoParcela.coletada) {
      coletadaParcelaQuantidade++;
    }
    if (parcela.situacao != SituacaoParcela.pendente) {
      medidaParcelaQuantidade++;
      medidaAreaHa += parcela.areaHa ?? 0;
    }
  }

  void adicionarArvore(Arvore arvore, double volumeM3) {
    arvoreQuantidade++;
    dapSoma += arvore.dapCm;
    alturaSoma += arvore.alturaM;
    amostraVolumeM3 += volumeM3;
  }

  ResumoResultadosTalhao paraResumo() {
    final volumePorHaM3 = medidaAreaHa == 0
        ? null
        : amostraVolumeM3 / medidaAreaHa;
    final estimadoVolumeM3 = volumePorHaM3 == null
        ? null
        : volumePorHaM3 * talhao.areaHa;
    final conversao = CalculadoraVolumeFlorestal.conversaoParaEspecie(
      especie.nome,
    );
    return ResumoResultadosTalhao(
      talhao: talhao,
      especie: especie,
      parcelaQuantidade: parcelaQuantidade,
      coletadaParcelaQuantidade: coletadaParcelaQuantidade,
      medidaParcelaQuantidade: medidaParcelaQuantidade,
      arvoreQuantidade: arvoreQuantidade,
      medidaAreaHa: medidaAreaHa,
      mediaDapCm: arvoreQuantidade == 0 ? null : dapSoma / arvoreQuantidade,
      mediaAlturaM: arvoreQuantidade == 0
          ? null
          : alturaSoma / arvoreQuantidade,
      amostraVolumeM3: amostraVolumeM3,
      volumePorHaM3: volumePorHaM3,
      estimadoVolumeM3: estimadoVolumeM3,
      convertidoEstimadoVolume: estimadoVolumeM3 == null
          ? null
          : conversao.converter(estimadoVolumeM3),
      convertidoVolumePorHa: volumePorHaM3 == null
          ? null
          : conversao.converter(volumePorHaM3),
      convertidoUnidade: conversao.unidade,
      arvoresPorHa: medidaAreaHa == 0 ? null : arvoreQuantidade / medidaAreaHa,
    );
  }
}
