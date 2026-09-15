# Estado da implementação e evidências

Revisão em 14/09/2026. Este documento registra o estado final observado no código.

## Implementação disponível

- Propriedades e talhões, com cadastro de propriedade também em Novo levantamento.
- Planejamento de parcelas, início e retomada de coletas, conclusão e exclusões.
- Registro sequencial de árvores com DAP em cm, altura em m, tronco tortuoso e GPS opcional.
- Catálogos de espécies, modelos matemáticos e coeficientes por espécie e por talhão do levantamento.
- Cálculo por Spurr, Schumacher-Hall e Fator de Forma.
- Resultados com volumes e extrapolação por área.
- Exportação PDF, CSV, XLSX, KML, CSV bruto e XLSX bruto.
- Registro local de atividades e modo escuro persistido.

## Pontos principais

Fator de Forma usa `pi * (D / 100)^2 * H * ff`. O DAP permanece em centímetros no cadastro e é convertido para metros nesse cálculo. O valor de `ff` é informado pelo usuário.

A exportação bruta CSV mantém uma linha por árvore e inclui campos auxiliares. A planilha bruta organiza as parcelas lado a lado em A6, E6, I6 e assim por diante, com árvore, DAP e altura a partir da linha 7.

A tela Novo levantamento reutiliza o formulário de propriedade. Ao salvar, a nova propriedade passa a estar disponível para seleção.

## Banco de dados

O SQLite possui 15 tabelas e 114 colunas. As tabelas, colunas, enums e classes do domínio usam português. Quatorze tabelas usam `INTEGER PRIMARY KEY AUTOINCREMENT`; `especies_modelos` usa a chave composta `(especie_id, modelo_matematico_id)`.

O catálogo inicial é inserido por `catalogos_iniciais.dart` na primeira criação do banco. Ele inclui Pinus, Eucalyptus e os três modelos matemáticos disponíveis.

## Limitações que devem constar no artigo

- Estimativa econômica não implementada.
- Cadastro de expressões sem interpretador genérico.
- Coeficientes e conversões padrão sem validade universal comprovada.
- Ausência de regressão para estimar coeficientes.
- GPS usado como apoio documental, sem precisão topográfica assegurada.
- KMZ, sincronização, backend e autenticação fora da versão final.
- Validação formal de campo e de usabilidade ainda depende do trabalho acadêmico.

## Evidências de código

| Tema | Fonte |
|---|---|
| Tabelas e abertura do banco | `lib/nucleo/banco/banco_dendro.dart` |
| Catálogo inicial | `lib/nucleo/banco/catalogos_iniciais.dart` |
| Fórmulas e conversões | `lib/nucleo/floresta/calculadora_volume_florestal.dart` |
| Painel e filtros | `lib/funcionalidades/resultados/dados/repositorio_resultados.dart` |
| Exportações | `lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart` |
| Coleta e GPS | `lib/funcionalidades/coleta_arvores/` |
| Planejamento e parcelas | `lib/funcionalidades/parcelas/` |
| Tema | `lib/nucleo/preferencias/controlador_tema.dart` |

## Verificação

Os testes automatizados cobrem banco, cálculos, exportações brutas, tema e fluxos de interface. `diagrama_banco_test.dart` compara as 15 tabelas e suas 114 colunas com o diagrama completo em Mermaid.

Na verificação de 14/09/2026, `flutter analyze` terminou sem apontamentos, os 36 testes passaram e o APK de depuração foi gerado em `build/app/outputs/flutter-apk/app-debug.apk`.

Build Android e testes automatizados verificam o software, mas não substituem validação científica, testes de campo ou avaliação formal com usuários.

## Documentos para os diagramas

ENGINEERING_MODELS.md reúne os diagramas atualizados. O diretório `diagrams/` guarda as oito fontes Mermaid editáveis. ARCHITECTURE.md descreve os componentes reais, REQUIREMENTS.md classifica os requisitos e BUSINESS_RULES.md registra comportamentos e limites do cálculo.
