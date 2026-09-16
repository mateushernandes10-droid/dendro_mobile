# Fontes dos diagramas

Revisadas contra a versão final do banco em 16/09/2026. Arquivos .mmd são texto Mermaid editável. Os modelos lógico e físico também estão incorporados em ../ENGINEERING_MODELS.md. A organização acadêmica dos três níveis está documentada em ../MODELO_BANCO_DADOS.md.

| Arquivo | Uso |
|---|---|
| 01_casos_de_uso.mmd | Visão funcional; associa usuário às funções, sem notação UML formal |
| 02_arquitetura.mmd | Componentes realmente implementados |
| 03_banco_relacionamentos.mmd | Visão resumida das cardinalidades para o artigo |
| 04_banco_completo.mmd | 15 tabelas, atributos, chaves e campos opcionais |
| 05_fluxo_coleta.mmd | Percurso de coleta; não é fluxograma da metodologia acadêmica |
| 06_sequencia_resultados.mmd | Consulta/cálculo usando componentes reais |
| 07_estados_levantamento.mmd | Planejamento, andamento e finalização |
| 08_classes_dados.mmd | Registros Drift e classes de cálculo/resultados |
| 09_modelo_conceitual_banco.mmd | Conceitos do domínio e relacionamentos, sem nomes físicos do SQLite |

Verificação documental: 15 tabelas e 114 colunas comparadas automaticamente com as declarações do banco, incluindo tipos e nulabilidade. Os diagramas lógico e físico representam a estrutura persistida; resultados calculados não são tabelas. Não foram renderizadas imagens nesta revisão; não afirmar revisão visual de PNG/SVG.
