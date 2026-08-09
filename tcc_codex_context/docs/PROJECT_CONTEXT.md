# PROJECT_CONTEXT.md

## Visão geral
Este projeto é o desenvolvimento prático de um Trabalho de Conclusão de Curso em Ciência da Computação.

### Nome do aplicativo
**DENDRO Mobile**

### Nome completo
**DENDRO Mobile - Sistema para Inventário Florestal**

### Tema
**Sistema Mobile para Coleta e Análise de Dados de Inventário Florestal em Florestas Plantadas de Pinus e Eucalyptus no Rio Grande do Sul.**

## Problema
Em inventários florestais, a coleta e o processamento dos dados ainda podem ocorrer por anotações em campo e posterior organização em planilhas. Isso pode gerar retrabalho, inconsistências, erros de transcrição e demora para obtenção dos resultados.

Há softwares existentes, porém o projeto identifica lacunas relacionadas a simplicidade, acessibilidade, integração das etapas do inventário e adequação à realidade de pequenos e médios produtores e profissionais que atuam com florestas plantadas no Rio Grande do Sul.

## Objetivo geral
Desenvolver um sistema mobile para coleta, armazenamento e análise de dados de inventário florestal em florestas plantadas de Pinus e Eucalyptus, permitindo estimativa de volume e rendimento econômico, com foco na realidade do Rio Grande do Sul.

## Objetivos específicos do TCC
- Levantar e analisar modelos matemáticos utilizados para estimativa de volume em florestas plantadas e suas variáveis dendrométricas.
- Definir o método de amostragem utilizado no inventário.
- Projetar a estrutura do sistema para cadastro de propriedades, talhões, parcelas e árvores.
- Desenvolver aplicação mobile para coleta e armazenamento de dados em campo.
- Realizar cálculos para estimativa de volume e produtividade.
- Permitir a inserção do valor do metro cúbico da madeira para estimativa econômica.
- Avaliar a organização, o processamento e a apresentação dos dados coletados.

## Público-alvo
O foco é uma solução simples e prática para o contexto de florestas plantadas, especialmente:
- pequenos e médios produtores florestais;
- engenheiros florestais e profissionais que realizam inventários em campo.

## Delimitação inicial
- Região: Rio Grande do Sul.
- Florestas plantadas.
- Gêneros: Pinus e Eucalyptus.
- Aplicativo mobile autônomo.
- Operação sem dependência de internet.

A delimitação regional é importante porque os coeficientes utilizados em equações volumétricas podem variar conforme espécie, região, idade, manejo e condições de crescimento.

## Conceitos do domínio
### Propriedade
Área/empreendimento florestal que será avaliado.

### Talhão
Unidade de manejo dentro de uma propriedade. Um mesmo projeto pode possuir vários talhões.

### Levantamento / Contagem
Evento de coleta realizado em uma propriedade, podendo envolver um ou mais talhões e suas parcelas medidas. Uma mesma propriedade pode possuir vários levantamentos ao longo do tempo, e mais de um levantamento pode permanecer em andamento ao mesmo tempo.

### Parcela
Unidade amostral pertencente a um talhão, utilizada para realizar as medições do inventário.

### Árvore
Indivíduo medido dentro de uma parcela.

### DAP
Diâmetro à altura do peito, variável dendrométrica utilizada nos cálculos de inventário.

### Altura
Altura da árvore utilizada, juntamente com outras variáveis e coeficientes, nos modelos volumétricos.

## Organização conceitual do aplicativo
`Propriedade -> Levantamento/Contagem -> Talhão -> Parcela -> Árvore -> Medições -> Cálculos -> Resultados`

A propriedade é um cadastro mais permanente. O levantamento representa uma coleta específica, com data, status e dados medidos naquele evento. O talhão pode existir como cadastro da propriedade e também deve ser selecionado ou criado durante o levantamento.

Exemplo de coleta:
1. selecionar/cadastrar propriedade;
2. criar um novo levantamento ou continuar um levantamento em andamento;
3. selecionar/cadastrar talhão;
4. selecionar/cadastrar parcela;
5. opcionalmente capturar pontos de geolocalização da parcela;
6. registrar árvores da parcela;
7. informar DAP e altura das árvores;
8. aplicar a fórmula/modelo volumétrico configurado;
9. consolidar os resultados;
10. apresentar volume/produtividade e estimativa econômica.

## Navegação principal prevista
A interface mobile deve ser organizada por uma barra inferior com cinco áreas principais:
- **Início**: painel de retomada rápida, criação de novo levantamento, sugestão de continuidade de levantamentos em aberto e resumo do último levantamento concluído.
- **Levantamentos**: lista e acesso aos levantamentos por data, propriedade, talhão e status.
- **Propriedades**: cadastro e consulta da estrutura permanente das propriedades e seus talhões.
- **Resultados**: área analítica/dashboard, inicialmente orientada à seleção de uma propriedade para visualizar resultados consolidados.
- **Ajustes**: cadastros auxiliares e configurações, como espécies e fórmulas/modelos matemáticos.

## Modelos matemáticos
O referencial do TCC considera modelos clássicos de estimativa volumétrica, em especial:
- Spurr;
- Schumacher-Hall.

Os coeficientes não são universais. Eles são obtidos em estudos por ajuste estatístico a partir de dados de campo e cubagem rigorosa. O aplicativo não tem como objetivo gerar esses coeficientes.

A intenção discutida para o software é permitir que modelos, fórmulas e coeficientes possam ser configurados, possibilitando futura utilização em outras regiões quando o usuário possuir parâmetros tecnicamente adequados.

Além de fórmulas/modelos pré-cadastrados, o sistema deve ser estruturado para permitir fórmulas personalizadas cadastradas pelo usuário. Essas fórmulas devem possuir nome único, expressão matemática validada, variáveis permitidas e coeficientes necessários. A aplicação deve avaliar expressões matemáticas de forma controlada, sem executar código arbitrário.

## Tecnologia definida
- Linguagem: Dart.
- Framework: Flutter.
- Persistência local: SQLite.
- IDE principal: Visual Studio Code.
- Android Studio: configuração do ambiente Android e emuladores.
- Versionamento: Git.
- Repositório: GitHub.

## Característica essencial
O sistema precisa funcionar em campo, inclusive sem conexão com a internet. Coleta, armazenamento, processamento e resultados devem ocorrer localmente no dispositivo na primeira versão.

## Geolocalização e documentação geográfica
Durante um levantamento, o usuário poderá registrar pontos de geolocalização da parcela utilizando o GPS/localização do celular ou tablet. A ideia inicial é permitir marcar os cantos da parcela amostral, formando um polígono para documentação.

Esses pontos devem ser tratados como georreferenciamento de apoio ao inventário, não como medição topográfica precisa sem validação técnica. O contorno completo do talhão não é obrigatório no fluxo de campo, pois a amostragem por parcelas não exige que o usuário percorra todo o perímetro do talhão.

Como evolução desejada, o aplicativo poderá exportar as parcelas georreferenciadas em KML/KMZ para abertura no Google Earth, aproximando o sistema do fluxo de trabalho utilizado por profissionais que já documentam inventários com imagens aéreas e marcações geográficas.

## Validação prevista
O TCC prevê validação com apoio de profissional da Engenharia Florestal e docentes da área, comparando os resultados produzidos pelo aplicativo com levantamentos/cálculos realizados por métodos de referência.

Serão observados aspectos como:
- usabilidade;
- tempo de análise;
- confiabilidade;
- precisão dos resultados.

## Evoluções possíveis, mas fora do núcleo da primeira versão
- sincronização com servidor quando houver internet;
- aplicação web para consulta dos dados sincronizados;
- backup em nuvem;
- ampliação para outras regiões e espécies;
- biblioteca maior de modelos e coeficientes;
- exportações mais avançadas.
- importação/exportação geográfica mais completa, incluindo KML/KMZ e eventual desenho/importação de contornos de talhão.
