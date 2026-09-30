import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../nucleo/banco/banco_dendro.dart';
import '../../../nucleo/floresta/calculadora_suficiencia_amostral.dart';
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

final provedorFiltroLevantamentoResultados = StateProvider.autoDispose<int?>((
  ref,
) {
  return null;
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
    levantamentoId: ref.watch(provedorFiltroLevantamentoResultados),
    talhaoIds: ref.watch(provedorFiltroTalhoesResultados),
    especieId: ref.watch(provedorFiltroEspecieResultados),
  );

  return ref.watch(provedorRepositorioResultados).observarPainel(filtros);
});

class FiltrosResultados {
  const FiltrosResultados({
    required this.propriedadeId,
    required this.levantamentoId,
    required this.talhaoIds,
    required this.especieId,
  });

  final int? propriedadeId;
  final int? levantamentoId;
  final Set<int> talhaoIds;
  final int? especieId;

  bool get possuiBaseFiltro =>
      propriedadeId != null ||
      levantamentoId != null ||
      especieId != null ||
      talhaoIds.isNotEmpty;
}

class OpcoesFiltrosResultados {
  const OpcoesFiltrosResultados({
    required this.propriedades,
    required this.levantamentos,
    required this.talhoes,
    required this.especies,
  });

  final List<Propriedade> propriedades;
  final List<OpcaoLevantamentoResultados> levantamentos;
  final List<OpcaoTalhaoResultados> talhoes;
  final List<Especie> especies;

  List<OpcaoTalhaoResultados> talhoesVisiveis({
    int? propriedadeId,
    int? levantamentoId,
    int? especieId,
  }) {
    if (propriedadeId == null && levantamentoId == null && especieId == null) {
      return const [];
    }

    final candidatos = talhoes.where((opcao) {
      if (propriedadeId != null &&
          opcao.talhao.propriedadeId != propriedadeId) {
        return false;
      }
      if (levantamentoId != null && opcao.levantamentoId != levantamentoId) {
        return false;
      }
      return true;
    });

    final porTalhao = <int, OpcaoTalhaoResultados>{};
    for (final opcao in candidatos) {
      porTalhao.putIfAbsent(opcao.talhao.id, () => opcao);
    }
    return porTalhao.values
        .where((opcao) => especieId == null || opcao.especie.id == especieId)
        .toList()
      ..sort(
        (a, b) => a.talhao.identificacao.compareTo(b.talhao.identificacao),
      );
  }

  List<OpcaoLevantamentoResultados> levantamentosVisiveis({
    int? propriedadeId,
  }) {
    return levantamentos.where((opcao) {
      return propriedadeId == null || opcao.propriedade.id == propriedadeId;
    }).toList();
  }
}

class OpcaoLevantamentoResultados {
  const OpcaoLevantamentoResultados({
    required this.levantamento,
    required this.propriedade,
  });

  final Levantamento levantamento;
  final Propriedade propriedade;
}

class OpcaoTalhaoResultados {
  const OpcaoTalhaoResultados({
    required this.levantamentoId,
    required this.talhao,
    required this.especie,
  });

  final int levantamentoId;
  final Talhao talhao;
  final Especie especie;
}

class PainelResultados {
  const PainelResultados({
    required this.parcelaQuantidade,
    required this.coletadaParcelaQuantidade,
    required this.medidaParcelaQuantidade,
    required this.arvoreQuantidade,
    required this.troncoTortuosoQuantidade,
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
  final int troncoTortuosoQuantidade;
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

  double get troncoTortuosoPercentual => arvoreQuantidade == 0
      ? 0
      : troncoTortuosoQuantidade / arvoreQuantidade * 100;

  factory PainelResultados.vazio() {
    return const PainelResultados(
      parcelaQuantidade: 0,
      coletadaParcelaQuantidade: 0,
      medidaParcelaQuantidade: 0,
      arvoreQuantidade: 0,
      troncoTortuosoQuantidade: 0,
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
    required this.troncoTortuosoQuantidade,
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
    required this.suficienciaAmostral,
  });

  final Talhao talhao;
  final Especie especie;
  final int parcelaQuantidade;
  final int coletadaParcelaQuantidade;
  final int medidaParcelaQuantidade;
  final int arvoreQuantidade;
  final int troncoTortuosoQuantidade;
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
  final ResultadoSuficienciaAmostral suficienciaAmostral;

  double get troncoTortuosoPercentual => arvoreQuantidade == 0
      ? 0
      : troncoTortuosoQuantidade / arvoreQuantidade * 100;
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
            _bancoDados.talhaoLevantamentos,
            _bancoDados.talhaoLevantamentos.talhaoId.equalsExp(
              _bancoDados.talhoes.id,
            ),
          ),
          leftOuterJoin(
            _bancoDados.levantamentos,
            _bancoDados.levantamentos.id.equalsExp(
              _bancoDados.talhaoLevantamentos.levantamentoId,
            ),
          ),
          leftOuterJoin(
            _bancoDados.especies,
            _bancoDados.especies.id.equalsExp(
              _bancoDados.talhaoLevantamentos.especieId,
            ),
          ),
        ])..orderBy([
          OrderingTerm.asc(_bancoDados.propriedades.nome),
          OrderingTerm.desc(_bancoDados.levantamentos.iniciadoEm),
          OrderingTerm.asc(_bancoDados.talhoes.identificacao),
        ]);

    return consulta.watch().map((linhas) {
      final propriedadesPorId = <int, Propriedade>{};
      final levantamentosPorId = <int, OpcaoLevantamentoResultados>{};
      final talhoesPorVinculo = <String, OpcaoTalhaoResultados>{};
      final especiePorId = <int, Especie>{};

      for (final linha in linhas) {
        final propriedade = linha.readTable(_bancoDados.propriedades);
        propriedadesPorId[propriedade.id] = propriedade;

        final talhao = linha.readTableOrNull(_bancoDados.talhoes);
        final levantamento = linha.readTableOrNull(_bancoDados.levantamentos);
        final especie = linha.readTableOrNull(_bancoDados.especies);
        if (levantamento != null) {
          levantamentosPorId[levantamento.id] = OpcaoLevantamentoResultados(
            levantamento: levantamento,
            propriedade: propriedade,
          );
        }
        if (talhao == null || levantamento == null || especie == null) continue;

        talhoesPorVinculo['${levantamento.id}:${talhao.id}'] =
            OpcaoTalhaoResultados(
              levantamentoId: levantamento.id,
              talhao: talhao,
              especie: especie,
            );
        especiePorId[especie.id] = especie;
      }

      final propriedades = propriedadesPorId.values.toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));
      final levantamentos = levantamentosPorId.values.toList()
        ..sort(
          (a, b) =>
              b.levantamento.iniciadoEm.compareTo(a.levantamento.iniciadoEm),
        );
      final levantamentoPorId = {
        for (final opcao in levantamentos)
          opcao.levantamento.id: opcao.levantamento,
      };
      final talhoes = talhoesPorVinculo.values.toList()
        ..sort((a, b) {
          final comparacaoData = levantamentoPorId[b.levantamentoId]!.iniciadoEm
              .compareTo(levantamentoPorId[a.levantamentoId]!.iniciadoEm);
          if (comparacaoData != 0) return comparacaoData;
          return b.levantamentoId.compareTo(a.levantamentoId);
        });
      final especies = especiePorId.values.toList()
        ..sort((a, b) => a.nome.compareTo(b.nome));

      return OpcoesFiltrosResultados(
        propriedades: propriedades,
        levantamentos: levantamentos,
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

    final condicoes = <Expression<bool>>[
      _bancoDados.parcelas.situacao.equalsValue(SituacaoParcela.coletada),
    ];
    if (filtros.propriedadeId != null) {
      condicoes.add(_bancoDados.propriedades.id.equals(filtros.propriedadeId!));
    }
    if (filtros.levantamentoId != null) {
      condicoes.add(
        _bancoDados.levantamentos.id.equals(filtros.levantamentoId!),
      );
    }
    if (filtros.talhaoIds.isNotEmpty) {
      condicoes.add(_bancoDados.talhoes.id.isIn(filtros.talhaoIds));
    }
    if (condicoes.isNotEmpty) {
      consulta.where(condicoes.reduce((valor, elemento) => valor & elemento));
    }

    return consulta.watch().asyncMap(
      (linhas) => _montarPainelDasLinhas(
        linhas,
        usarUltimoLevantamentoPorTalhao: filtros.levantamentoId == null,
        especieId: filtros.especieId,
      ),
    );
  }

  Future<PainelResultados> _montarPainelDasLinhas(
    List<TypedResult> linhas, {
    required bool usarUltimoLevantamentoPorTalhao,
    required int? especieId,
  }) async {
    if (usarUltimoLevantamentoPorTalhao) {
      linhas = _somenteUltimoLevantamentoPorTalhao(linhas);
    }
    if (especieId != null) {
      linhas = linhas.where((linha) {
        return linha.readTable(_bancoDados.talhaoLevantamentos).especieId ==
            especieId;
      }).toList();
    }
    final vistosParcelas = <int>{};
    final vistosArvores = <int>{};
    final diametroFaixas = <int, int>{};
    final talhoesPorId = <int, _TalhaoResultadosAcumulador>{};
    final coeficienteCache = <int, Map<String, double?>>{};

    var parcelaQuantidade = 0;
    var coletadaParcelaQuantidade = 0;
    var medidaParcelaQuantidade = 0;
    var arvoreQuantidade = 0;
    var troncoTortuosoQuantidade = 0;
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
      if (arvore.possuiTroncoTortuoso) troncoTortuosoQuantidade++;
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
      talhaoAcumulador.adicionarArvore(
        arvore,
        parcelaId: parcela.id,
        volumeM3: volumeArvoreM3,
      );

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
      troncoTortuosoQuantidade: troncoTortuosoQuantidade,
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

  List<TypedResult> _somenteUltimoLevantamentoPorTalhao(
    List<TypedResult> linhas,
  ) {
    final ultimoPorTalhao =
        <int, ({DateTime iniciadoEm, int levantamentoId})>{};
    for (final linha in linhas) {
      final talhao = linha.readTable(_bancoDados.talhoes);
      final levantamento = linha.readTable(_bancoDados.levantamentos);
      final atual = ultimoPorTalhao[talhao.id];
      if (atual == null ||
          levantamento.iniciadoEm.isAfter(atual.iniciadoEm) ||
          (levantamento.iniciadoEm.compareTo(atual.iniciadoEm) == 0 &&
              levantamento.id > atual.levantamentoId)) {
        ultimoPorTalhao[talhao.id] = (
          iniciadoEm: levantamento.iniciadoEm,
          levantamentoId: levantamento.id,
        );
      }
    }

    return linhas.where((linha) {
      final talhao = linha.readTable(_bancoDados.talhoes);
      final levantamento = linha.readTable(_bancoDados.levantamentos);
      return ultimoPorTalhao[talhao.id]?.levantamentoId == levantamento.id;
    }).toList();
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
  int troncoTortuosoQuantidade = 0;
  double medidaAreaHa = 0;
  double dapSoma = 0;
  double alturaSoma = 0;
  double amostraVolumeM3 = 0;
  final Map<int, double> _volumePorParcelaM3 = {};
  final Map<int, double?> _areaPorParcelaHa = {};

  void adicionarParcela(Parcela parcela) {
    parcelaQuantidade++;
    _volumePorParcelaM3[parcela.id] = 0;
    _areaPorParcelaHa[parcela.id] = parcela.areaHa;
    if (parcela.situacao == SituacaoParcela.coletada) {
      coletadaParcelaQuantidade++;
    }
    if (parcela.situacao != SituacaoParcela.pendente) {
      medidaParcelaQuantidade++;
      medidaAreaHa += parcela.areaHa ?? 0;
    }
  }

  void adicionarArvore(
    Arvore arvore, {
    required int parcelaId,
    required double volumeM3,
  }) {
    arvoreQuantidade++;
    if (arvore.possuiTroncoTortuoso) troncoTortuosoQuantidade++;
    dapSoma += arvore.dapCm;
    alturaSoma += arvore.alturaM;
    amostraVolumeM3 += volumeM3;
    _volumePorParcelaM3[parcelaId] =
        (_volumePorParcelaM3[parcelaId] ?? 0) + volumeM3;
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
    final areasValidas = _areaPorParcelaHa.values
        .whereType<double>()
        .where((area) => area > 0)
        .toList(growable: false);
    final volumesPorHaM3 = <double>[
      for (final entrada in _volumePorParcelaM3.entries)
        if ((_areaPorParcelaHa[entrada.key] ?? 0) > 0)
          entrada.value / _areaPorParcelaHa[entrada.key]!,
    ];
    final larguraParcelaM = talhao.larguraParcelaM;
    final comprimentoParcelaM = talhao.comprimentoParcelaM;
    final areaPadraoParcelaHa =
        larguraParcelaM != null &&
            larguraParcelaM > 0 &&
            comprimentoParcelaM != null &&
            comprimentoParcelaM > 0
        ? larguraParcelaM * comprimentoParcelaM / 10000
        : areasValidas.isEmpty
        ? null
        : areasValidas.fold<double>(0, (total, area) => total + area) /
              areasValidas.length;
    final unidadesAmostraisPossiveis =
        areaPadraoParcelaHa == null || areaPadraoParcelaHa <= 0
        ? null
        : talhao.areaHa / areaPadraoParcelaHa;
    final suficienciaAmostral = CalculadoraSuficienciaAmostral.calcular(
      volumesPorHaM3: volumesPorHaM3,
      erroMaximoPercentual: talhaoLevantamento.erroAmostralMaximoPercentual,
      unidadesAmostraisPossiveis: unidadesAmostraisPossiveis,
    );
    return ResumoResultadosTalhao(
      talhao: talhao,
      especie: especie,
      parcelaQuantidade: parcelaQuantidade,
      coletadaParcelaQuantidade: coletadaParcelaQuantidade,
      medidaParcelaQuantidade: medidaParcelaQuantidade,
      arvoreQuantidade: arvoreQuantidade,
      troncoTortuosoQuantidade: troncoTortuosoQuantidade,
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
      suficienciaAmostral: suficienciaAmostral,
    );
  }
}
