# PROJECT_CONTEXT.md

## Visão geral
Este projeto é o desenvolvimento prático de um Trabalho de Conclusão de Curso em Ciência da Computação.

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

### Parcela
Unidade amostral pertencente a um talhão, utilizada para realizar as medições do inventário.

### Árvore
Indivíduo medido dentro de uma parcela.

### DAP
Diâmetro à altura do peito, variável dendrométrica utilizada nos cálculos de inventário.

### Altura
Altura da árvore utilizada, juntamente com outras variáveis e coeficientes, nos modelos volumétricos.

## Organização conceitual do aplicativo
`Propriedade -> Talhão -> Parcela -> Árvore -> Medições -> Cálculos -> Resultados`

Exemplo de coleta:
1. selecionar/cadastrar propriedade;
2. selecionar/cadastrar talhão;
3. selecionar/cadastrar parcela;
4. registrar árvores da parcela;
5. informar DAP e altura das árvores;
6. aplicar o modelo volumétrico configurado;
7. consolidar os resultados;
8. apresentar volume/produtividade e estimativa econômica.

## Modelos matemáticos
O referencial do TCC considera modelos clássicos de estimativa volumétrica, em especial:
- Spurr;
- Schumacher-Hall.

Os coeficientes não são universais. Eles são obtidos em estudos por ajuste estatístico a partir de dados de campo e cubagem rigorosa. O aplicativo não tem como objetivo gerar esses coeficientes.

A intenção discutida para o software é permitir que modelos/coeficientes possam ser configurados, possibilitando futura utilização em outras regiões quando o usuário possuir parâmetros tecnicamente adequados.

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
