# Arquitetura implementada — DENDRO Mobile

Revisão em 13/09/2026, baseada no código do commit `ce282bb`. Este documento descreve a versão atual, não uma arquitetura a implementar.

## Organização efetiva

O aplicativo Android usa Flutter/Dart, Riverpod e SQLite com Drift. Coleta, persistência e cálculos ocorrem no dispositivo, sem backend, conta de usuário ou sincronização em nuvem.

A organização é por funcionalidades. As telas consomem providers Riverpod e repositórios; os repositórios acessam o banco e também executam parte da orquestração e das agregações. Não existe uma camada Application/Domain completa e separada em todas as funcionalidades. Os registros gerados pelo Drift são usados diretamente em diferentes partes do aplicativo.

| Responsabilidade | Implementação |
|---|---|
| Inicialização, tema e navegação | `lib/main.dart`, `lib/app/`, `lib/features/shell/` |
| Telas e estado | `lib/features/*/presentation/`, providers Riverpod |
| Instância do banco | `lib/core/providers/database_providers.dart` |
| Tabelas, catálogo inicial e migrações | `lib/core/database/dendro_database.dart` |
| Código gerado do Drift | `lib/core/database/dendro_database.g.dart` |
| Persistência e orquestração | `lib/features/*/data/` |
| Equações por árvore e conversões | `lib/core/forest/forest_volume_calculator.dart` |
| Agregações do painel | `lib/features/results/data/results_repository.dart` |
| Geração de arquivos e agregações dos relatórios | `lib/features/data_export/data/data_export_repository.dart` |
| GPS | Chamadas ao Geolocator na tela de coleta; armazenamento em TreesRepository |
| Salvamento de arquivo no Android | `lib/core/platform/android_file_saver.dart` e integração de plataforma |
| Preferência de tema | `lib/core/preferences/theme_mode_controller.dart` |
| Histórico de atividades | `lib/features/activity_log/` |

As funcionalidades existentes são: activity_log, data_export, home, inventory_runs, plots, properties, results, settings, shell, splash, stands e tree_collection. Os catálogos de espécies e fórmulas ficam em settings, não em módulos independentes species/formulas.

## Dependências efetivamente declaradas

Além do Flutter e dos ícones, o pubspec declara drift, drift_flutter, flutter_riverpod, path_provider, uuid, geolocator, share_plus, pdf e excel. Os testes e a geração de código usam flutter_test, flutter_lints, drift_dev e build_runner.

Não estão instaladas math_expressions, fl_chart, printing ou csv. CSV e KML são montados pelo código do exportador. Não representar essas bibliotecas ausentes como componentes implementados.

## Banco e histórico

O esquema é versão 9. Há 13 tabelas registradas em @DriftDatabase e duas criadas por SQL: talhao_formula_coefficients e activity_logs, totalizando 15 tabelas da aplicação. A classe TalhaoFormulaCoefficients está declarada no arquivo, mas sua tabela é criada/acessada por SQL e não integra a lista de tabelas geradas pelo Drift.

Propriedade e talhão são cadastros permanentes. InventoryRun representa o levantamento; TalhaoLevantamentos associa um talhão a um levantamento, com espécie e fórmula selecionadas. Parcelas pertencem a essa associação, e árvores pertencem às parcelas.

Os coeficientes existem em três níveis: definição global da fórmula, configuração por espécie/fórmula e cópia por talhão do levantamento. O vínculo conserva os valores da coleta, mas não há cópia histórica integral da expressão matemática: a fórmula continua referenciada por ID. Portanto, não afirmar imutabilidade de todos os resultados após edição do catálogo.

Os resultados são calculados em memória; não existe tabela inventory_results. activity_logs armazena eventos, com entity_type/entity_id opcionais e sem chave estrangeira para as entidades.

O modelo completo, as chaves e os relacionamentos estão em ENGINEERING_MODELS.md.

## Cálculos e limites

ForestVolumeCalculator contém rotinas estáticas de Spurr, Schumacher-Hall e Fator de Forma. Há cadastro de expressões e variáveis, mas não há interpretador genérico de fórmulas. A seleção interna é por ID e padrões da expressão, conforme BUSINESS_RULES.md.

ResultsRepository consulta o banco, recupera coeficientes e agrega os volumes. DataExportRepository usa a mesma calculadora por árvore, porém possui agregações e indicadores próprios; não existe um serviço único que centraliza todos os resultados.

Não existem InventoryCalculationService, FormulaService, ExpressionParser ou PlotGeoPointRepository separados. Esses nomes dos diagramas anteriores eram propostas conceituais.

## Arquivos e recursos do dispositivo

São gerados PDF, CSV com dados/resultados, XLSX com resultados, CSV bruto, XLSX bruto e KML. O identificador interno xls gera .xlsx; não gera o formato binário .xls. KMZ não está implementado.

O salvamento/compartilhamento usa recursos locais. Disponibilizar um APK por servidor na rede para testes é uma operação externa de desenvolvimento, não uma funcionalidade do aplicativo.

## Verificação e alcance

Existem testes em test/ para banco, migração do Fator de Forma, cálculos, exportações brutas, tema e fluxos de interface. A última execução registrada nesta conversa apresentou 36 testes aprovados e análise estática sem problemas; a revisão documental não executou novamente a suíte.

Build Android e uso de emulador não comprovam validação científica, usabilidade em campo nem compatibilidade formal com todos os tablets. A estimativa econômica e a avaliação genérica de expressões ficaram fora da implementação entregue.
