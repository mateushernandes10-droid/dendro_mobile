import 'package:drift/drift.dart';

/// Identificadores legados permanecem aqui para abrir bancos das versões 1–9.
/// IDs, medições, datas, expressões e coeficientes não são recriados.
const nomesTabelasLegadas = {
  'properties': 'propriedades',
  'stands': 'talhoes',
  'species': 'especies',
  'formulas': 'modelos_matematicos',
  'formula_variables': 'variaveis_modelo',
  'formula_coefficients': 'coeficientes_modelo',
  'species_formulas': 'especies_modelos',
  'species_formula_coefficients': 'coeficientes_especie_modelo',
  'inventory_runs': 'levantamentos',
  'talhao_levantamentos': 'talhao_levantamentos',
  'talhao_formula_coefficients': 'coeficientes_talhao_levantamento',
  'plots': 'parcelas',
  'plot_geo_points': 'pontos_geograficos_parcela',
  'trees': 'arvores',
  'activity_logs': 'registros_atividade',
};

const nomesColunasLegadas = {
  'name': 'nome',
  'municipality': 'municipio',
  'state': 'estado',
  'total_area_ha': 'area_total_ha',
  'created_at': 'criado_em',
  'updated_at': 'atualizado_em',
  'scientific_name': 'nome_cientifico',
  'description': 'descricao',
  'active': 'ativo',
  'expression': 'expressao',
  'formula_id': 'modelo_matematico_id',
  'symbol': 'simbolo',
  'label': 'rotulo',
  'unit': 'unidade',
  'value_source': 'origem_valor',
  'variable_key': 'chave_variavel',
  'value': 'valor',
  'species_id': 'especie_id',
  'is_default': 'padrao',
  'property_id': 'propriedade_id',
  'identification': 'identificacao',
  'planting_year': 'ano_plantio',
  'spacing': 'espacamento',
  'management_regime': 'regime_manejo',
  'plot_width_m': 'largura_parcela_m',
  'plot_length_m': 'comprimento_parcela_m',
  'notes': 'observacoes',
  'status': 'situacao',
  'started_at': 'iniciado_em',
  'completed_at': 'concluido_em',
  'inventory_run_id': 'levantamento_id',
  'stand_id': 'talhao_id',
  'default_plot_area_ha': 'area_padrao_parcela_ha',
  'reference_position': 'posicao_referencia',
  'plot_id': 'parcela_id',
  'point_order': 'ordem_ponto',
  'accuracy_meters': 'precisao_metros',
  'captured_at': 'capturado_em',
  'number': 'numero',
  'height_m': 'altura_m',
  'has_tortuous_stem': 'possui_tronco_tortuoso',
  'location_captured_at': 'localizacao_capturada_em',
  'plot_reference_position': 'posicao_referencia_parcela',
  'type': 'tipo',
  'title': 'titulo',
  'subtitle': 'subtitulo',
  'entity_type': 'tipo_entidade',
  'entity_id': 'entidade_id',
  'occurred_at': 'ocorrido_em',
};

Future<void> migrarNomenclaturaParaPortugues(GeneratedDatabase banco) async {
  final registros = await banco
      .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
      .get();
  final tabelas = registros.map((linha) => linha.read<String>('name')).toSet();
  for (final entrada in nomesTabelasLegadas.entries) {
    final antigo = entrada.key;
    final novo = entrada.value;
    if (antigo != novo && tabelas.contains(antigo)) {
      if (tabelas.contains(novo)) {
        throw StateError(
          'Migração ambígua: tabelas $antigo e $novo coexistem.',
        );
      }
      await banco.customStatement('ALTER TABLE "$antigo" RENAME TO "$novo"');
      tabelas.remove(antigo);
      tabelas.add(novo);
    }
    if (!tabelas.contains(novo)) continue;
    final campos = await banco.customSelect('PRAGMA table_info("$novo")').get();
    final colunas = campos.map((linha) => linha.read<String>('name')).toSet();
    for (final coluna in nomesColunasLegadas.entries) {
      if (!colunas.contains(coluna.key)) continue;
      if (colunas.contains(coluna.value)) {
        throw StateError('Migração ambígua na tabela $novo: coluna duplicada.');
      }
      await banco.customStatement(
        'ALTER TABLE "$novo" RENAME COLUMN "${coluna.key}" TO "${coluna.value}"',
      );
    }
  }
  await _traduzirValores(banco, tabelas, 'levantamentos', 'situacao', {
    'planning': 'planejamento',
    'inProgress': 'emAndamento',
    'completed': 'concluido',
  });
  await _traduzirValores(banco, tabelas, 'parcelas', 'situacao', {
    'pending': 'pendente',
    'inProgress': 'emAndamento',
    'collected': 'coletada',
  });
  await _traduzirValores(banco, tabelas, 'variaveis_modelo', 'chave_variavel', {
    'height': 'altura',
    'age': 'idade',
    'basalArea': 'areaBasal',
  });
  await _traduzirAtividades(banco, tabelas);
}

Future<void> _traduzirValores(
  GeneratedDatabase banco,
  Set<String> tabelas,
  String tabela,
  String coluna,
  Map<String, String> valores,
) async {
  if (!tabelas.contains(tabela)) return;
  for (final entrada in valores.entries) {
    await banco.customStatement(
      'UPDATE "$tabela" SET "$coluna" = ? WHERE "$coluna" = ?',
      [entrada.value, entrada.key],
    );
  }
}

Future<void> _traduzirAtividades(
  GeneratedDatabase banco,
  Set<String> tabelas,
) async {
  await _traduzirValores(banco, tabelas, 'registros_atividade', 'tipo', {
    'propertyCreated': 'propriedadeCriada',
    'propertyUpdated': 'propriedadeAtualizada',
    'propertyDeleted': 'propriedadeExcluida',
    'standCreated': 'talhaoCriado',
    'standUpdated': 'talhaoAtualizado',
    'standDeleted': 'talhaoExcluido',
    'plotCreated': 'parcelaCriada',
    'plotUpdated': 'parcelaAtualizada',
    'plotDeleted': 'parcelaExcluida',
    'plotCollected': 'parcelaColetada',
    'speciesCreated': 'especieCriada',
    'speciesUpdated': 'especieAtualizada',
    'speciesDeleted': 'especieExcluida',
    'speciesFormulaLinked': 'especieModeloMatematicoVinculado',
    'speciesFormulaUnlinked': 'especieModeloMatematicoDesvinculado',
    'speciesDefaultFormulaChanged': 'especiePadraoModeloMatematicoAlterado',
    'formulaCreated': 'modeloMatematicoCriado',
    'formulaUpdated': 'modeloMatematicoAtualizado',
    'formulaDeleted': 'modeloMatematicoExcluido',
    'formulaCoefficientsUpdated': 'modeloMatematicoCoeficientesAtualizado',
    'inventoryRunStarted': 'levantamentoIniciado',
    'inventoryRunCompleted': 'levantamentoConcluido',
    'inventoryRunDeleted': 'levantamentoExcluido',
    'inventoryRunStandAdded': 'talhaoAdicionadoLevantamento',
    'inventoryRunStandUpdated': 'talhaoAtualizadoLevantamento',
    'inventoryRunStandRemoved': 'talhaoRemovidoLevantamento',
    'standCompleted': 'talhaoConcluido',
    'exportCreated': 'exportacaoCriada',
  });
  await _traduzirValores(
    banco,
    tabelas,
    'registros_atividade',
    'tipo_entidade',
    {
      'property': 'propriedade',
      'stand': 'talhao',
      'plot': 'parcela',
      'species': 'especie',
      'formula': 'modeloMatematico',
      'inventoryRun': 'levantamento',
      'export': 'exportacao',
    },
  );
}
