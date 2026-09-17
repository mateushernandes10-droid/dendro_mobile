# Decisões de projeto — DENDRO Mobile

Este documento reúne as decisões que definem a versão final do aplicativo. Os detalhes observáveis da implementação estão em ARCHITECTURE.md, BUSINESS_RULES.md e ENGINEERING_MODELS.md.

## Aplicativo móvel e operação local

O sistema foi desenvolvido em Flutter e Dart, com Android como plataforma principal. O funcionamento essencial é offline: cadastros, coletas, cálculos e consultas usam o próprio dispositivo. Não há servidor, autenticação ou sincronização em nuvem.

Riverpod gerencia o estado da interface. Drift faz o mapeamento e o acesso ao SQLite. As classes das bibliotecas conservam seus nomes originais, enquanto nomes de domínio, tabelas, colunas, métodos e variáveis do projeto usam português.

## Organização por funcionalidades

O código é separado por funcionalidades, como propriedades, levantamentos, parcelas, coleta de árvores, resultados e exportação. Cada funcionalidade reúne apresentação e acesso aos seus dados. Repositórios concentram consultas e operações de persistência, e os providers disponibilizam esses serviços para as telas.

Essa organização mantém o projeto compreensível sem introduzir camadas que não são necessárias ao tamanho atual do aplicativo.

## Estrutura do inventário

A hierarquia adotada é Propriedade → Levantamento → Talhão no levantamento → Parcela → Árvore. O cadastro permanente do talhão pertence à propriedade. A tabela talhao_levantamentos representa sua participação em uma coleta específica, permitindo repetir levantamentos sem misturar parcelas e árvores.

As medições principais são DAP em centímetros e altura em metros. A área da propriedade, do talhão e da parcela é armazenada em hectares quando aplicável.

## Banco de dados

O banco possui 14 tabelas com nomes em português. Treze delas têm chave primária inteira autoincrementada; especies_modelos usa chave primária composta porque representa diretamente a associação entre espécie e modelo.

As chaves estrangeiras são inteiras e preservam a hierarquia do inventário. Exclusões em cascata são usadas quando o registro filho perde o sentido sem o pai. Referências a espécie e modelo em coletas usam restrição para evitar a remoção de uma configuração em uso.

Espécies e modelos matemáticos têm um codigo textual opcional. Esse campo identifica os itens fornecidos no catálogo inicial e permite selecionar os cálculos implementados sem atribuir significado à chave primária.

## Espécies, modelos e coeficientes

O catálogo inicial contém Pinus, Eucalyptus, Modelo de Spurr, Schumacher-Hall e Fator de Forma. Espécies podem ser associadas a vários modelos, com um deles marcado como padrão.

Os coeficientes aparecem em três níveis: definição do modelo, valor associado à espécie e valor usado no talhão do levantamento. O aplicativo permite informar e revisar esses valores, mas não executa regressão estatística para estimá-los.

## Cálculos volumétricos

Os cálculos implementados são Spurr, Schumacher-Hall e Fator de Forma. No Fator de Forma, o DAP informado em centímetros é convertido para metros:

`V = pi * (DAPcm / 100)^2 * H * ff`

O valor de pi é fornecido pela biblioteca matemática do Dart. O fator de forma `ff` é informado pelo usuário. A expressão não divide o resultado por quatro, conforme a fórmula definida para este trabalho.

O cadastro permite armazenar outros modelos e expressões, mas não existe interpretador genérico. Somente os modelos reconhecidos pela calculadora possuem execução própria.

## Parcelas e coleta de árvores

Parcelas podem ser preparadas antes da coleta e passam pelos estados pendente, em andamento e coletada. As árvores recebem numeração sequencial dentro de cada parcela. O registro inclui DAP, altura, indicação de tronco tortuoso e localização opcional.

O GPS serve como apoio documental. Cada posição pode ser associada a uma referência P1–P4 da parcela; o aplicativo não substitui um levantamento topográfico.

## Resultados

Os resultados são calculados a partir das árvores registradas e não possuem tabela própria. O aplicativo apresenta contagens, médias, distribuição diamétrica, volume amostrado, volume por hectare e extrapolação para a área do talhão quando os dados necessários estão disponíveis.

## Exportações

O aplicativo gera PDF, CSV, XLSX e KML. Também oferece CSV e XLSX brutos com as medições originais. No XLSX bruto, as parcelas aparecem lado a lado e cada grupo apresenta árvore, DAP e altura nas linhas inferiores.

KMZ e estimativa econômica não integram a versão final.

## Interface e identidade

A navegação principal usa as abas Início, Levantamentos, Propriedades, Resultados e Ajustes. A interface permanece em português e oferece modo escuro persistido localmente. A identidade visual usa o nome DENDRO Mobile e os recursos registrados em assets/branding e assets/backgrounds.
