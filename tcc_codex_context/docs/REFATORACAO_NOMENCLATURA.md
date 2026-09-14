# Refatoração de nomenclatura — DENDRO Mobile

Relatório histórico da v10. A versão atual é v11: consultar REFATORACAO_IDS_INTEIROS.md. Os IDs preservados nesta etapa foram posteriormente convertidos para inteiros.

Concluída em 13/09/2026 sobre a base 82f29e2. O commit 740f170 já contém a maior parte da refatoração; a conclusão inclui formatação, verificações e documentação. O inventário abaixo considera toda a diferença desde a base, inclusive os arquivos já presentes nesse commit.

## Escopo e decisões

Classes, registros, enums, repositórios, provedores, telas, métodos, parâmetros e variáveis próprios foram traduzidos, assim como os caminhos internos. ModeloMatematico designa o cadastro de expressão, variáveis e coeficientes. Propriedade, Talhao, Especie, Levantamento, Parcela, Arvore e PontoGeograficoParcela conservam suas responsabilidades. RepositorioResultados produz PainelResultados em memória; não foi criada tabela de resultados nem camada fictícia.

Exemplos: PropertyRecord → Propriedade; StandRecord → Talhao; TreeRecord → Arvore; FormulaRecord → ModeloMatematico; InventoryRunRecord → Levantamento; PlotRecord → Parcela; ActivityLogEntry → RegistroAtividade. propertyId → propriedadeId; heightM → alturaM; hasTortuousStem → possuiTroncoTortuoso. DAP continua dapCm; latitude e longitude permanecem iguais.

## Banco e migração

Schema anterior: **9**. Schema atual: **10**. Permanecem **15 tabelas e 112 colunas**, com os mesmos relacionamentos e cardinalidades.

| Tabela anterior | Tabela atual |
|---|---|
| properties | propriedades |
| stands | talhoes |
| species | especies |
| formulas | modelos_matematicos |
| formula_variables | variaveis_modelo |
| formula_coefficients | coeficientes_modelo |
| species_formulas | especies_modelos |
| species_formula_coefficients | coeficientes_especie_modelo |
| inventory_runs | levantamentos |
| talhao_levantamentos | talhao_levantamentos |
| talhao_formula_coefficients | coeficientes_talhao_levantamento |
| plots | parcelas |
| plot_geo_points | pontos_geograficos_parcela |
| trees | arvores |
| activity_logs | registros_atividade |

BancoDendro executa migrarNomenclaturaParaPortugues dentro da transação de atualização. A estratégia usa ALTER TABLE RENAME TO e RENAME COLUMN; não apaga/recria tabelas existentes. SQLite atualiza as referências dos relacionamentos e índices. Nomes ambíguos geram erro e a transação reverte as alterações.

Os valores persistidos de enums de situação, variáveis e atividades são convertidos. IDs, números, medições, datas, coordenadas, coeficientes e expressões existentes são preservados na migração v9 → v10. Para versões 1–8, a tradução precede as migrações históricas que já atualizavam o catálogo e acrescentavam estruturas. O arquivo de banco continua usando o nome dendro_mobile para abrir os dados já instalados.

As consultas manuais de coeficientes_talhao_levantamento e registros_atividade foram atualizadas. Instalações novas criam diretamente os nomes portugueses. A atualização não exige reset do emulador nem exclusão dos dados.

## Verificação

- dart run build_runner build: concluído; código Drift gerado consistente com os novos caminhos.
- dart format lib test: 47 arquivos; verificação final sem alterações pendentes de formatação.
- flutter analyze --no-pub: nenhum apontamento.
- flutter test --no-pub: 47 testes aprovados (36 existentes e 11 novos).
- flutter build apk --debug --no-pub: compilação concluída, incluindo a integração Kotlin; APK em build/app/outputs/flutter-apk/app-debug.apk. O SDK emitiu aviso de versões XML diferentes entre ferramentas Android, sem impedir o build.
- git diff --check: sem erros de espaços ou marcadores de conflito.
- Migração: fixtures SQL da v9, estruturas anteriores derivadas das etapas históricas v1–8, preservação dos dados, tradução de todos os enums, esquema novo versus migrado, chaves estrangeiras, índices únicos, integridade, escrita/reabertura e rollback com nova tentativa.
- Diagramas: 15 tabelas e 112 colunas comparadas com a estrutura legada e o mapa de migração, incluindo tipos e nulabilidade; oito fontes Mermaid coincidem com ENGINEERING_MODELS.md. Não houve renderização/revisão visual de PNG/SVG.

Os cálculos conservam as mesmas operações, coeficientes padrão e seleção de modelos. Fator de Forma permanece pi × (dapCm / 100)² × alturaM × ff, sem divisão por 4. Testes automatizados não substituem validação florestal em campo ou teste manual em todos os aparelhos. Não foi instalado o APK nem iniciado o emulador durante esta conclusão.

## Nomes mantidos em inglês e motivo

- Bibliotecas, APIs externas e overrides: Flutter/Dart, Drift, Riverpod, Geolocator, build, createState, initState, dispose, schemaVersion, migration, primaryKey e contratos equivalentes.
- Código gerado: Companion, copyWith, toJson, fromJson e demais nomes emitidos pelo gerador do Drift. Não são APIs próprias a traduzir manualmente.
- SQL/SQLite: SELECT, PRAGMA, sqlite_master, tipos e metadados são contratos da plataforma.
- Migração e fixtures: nomes antigos são necessários para reconhecer e testar bancos v1–9; decisões históricas preservam a terminologia da época.
- Valores estáveis: IDs como formula_spurr e species_pinus, identificadores de interface, nome do banco, arquivo/chave darkMode das preferências e chaves de integração Android. Renomeá-los poderia mudar a compatibilidade e o comportamento existente.
- Android: MainActivity, package/applicationId e métodos de ciclo de vida permanecem estáveis. Helpers e variáveis próprios de salvamento foram traduzidos, mas o canal file_saver, método saveFile e chaves path/fileName/mimeType continuam compatíveis entre Dart e Kotlin.
- Estrutura padrão das plataformas e configurações das ferramentas (main.dart, pubspec.yaml, Gradle e arquivos gerados) conservam os nomes esperados por seus ecossistemas. DAP, GPS, PDF, CSV, XLSX, KML e identificadores científicos são siglas/formato, não termos a traduzir.

## Arquivos alterados ou adicionados

Caminhos relativos à raiz do projeto; inclui código gerado, testes, configuração, documentação e fontes Mermaid. Arquivos renomeados têm o destino listado aqui e a origem na tabela seguinte.

- README.md
- android/app/src/main/kotlin/br/com/dendromobile/app/MainActivity.kt
- lib/aplicativo/aplicativo_dendro.dart
- lib/aplicativo/tema/tema_dendro.dart
- lib/compartilhado/componentes/componentes_dendro.dart
- lib/funcionalidades/abertura/apresentacao/tela_abertura.dart
- lib/funcionalidades/ajustes/apresentacao/tela_ajustes.dart
- lib/funcionalidades/ajustes/dados/repositorio_ajustes.dart
- lib/funcionalidades/atividades/apresentacao/componentes_atividades.dart
- lib/funcionalidades/atividades/apresentacao/tela_historico_atividades.dart
- lib/funcionalidades/atividades/dados/repositorio_atividades.dart
- lib/funcionalidades/coleta_arvores/apresentacao/tela_coleta_arvores.dart
- lib/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart
- lib/funcionalidades/estrutura/apresentacao/estrutura_dendro.dart
- lib/funcionalidades/estrutura/apresentacao/navegacao_estrutura_dendro.dart
- lib/funcionalidades/exportacao_dados/apresentacao/tela_exportacao_dados.dart
- lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart
- lib/funcionalidades/inicio/apresentacao/tela_inicio.dart
- lib/funcionalidades/levantamentos/apresentacao/componentes/painel_selecao_modelo_levantamento.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_detalhe_levantamento.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_levantamentos.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_novo_levantamento.dart
- lib/funcionalidades/levantamentos/dados/repositorio_levantamentos.dart
- lib/funcionalidades/levantamentos/dados/selecao_modelo_levantamento.dart
- lib/funcionalidades/parcelas/apresentacao/tela_parcelas_talhao.dart
- lib/funcionalidades/parcelas/dados/repositorio_parcelas.dart
- lib/funcionalidades/propriedades/apresentacao/tela_detalhe_propriedade.dart
- lib/funcionalidades/propriedades/apresentacao/tela_propriedades.dart
- lib/funcionalidades/propriedades/dados/repositorio_propriedades.dart
- lib/funcionalidades/resultados/apresentacao/tela_resultados.dart
- lib/funcionalidades/resultados/dados/repositorio_resultados.dart
- lib/funcionalidades/talhoes/dados/repositorio_talhoes.dart
- lib/main.dart
- lib/nucleo/banco/banco_dendro.dart
- lib/nucleo/banco/banco_dendro.g.dart
- lib/nucleo/banco/migracao_nomenclatura.dart
- lib/nucleo/constantes/recursos_dendro.dart
- lib/nucleo/floresta/calculadora_volume_florestal.dart
- lib/nucleo/plataforma/salvador_arquivo_android.dart
- lib/nucleo/preferencias/controlador_tema.dart
- lib/nucleo/provedores/provedores_banco.dart
- pubspec.lock
- pubspec.yaml
- tcc_codex_context/AGENTS.md
- tcc_codex_context/docs/ARCHITECTURE.md
- tcc_codex_context/docs/BUSINESS_RULES.md
- tcc_codex_context/docs/DECISIONS.md
- tcc_codex_context/docs/ENGINEERING_MODELS.md
- tcc_codex_context/docs/IMPLEMENTATION_NOTES.md
- tcc_codex_context/docs/PROJECT_CONTEXT.md
- tcc_codex_context/docs/REFATORACAO_NOMENCLATURA.md
- tcc_codex_context/docs/REQUIREMENTS.md
- tcc_codex_context/docs/UI_REFERENCE.md
- tcc_codex_context/docs/diagrams/02_arquitetura.mmd
- tcc_codex_context/docs/diagrams/03_banco_relacionamentos.mmd
- tcc_codex_context/docs/diagrams/04_banco_completo.mmd
- tcc_codex_context/docs/diagrams/06_sequencia_resultados.mmd
- tcc_codex_context/docs/diagrams/08_classes_dados.mmd
- tcc_codex_context/docs/diagrams/README.md
- test/fixtures/enums_v9.json
- test/fixtures/esquema_v9.sql
- test/funcionalidades/exportacao_dados/exportacao_bruta_test.dart
- test/funcionalidades/propriedades/tela_propriedades_test.dart
- test/interface_test.dart
- test/nucleo/banco/banco_dendro_test.dart
- test/nucleo/banco/migracao_fator_forma_test.dart
- test/nucleo/banco/migracao_nomenclatura_test.dart
- test/nucleo/floresta/calculadora_volume_florestal_test.dart
- test/nucleo/preferencias/controlador_tema_test.dart

## Caminhos renomeados

| Caminho anterior | Caminho atual |
|---|---|
| lib/app/dendro_app.dart | lib/aplicativo/aplicativo_dendro.dart |
| lib/app/theme/dendro_theme.dart | lib/aplicativo/tema/tema_dendro.dart |
| lib/core/constants/dendro_assets.dart | lib/nucleo/constantes/recursos_dendro.dart |
| lib/core/database/dendro_database.dart | lib/nucleo/banco/banco_dendro.dart |
| lib/core/database/dendro_database.g.dart | lib/nucleo/banco/banco_dendro.g.dart |
| lib/core/forest/forest_volume_calculator.dart | lib/nucleo/floresta/calculadora_volume_florestal.dart |
| lib/core/platform/android_file_saver.dart | lib/nucleo/plataforma/salvador_arquivo_android.dart |
| lib/core/preferences/theme_mode_controller.dart | lib/nucleo/preferencias/controlador_tema.dart |
| lib/core/providers/database_providers.dart | lib/nucleo/provedores/provedores_banco.dart |
| lib/features/activity_log/data/activity_log_repository.dart | lib/funcionalidades/atividades/dados/repositorio_atividades.dart |
| lib/features/activity_log/presentation/activity_log_screen.dart | lib/funcionalidades/atividades/apresentacao/tela_historico_atividades.dart |
| lib/features/activity_log/presentation/activity_log_widgets.dart | lib/funcionalidades/atividades/apresentacao/componentes_atividades.dart |
| lib/features/data_export/data/data_export_repository.dart | lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart |
| lib/features/data_export/presentation/data_export_screen.dart | lib/funcionalidades/exportacao_dados/apresentacao/tela_exportacao_dados.dart |
| lib/features/home/presentation/home_screen.dart | lib/funcionalidades/inicio/apresentacao/tela_inicio.dart |
| lib/features/inventory_runs/data/inventory_formula_selection.dart | lib/funcionalidades/levantamentos/dados/selecao_modelo_levantamento.dart |
| lib/features/inventory_runs/data/inventory_runs_repository.dart | lib/funcionalidades/levantamentos/dados/repositorio_levantamentos.dart |
| lib/features/inventory_runs/presentation/inventory_run_detail_screen.dart | lib/funcionalidades/levantamentos/apresentacao/tela_detalhe_levantamento.dart |
| lib/features/inventory_runs/presentation/inventory_runs_screen.dart | lib/funcionalidades/levantamentos/apresentacao/tela_levantamentos.dart |
| lib/features/inventory_runs/presentation/new_inventory_screen.dart | lib/funcionalidades/levantamentos/apresentacao/tela_novo_levantamento.dart |
| lib/features/inventory_runs/presentation/widgets/inventory_formula_selection_sheet.dart | lib/funcionalidades/levantamentos/apresentacao/componentes/painel_selecao_modelo_levantamento.dart |
| lib/features/plots/data/plots_repository.dart | lib/funcionalidades/parcelas/dados/repositorio_parcelas.dart |
| lib/features/plots/presentation/stand_plots_screen.dart | lib/funcionalidades/parcelas/apresentacao/tela_parcelas_talhao.dart |
| lib/features/properties/data/properties_repository.dart | lib/funcionalidades/propriedades/dados/repositorio_propriedades.dart |
| lib/features/properties/presentation/properties_screen.dart | lib/funcionalidades/propriedades/apresentacao/tela_propriedades.dart |
| lib/features/properties/presentation/property_detail_screen.dart | lib/funcionalidades/propriedades/apresentacao/tela_detalhe_propriedade.dart |
| lib/features/results/data/results_repository.dart | lib/funcionalidades/resultados/dados/repositorio_resultados.dart |
| lib/features/results/presentation/results_screen.dart | lib/funcionalidades/resultados/apresentacao/tela_resultados.dart |
| lib/features/settings/data/settings_repository.dart | lib/funcionalidades/ajustes/dados/repositorio_ajustes.dart |
| lib/features/settings/presentation/settings_screen.dart | lib/funcionalidades/ajustes/apresentacao/tela_ajustes.dart |
| lib/features/shell/presentation/dendro_shell.dart | lib/funcionalidades/estrutura/apresentacao/estrutura_dendro.dart |
| lib/features/shell/presentation/dendro_shell_navigation.dart | lib/funcionalidades/estrutura/apresentacao/navegacao_estrutura_dendro.dart |
| lib/features/splash/presentation/splash_screen.dart | lib/funcionalidades/abertura/apresentacao/tela_abertura.dart |
| lib/features/stands/data/stands_repository.dart | lib/funcionalidades/talhoes/dados/repositorio_talhoes.dart |
| lib/features/tree_collection/data/trees_repository.dart | lib/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart |
| lib/features/tree_collection/presentation/tree_collection_screen.dart | lib/funcionalidades/coleta_arvores/apresentacao/tela_coleta_arvores.dart |
| lib/shared/widgets/dendro_widgets.dart | lib/compartilhado/componentes/componentes_dendro.dart |
| test/core/database/dendro_database_test.dart | test/nucleo/banco/banco_dendro_test.dart |
| test/core/database/form_factor_migration_test.dart | test/nucleo/banco/migracao_fator_forma_test.dart |
| test/core/forest/forest_volume_calculator_test.dart | test/nucleo/floresta/calculadora_volume_florestal_test.dart |
| test/core/preferences/theme_mode_controller_test.dart | test/nucleo/preferencias/controlador_tema_test.dart |
| test/features/data_export/raw_data_export_test.dart | test/funcionalidades/exportacao_dados/exportacao_bruta_test.dart |
| test/features/properties/properties_screen_test.dart | test/funcionalidades/propriedades/tela_propriedades_test.dart |
| test/widget_test.dart | test/interface_test.dart |
