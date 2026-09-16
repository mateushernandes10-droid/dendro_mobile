# Modelagem do banco de dados

Revisão em 16/09/2026. Este documento descreve o banco SQLite realmente implementado no DENDRO Mobile. A fonte principal é `lib/nucleo/banco/banco_dendro.dart`.

## 1. Abordagem adotada

A modelagem foi organizada em três níveis:

1. **Modelo conceitual:** apresenta os conceitos do domínio florestal e seus relacionamentos, sem depender dos nomes físicos do SQLite.
2. **Modelo lógico:** apresenta entidades, cardinalidades, chaves e tabelas associativas.
3. **Modelo físico:** apresenta as 15 tabelas, os 114 campos, tipos SQLite, chaves e nulabilidade.

Os resultados do inventário não são persistidos em uma tabela própria. Médias, volumes, distribuição diamétrica, árvores por hectare e quantidade/percentual de árvores com tronco tortuoso são calculados a partir das medições armazenadas.

## 2. Modelo conceitual

O núcleo da coleta segue esta hierarquia:

```text
Propriedade → Levantamento → Talhão no levantamento → Parcela → Árvore
```

Uma propriedade também mantém o cadastro permanente dos seus talhões. A entidade associativa **Talhão no levantamento** registra a participação de um talhão em determinada coleta, preservando a espécie, o modelo matemático e os coeficientes usados naquele contexto.

O diagrama editável está em `diagrams/09_modelo_conceitual_banco.mmd`.

Principais conceitos:

| Conceito | Responsabilidade |
|---|---|
| Propriedade | Identifica o imóvel rural e sua área cadastrada. |
| Talhão | Representa uma unidade de manejo da propriedade. |
| Espécie | Classifica os talhões e define modelos matemáticos aplicáveis. |
| Levantamento | Agrupa uma execução do inventário na propriedade. |
| Talhão no levantamento | Resolve a participação do talhão na coleta e preserva sua configuração. |
| Parcela | Unidade amostral dentro do talhão levantado. |
| Árvore | Armazena DAP, altura, condição do tronco e localização opcional. |
| Ponto geográfico | Documenta coordenadas de referência da parcela. |
| Modelo matemático | Define expressão, variáveis e coeficientes usados no cálculo. |
| Registro de atividade | Registra eventos do aplicativo sem formar uma relação física com uma entidade específica. |

## 3. Modelo lógico

O modelo lógico está em `diagrams/03_banco_relacionamentos.mmd`. As cardinalidades seguem a notação pé de galinha:

- o registro filho pertence obrigatoriamente a um registro pai quando existe chave estrangeira não nula;
- o registro pai pode possuir zero ou muitos filhos;
- `especies_modelos` resolve a relação muitos para muitos entre espécie e modelo;
- `talhao_levantamentos` resolve a participação de talhões em levantamentos;
- `registros_atividade` permanece independente porque `tipo_entidade` e `entidade_id` são referências lógicas, não uma chave estrangeira.

Relações centrais:

| Origem | Cardinalidade | Destino | Chave estrangeira |
|---|---:|---|---|
| propriedades | 1:N | talhoes | `talhoes.propriedade_id` |
| propriedades | 1:N | levantamentos | `levantamentos.propriedade_id` |
| especies | 1:N | talhoes | `talhoes.especie_id` |
| levantamentos | 1:N | talhao_levantamentos | `talhao_levantamentos.levantamento_id` |
| talhoes | 1:N | talhao_levantamentos | `talhao_levantamentos.talhao_id` |
| especies | 1:N | talhao_levantamentos | `talhao_levantamentos.especie_id` |
| modelos_matematicos | 1:N | talhao_levantamentos | `talhao_levantamentos.modelo_matematico_id` |
| talhao_levantamentos | 1:N | parcelas | `parcelas.talhao_levantamento_id` |
| parcelas | 1:N | arvores | `arvores.parcela_id` |
| parcelas | 1:N | pontos_geograficos_parcela | `pontos_geograficos_parcela.parcela_id` |

As demais relações configuram variáveis e coeficientes de modelos matemáticos e estão detalhadas no modelo físico.

## 4. Modelo físico

O modelo físico completo está em `diagrams/04_banco_completo.mmd`. O banco usa SQLite por meio do Drift e está na versão de schema 1.

As tabelas podem ser apresentadas em dois grupos:

### Dados do inventário

| Tabela | Finalidade |
|---|---|
| `propriedades` | Cadastro das propriedades. |
| `talhoes` | Cadastro permanente dos talhões. |
| `levantamentos` | Execuções do inventário. |
| `talhao_levantamentos` | Talhões incluídos em cada levantamento. |
| `parcelas` | Unidades amostrais. |
| `arvores` | Medições individuais das árvores. |
| `pontos_geograficos_parcela` | Pontos GPS das parcelas. |
| `registros_atividade` | Eventos recentes do aplicativo. |

### Configuração dos cálculos

| Tabela | Finalidade |
|---|---|
| `especies` | Catálogo de espécies. |
| `modelos_matematicos` | Catálogo de modelos. |
| `variaveis_modelo` | Variáveis declaradas por modelo. |
| `coeficientes_modelo` | Coeficientes globais. |
| `especies_modelos` | Modelos permitidos e modelo padrão por espécie. |
| `coeficientes_especie_modelo` | Valores particulares por espécie e modelo. |
| `coeficientes_talhao_levantamento` | Valores preservados para a coleta do talhão. |

## 5. Restrições principais

- IDs simples usam `INTEGER PRIMARY KEY AUTOINCREMENT`.
- `especies_modelos` possui chave primária composta por espécie e modelo.
- Identificação de talhão é única dentro da propriedade.
- Talhão não se repete dentro do mesmo levantamento.
- Identificação de parcela é única dentro do talhão levantado.
- Número da árvore é único dentro da parcela.
- Ordem do ponto geográfico é única dentro da parcela.
- Símbolos de variáveis e coeficientes são únicos dentro de seus respectivos contextos.
- Exclusões de estruturas dependentes usam principalmente `ON DELETE CASCADE`; espécie e modelo associados a coletas usam `RESTRICT`.

## 6. Dados calculados

Os itens abaixo são produzidos pelos repositórios e não constituem colunas do banco:

- volume individual da árvore;
- volume amostrado;
- volume por hectare;
- volume estimado do talhão;
- DAP e altura médios;
- árvores por hectare;
- distribuição por classe diamétrica;
- quantidade e percentual de árvores com tronco tortuoso;
- conversões para tonelada ou metro estéreo.

Para apresentar a estrutura no artigo, use o modelo conceitual no corpo do texto, o modelo lógico na seção de projeto do banco e o modelo físico completo em apêndice quando a quantidade de atributos prejudicar a leitura.
