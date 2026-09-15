# Arquitetura implementada — DENDRO Mobile

Revisão em 14/09/2026, baseada no código atual. Este documento descreve a versão final do aplicativo.

## Organização efetiva

O aplicativo Android usa Flutter/Dart, Riverpod e SQLite com Drift. Coleta, persistência e cálculos ocorrem no dispositivo, sem backend, conta de usuário ou sincronização em nuvem.

A organização é por funcionalidades. As telas consomem providers Riverpod e repositórios; os repositórios acessam o banco e também executam parte da orquestração e das agregações. Não existe uma camada Application/Domain completa e separada em todas as funcionalidades. Os registros gerados pelo Drift são usados diretamente em diferentes partes do aplicativo.

| Responsabilidade | Implementação |
|---|---|
| Inicialização, tema e navegação | `lib/main.dart`, `lib/aplicativo/`, `lib/funcionalidades/estrutura/` |
| Telas e estado | `lib/funcionalidades/*/apresentacao/`, providers Riverpod |
| Instância do banco | `lib/nucleo/provedores/provedores_banco.dart` |
| Tabelas e catálogo inicial | `lib/nucleo/banco/banco_dendro.dart`, `lib/nucleo/banco/catalogos_iniciais.dart` |
| Código gerado do Drift | `lib/nucleo/banco/banco_dendro.g.dart` |
| Persistência e orquestração | `lib/funcionalidades/*/dados/` |
| Equações por árvore e conversões | `lib/nucleo/floresta/calculadora_volume_florestal.dart` |
| Agregações do painel | `lib/funcionalidades/resultados/dados/repositorio_resultados.dart` |
| Geração de arquivos e agregações dos relatórios | `lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart` |
| GPS | Chamadas ao Geolocator na tela de coleta; armazenamento em RepositorioArvores |
| Salvamento de arquivo | `lib/nucleo/plataforma/salvador_arquivo.dart`; seletor de documentos no Android e folha de compartilhamento no iOS |
| Preferência de tema | `lib/nucleo/preferencias/controlador_tema.dart` |
| Histórico de atividades | `lib/funcionalidades/atividades/` |

As funcionalidades existentes são: atividades, exportacao_dados, inicio, levantamentos, parcelas, propriedades, resultados, ajustes, estrutura, abertura, talhoes e coleta_arvores. Os catálogos de espécies e modelos ficam em ajustes, não em módulos independentes.

## Dependências efetivamente declaradas

Além do Flutter e dos ícones, o pubspec declara drift, drift_flutter, flutter_riverpod, path_provider, geolocator, share_plus, pdf e excel. Os testes e a geração de código usam flutter_test, flutter_lints, drift_dev e build_runner.

Não estão instaladas math_expressions, fl_chart, printing ou csv. CSV e KML são montados pelo código do exportador. Não representar essas bibliotecas ausentes como componentes implementados.

## Banco de dados

O esquema é versão 1. As 15 tabelas da aplicação são declaradas em banco_dendro.dart e registradas em @DriftDatabase. O Drift cria a estrutura física do SQLite e gera as classes de dados correspondentes.

Propriedade e talhão são cadastros permanentes. Levantamento representa o levantamento; TalhaoLevantamentos associa um talhão a um levantamento, com espécie e fórmula selecionadas. Parcelas pertencem a essa associação, e árvores pertencem às parcelas.

Os coeficientes existem em três níveis: definição global da fórmula, configuração por espécie/fórmula e cópia por talhão do levantamento. O vínculo conserva os valores da coleta, mas não há cópia histórica integral da expressão matemática: a fórmula continua referenciada por ID. Portanto, não afirmar imutabilidade de todos os resultados após edição do catálogo.

Os resultados são calculados em memória; não existe tabela de resultados. registros_atividade armazena eventos, com tipo_entidade/entidade_id opcionais e sem chave estrangeira para as entidades.

O modelo completo, as chaves e os relacionamentos estão em ENGINEERING_MODELS.md.

## Cálculos e limites

CalculadoraVolumeFlorestal contém rotinas estáticas de Spurr, Schumacher-Hall e Fator de Forma. Há cadastro de expressões e variáveis, mas não há interpretador genérico de fórmulas. A seleção interna é por codigo e padrões da expressão, conforme BUSINESS_RULES.md.

RepositorioResultados consulta o banco, recupera coeficientes e agrega os volumes. RepositorioExportacaoDados usa a mesma calculadora por árvore, porém possui agregações e indicadores próprios; não existe um serviço único que centraliza todos os resultados.

Não existem InventoryCalculationService, FormulaService, ExpressionParser ou PlotGeoPointRepository separados. Esses nomes dos diagramas anteriores eram propostas conceituais.

## Arquivos e recursos do dispositivo

São gerados PDF, CSV com dados/resultados, XLSX com resultados, CSV bruto, XLSX bruto e KML. O identificador interno xls gera .xlsx; não gera o formato binário .xls. KMZ não está implementado.

O salvamento/compartilhamento usa recursos locais. Disponibilizar um APK por servidor na rede para testes é uma operação externa de desenvolvimento, não uma funcionalidade do aplicativo.

## Verificação e alcance

Existem testes em test/ para criação e integridade do banco, cálculos, exportações brutas, tema e fluxos de interface.

Build Android e uso de emulador não comprovam validação científica, usabilidade em campo nem compatibilidade formal com todos os tablets. A estimativa econômica e a avaliação genérica de expressões ficaram fora da implementação entregue.

## Identificadores

As 14 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a chave primária composta (especie_id, modelo_matematico_id), ambas inteiras. Espécies e modelos têm codigo textual único e opcional para identificar itens conhecidos do catálogo. registros_atividade usa entidade_id inteiro opcional, sem chave estrangeira, porque registra tipos diferentes de entidade. São 15 tabelas e 114 colunas.
