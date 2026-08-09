# ENGINEERING_MODELS.md

Modelos iniciais de engenharia do sistema, derivados do contexto, requisitos, regras de negócio e decisões atuais do projeto.

Estes modelos servem como base para o TCC e podem ser refinados conforme o desenvolvimento avance e as regras técnicas de inventário florestal sejam validadas.

## 1. Visão Geral dos Atores

### Usuário de campo
Pessoa que utiliza o aplicativo durante o levantamento para cadastrar propriedade/talhão, registrar parcelas, árvores, medições e pontos de geolocalização.

### Responsável técnico / engenheiro florestal
Pessoa responsável por validar fórmulas, coeficientes, método de amostragem, resultados e documentação final do inventário.

Na primeira versão do sistema não haverá autenticação nem perfis separados. A distinção dos atores é conceitual para documentação dos casos de uso.

## 2. Diagrama de Casos de Uso

```mermaid
flowchart LR
    usuario["Usuário de campo"]
    engenheiro["Responsável técnico / engenheiro florestal"]

    UC01(("Gerenciar propriedades"))
    UC02(("Gerenciar talhões"))
    UC03(("Criar levantamento"))
    UC04(("Continuar levantamento"))
    UC05(("Concluir levantamento"))
    UC06(("Registrar parcelas"))
    UC07(("Capturar geolocalização da parcela"))
    UC08(("Registrar árvores e medições"))
    UC09(("Gerenciar espécies"))
    UC10(("Gerenciar fórmulas/modelos"))
    UC11(("Configurar coeficientes"))
    UC12(("Calcular volume"))
    UC13(("Consultar resultados"))
    UC14(("Exportar dados/resultados"))
    UC15(("Exportar KML/KMZ"))

    usuario --> UC01
    usuario --> UC02
    usuario --> UC03
    usuario --> UC04
    usuario --> UC05
    usuario --> UC06
    usuario --> UC07
    usuario --> UC08
    usuario --> UC13
    usuario --> UC14
    usuario --> UC15

    engenheiro --> UC09
    engenheiro --> UC10
    engenheiro --> UC11
    engenheiro --> UC12
    engenheiro --> UC13
    engenheiro --> UC14
    engenheiro --> UC15

    UC03 --> UC01
    UC03 --> UC02
    UC06 --> UC07
    UC08 --> UC12
    UC10 --> UC11
    UC12 --> UC13
```

## 3. Casos de Uso Textuais

### UC-001 — Gerenciar propriedades
**Ator principal:** Usuário de campo.

**Objetivo:** Cadastrar, visualizar, editar, excluir e pesquisar propriedades.

**Fluxo principal:**
1. O usuário acessa a aba Propriedades.
2. O sistema exibe propriedades cadastradas com nome, município/UF, área em hectares e quantidade de talhões.
3. O usuário pode buscar por nome ou aplicar filtros.
4. O usuário pode cadastrar nova propriedade ou abrir uma existente.
5. O usuário pode editar ou excluir uma propriedade pelo menu de ações.

**Regras relacionadas:** RF-001, BR-001, BR-012, D-022, D-023.

### UC-002 — Gerenciar talhões
**Ator principal:** Usuário de campo.

**Objetivo:** Cadastrar e manter talhões vinculados a uma propriedade.

**Fluxo principal:**
1. O usuário abre uma propriedade.
2. O sistema lista os talhões vinculados.
3. O usuário cadastra, edita, exclui ou abre um talhão.

**Regras relacionadas:** RF-002, BR-001, D-005.

### UC-003 — Criar levantamento
**Ator principal:** Usuário de campo.

**Objetivo:** Iniciar uma nova contagem/inventário de campo.

**Fluxo principal:**
1. O usuário escolhe criar novo levantamento.
2. O sistema solicita a propriedade.
3. O usuário seleciona propriedade cadastrada ou cadastra uma nova, quando disponível.
4. O usuário seleciona ou cria um ou mais talhões envolvidos.
5. O usuário confirma espécie e fórmula/modelo para cada talhão selecionado.
6. O sistema cria o levantamento com status `em andamento`.
7. O sistema cria um vínculo `talhaolevantamento` para cada talhão incluído na coleta.

**Regras relacionadas:** RF-017, RF-018, BR-019, BR-020, D-015, D-021.

### UC-004 — Continuar levantamento
**Ator principal:** Usuário de campo.

**Objetivo:** Retomar uma contagem aberta anteriormente.

**Fluxo principal:**
1. O usuário acessa a tela inicial ou a aba Levantamentos.
2. O sistema exibe levantamentos em andamento.
3. A tela inicial sugere o levantamento atualizado mais recentemente.
4. O usuário abre o levantamento e continua o registro de parcelas, árvores e medições.

**Regras relacionadas:** RF-017, RF-018, BR-019, D-020, D-021.

### UC-005 — Registrar parcela
**Ator principal:** Usuário de campo.

**Objetivo:** Cadastrar uma parcela amostral dentro de um talhão selecionado no levantamento.

**Fluxo principal:**
1. O usuário abre um levantamento em andamento.
2. O usuário seleciona o talhão dentro do levantamento.
3. O usuário cria uma nova parcela.
4. O sistema sugere a identificação da parcela, por exemplo `P01`.
5. O usuário pode capturar pontos de geolocalização.
6. O sistema salva a parcela vinculada ao `talhaolevantamento`.

**Regras relacionadas:** RF-003, RF-020, BR-022.

### UC-006 — Capturar geolocalização da parcela
**Ator principal:** Usuário de campo.

**Objetivo:** Registrar coordenadas da parcela usando a localização do dispositivo.

**Fluxo principal:**
1. O usuário solicita capturar um ponto da parcela.
2. O sistema verifica permissão de localização.
3. O sistema obtém latitude, longitude e precisão.
4. O sistema salva o ponto com ordem e data/hora.
5. O usuário repete a operação para os demais pontos necessários.

**Fluxos alternativos:**
- Se a permissão for negada, o sistema informa que a geolocalização é opcional.
- Se a localização estiver indisponível, o usuário pode continuar a coleta sem pontos geográficos.

**Regras relacionadas:** RF-020, RNF-010, BR-022, D-026.

### UC-007 — Registrar árvores e medições
**Ator principal:** Usuário de campo.

**Objetivo:** Registrar árvores medidas em uma parcela.

**Fluxo principal:**
1. O usuário abre uma parcela.
2. O sistema exibe a lista de árvores já medidas.
3. O usuário toca em **Nova árvore**.
4. O sistema abre o painel deslizante de cadastro.
5. O sistema sugere a identificação sequencial da árvore, por exemplo `Árvore 20`.
6. O usuário informa DAP, altura e demais campos definidos.
7. O usuário pode capturar coordenada opcional da árvore.
8. O sistema valida os valores informados.
9. O usuário escolhe **Salvar** ou **Próxima**.
10. O sistema salva a árvore/medição e atualiza a lista.

**Fluxos alternativos:**
- Em **Salvar**, o sistema recolhe o painel e retorna à lista.
- Em **Próxima**, o sistema mantém o painel aberto e limpo para outra árvore.
- Ao editar, o sistema abre o painel preenchido com dados da árvore selecionada.
- Ao excluir, o sistema deve solicitar confirmação quando houver risco de perda de dados.
- Se a captura de coordenada for recusada ou indisponível, o sistema permite continuar a coleta sem coordenada.

**Pós-condição:**
Salvar árvores não encerra automaticamente a parcela. A parcela só muda para `coletada` quando o usuário aciona a opção de finalizar parcela.

**Regras relacionadas:** RF-004, RF-005, BR-002, BR-011, BR-012.

### UC-008 — Gerenciar espécies
**Ator principal:** Responsável técnico / engenheiro florestal.

**Objetivo:** Cadastrar e manter espécies/categorias usadas no inventário.

**Fluxo principal:**
1. O usuário acessa Ajustes.
2. O usuário abre o cadastro de espécies.
3. O sistema exibe Pinus e Eucalyptus/Eucalipto como cadastros base.
4. O usuário associa fórmulas/modelos permitidos à espécie.
5. O usuário define a fórmula/modelo padrão quando aplicável.

**Regras relacionadas:** RF-006, BR-020, D-024.

### UC-009 — Gerenciar fórmulas/modelos
**Ator principal:** Responsável técnico / engenheiro florestal.

**Objetivo:** Cadastrar e manter fórmulas volumétricas disponíveis no sistema.

**Fluxo principal:**
1. O usuário acessa Ajustes.
2. O usuário abre Fórmulas/Modelos.
3. O sistema exibe fórmulas/modelos em cards recolhíveis.
4. O usuário abre um card para visualizar/alterar coeficientes ou usa o menu de três pontos para editar/excluir.
5. O usuário informa nome, descrição, expressão matemática, variáveis/símbolos e coeficientes quando estiver criando/editando.
6. O sistema valida nome único, expressão e variáveis declaradas.
7. O sistema salva a fórmula.

**Fluxos alternativos:**
- Se o nome já existir, o sistema impede o cadastro.
- Se a expressão for inválida ou possuir símbolo/variável não declarado, o sistema impede o cadastro.
- Se houver alterações não salvas ao recolher/sair, o sistema pergunta se o usuário deseja salvar ou descartar.
- Se o usuário excluir uma fórmula associada a espécie ou levantamento, o sistema deve informar o impacto e solicitar confirmação.

**Regras relacionadas:** RF-007, RF-008, RNF-009, BR-004, BR-008, BR-021, D-025.

### UC-010 — Calcular volume
**Ator principal:** Sistema, sob comando do usuário.

**Objetivo:** Calcular volume a partir das medições, fórmula/modelo e coeficientes.

**Fluxo principal:**
1. O usuário solicita cálculo ou abre resultados.
2. O sistema identifica medições válidas.
3. O sistema obtém fórmula/modelo e coeficientes aplicáveis.
4. O sistema calcula volume por árvore.
5. O sistema consolida resultados conforme regras técnicas disponíveis.
6. O sistema apresenta resultados ao usuário.

**Restrições:**
- Extrapolação parcela/talhão depende do método de amostragem validado.
- Fórmulas sem validação técnica devem ser tratadas como responsabilidade do usuário/fonte adotada.

**Regras relacionadas:** RF-009, RF-010, RNF-005, BR-008, BR-009, BR-016.

### UC-011 — Consultar resultados
**Ator principal:** Usuário de campo ou responsável técnico.

**Objetivo:** Visualizar resultados consolidados por propriedade, com filtros opcionais.

**Fluxo principal:**
1. O usuário acessa a aba Resultados.
2. O sistema solicita ou permite selecionar uma propriedade.
3. O usuário pode selecionar filtros opcionais, como um ou mais talhões e espécie.
4. O sistema recalcula/atualiza os indicadores usando apenas os dados compatíveis com os filtros ativos.
5. O usuário pode abrir detalhes de um levantamento, talhão ou indicador.

**Fluxos alternativos:**
- A tela pode ser aberta a partir de uma propriedade, já com a propriedade selecionada.
- A tela pode ser aberta a partir de um talhão, já com propriedade e talhão selecionados.
- Se nenhum filtro opcional for aplicado, o sistema considera todos os dados da propriedade selecionada.

**Regras relacionadas:** RF-010, RF-021, BR-024, D-028.

### UC-012 — Exportar dados/resultados
**Ator principal:** Usuário de campo ou responsável técnico.

**Objetivo:** Gerar arquivo com dados coletados e/ou resultados.

**Fluxo principal:**
1. O usuário seleciona levantamento ou propriedade.
2. O usuário solicita exportação pela tela da propriedade, resultados ou detalhe do levantamento.
3. O sistema abre a tela de exportação com os talhões/áreas selecionados por padrão conforme o contexto.
4. O usuário escolhe formato de arquivo.
5. O usuário mantém ou altera a seleção de talhões/áreas incluídos.
6. O sistema gera arquivo no formato selecionado.
7. O sistema disponibiliza o arquivo ao usuário.

**Formatos desejados:**
- PDF;
- CSV;
- XLS/XLSX;
- KML/KMZ.

**Regras relacionadas:** RF-016, BR-018, D-011.

### UC-013 — Exportar KML/KMZ
**Ator principal:** Responsável técnico / engenheiro florestal.

**Objetivo:** Exportar pontos/polígonos de parcelas para uso no Google Earth.

**Fluxo principal:**
1. O usuário seleciona levantamento ou propriedade.
2. O usuário solicita exportação geográfica.
3. O sistema busca parcelas com pontos de geolocalização.
4. O sistema gera KML/KMZ preservando propriedade, levantamento, talhão e parcela.
5. O usuário importa o arquivo no Google Earth.

**Regras relacionadas:** RF-016, RF-020, BR-023, D-027.

## 4. Diagrama de Classes Conceitual

```mermaid
classDiagram
    class Propriedade {
        +String id
        +String nome
        +String municipio
        +String uf
        +double areaTotalHa
        +DateTime criadoEm
        +DateTime atualizadoEm
    }

    class Talhao {
        +String id
        +String propriedadeId
        +String identificacao
        +String especieId
        +double areaHa
        +int anoPlantio
        +String espacamento
        +String regimeManejo
        +String observacao
        +DateTime criadoEm
        +DateTime atualizadoEm
    }

    class Levantamento {
        +String id
        +String propriedadeId
        +StatusLevantamento status
        +DateTime iniciadoEm
        +DateTime atualizadoEm
        +DateTime concluidoEm
        +concluir()
        +reabrir()
    }

    class TalhaoLevantamento {
        +String id
        +String levantamentoId
        +String talhaoId
        +String especieId
        +String formulaId
        +double areaPadraoParcelaHa
        +DateTime criadoEm
        +DateTime atualizadoEm
    }

    class Parcela {
        +String id
        +String talhaoLevantamentoId
        +String identificacao
        +StatusParcela status
        +double areaHa
        +String posicaoReferencia
        +DateTime criadoEm
        +DateTime atualizadoEm
        +marcarEmAndamento()
        +finalizar()
    }

    class PontoGeografico {
        +String id
        +String parcelaId
        +int ordem
        +double latitude
        +double longitude
        +double precisaoMetros
        +DateTime capturadoEm
    }

    class Arvore {
        +String id
        +String parcelaId
        +int numero
        +double dap
        +double altura
        +double latitude
        +double longitude
        +double precisaoMetros
        +DateTime coordenadaCapturadaEm
        +DateTime criadoEm
        +DateTime atualizadoEm
    }

    class Especie {
        +String id
        +String nome
        +String descricao
        +bool ativa
    }

    class FormulaVolumetrica {
        +String id
        +String nome
        +String descricao
        +String expressao
        +bool ativa
        +validarExpressao()
    }

    class FormulaVariavel {
        +String id
        +String formulaId
        +String simbolo
        +String variavel
        +String unidade
        +String origemValor
    }

    class Coeficiente {
        +String id
        +String formulaId
        +String nome
        +double valor
    }

    class EspecieFormula {
        +String especieId
        +String formulaId
        +bool padrao
    }

    class ResultadoInventario {
        +String levantamentoId
        +double volumeTotal
        +double valorBrutoEstimado
        +DateTime calculadoEm
    }

    class FiltroResultados {
        +String propriedadeId
        +List~String~ talhaoIds
        +String especieId
        +DateTime periodoInicio
        +DateTime periodoFim
    }

    class CalculadoraVolume {
        +calcularVolumeArvore(arvore, formula, coeficientes)
        +calcularResumoParcela(parcela)
        +calcularResumoTalhaoLevantamento(talhaoLevantamento)
        +calcularResumoLevantamento(levantamento)
    }

    class StatusLevantamento {
        <<enumeration>>
        emAndamento
        concluido
    }

    class StatusParcela {
        <<enumeration>>
        pendente
        emAndamento
        coletada
    }

    Propriedade "1" --> "0..*" Talhao
    Propriedade "1" --> "0..*" Levantamento
    Levantamento "1" --> "0..*" TalhaoLevantamento
    Talhao "1" --> "0..*" TalhaoLevantamento
    TalhaoLevantamento "1" --> "0..*" Parcela
    Parcela "1" --> "0..*" Arvore
    Parcela "1" --> "0..*" PontoGeografico
    Especie "1" --> "0..*" EspecieFormula
    FormulaVolumetrica "1" --> "0..*" EspecieFormula
    FormulaVolumetrica "1" --> "0..*" FormulaVariavel
    FormulaVolumetrica "1" --> "0..*" Coeficiente
    Especie "1" --> "0..*" TalhaoLevantamento
    FormulaVolumetrica "1" --> "0..*" TalhaoLevantamento
    Levantamento "1" --> "0..1" ResultadoInventario
    FiltroResultados ..> Propriedade
    FiltroResultados ..> Talhao
    FiltroResultados ..> Especie
    CalculadoraVolume ..> Arvore
    CalculadoraVolume ..> FormulaVolumetrica
    CalculadoraVolume ..> Coeficiente
```

## 5. Modelo Entidade-Relacionamento Inicial

```mermaid
erDiagram
    PROPERTIES ||--o{ STANDS : possui
    PROPERTIES ||--o{ INVENTORY_RUNS : possui
    INVENTORY_RUNS ||--o{ TALHAO_LEVANTAMENTOS : contem
    STANDS ||--o{ TALHAO_LEVANTAMENTOS : participa
    TALHAO_LEVANTAMENTOS ||--o{ PLOTS : contem
    PLOTS ||--o{ TREES : possui
    PLOTS ||--o{ PLOT_GEO_POINTS : possui
    SPECIES ||--o{ SPECIES_FORMULAS : associa
    FORMULAS ||--o{ SPECIES_FORMULAS : associa
    FORMULAS ||--o{ FORMULA_COEFFICIENTS : possui
    FORMULAS ||--o{ FORMULA_VARIABLES : possui

    PROPERTIES {
        text id PK
        text name
        text municipality
        text state
        real total_area_ha
        text created_at
        text updated_at
    }

    STANDS {
        text id PK
        text property_id FK
        text identification
        text species_id FK
        real area_ha
        integer planting_year
        text spacing
        text management_regime
        text notes
        text created_at
        text updated_at
    }

    INVENTORY_RUNS {
        text id PK
        text property_id FK
        text status
        text started_at
        text updated_at
        text completed_at
    }

    TALHAO_LEVANTAMENTOS {
        text id PK
        text inventory_run_id FK
        text stand_id FK
        text species_id FK
        text formula_id FK
        real default_plot_area_ha
        text created_at
        text updated_at
    }

    PLOTS {
        text id PK
        text talhao_levantamento_id FK
        text identification
        text status
        real area_ha
        text reference_position
        text created_at
        text updated_at
    }

    TREES {
        text id PK
        text plot_id FK
        integer number
        real dap
        real height
        real latitude
        real longitude
        real accuracy_meters
        text location_captured_at
        text created_at
        text updated_at
    }

    PLOT_GEO_POINTS {
        text id PK
        text plot_id FK
        integer point_order
        real latitude
        real longitude
        real accuracy_meters
        text captured_at
    }

    SPECIES {
        text id PK
        text name
        text description
        integer active
    }

    FORMULAS {
        text id PK
        text name
        text description
        text expression
        integer active
    }

    SPECIES_FORMULAS {
        text species_id FK
        text formula_id FK
        integer is_default
    }

    FORMULA_COEFFICIENTS {
        text id PK
        text formula_id FK
        text name
        real value
    }

    FORMULA_VARIABLES {
        text id PK
        text formula_id FK
        text symbol
        text variable_key
        text unit
        text value_source
    }
```

## 6. Arquitetura em Camadas

```mermaid
flowchart TB
    UI["Presentation\nTelas, widgets, navegação e estado visual"]
    APP["Application / Services\nCasos de uso e orquestração"]
    DOMAIN["Domain\nEntidades, regras e cálculos puros"]
    DATA["Data\nSQLite, repositórios e mapeamento"]
    DEVICE["Recursos do dispositivo\nGPS/localização e arquivos"]

    UI --> APP
    APP --> DOMAIN
    APP --> DATA
    DATA --> DOMAIN
    APP --> DEVICE

    DOMAIN -.-> CALC["Serviços de cálculo\nVolume, resumo, estimativa econômica"]
    DATA -.-> SQLITE["SQLite local"]
    DEVICE -.-> GPS["Localização do dispositivo"]
    DEVICE -.-> EXPORT["Geração de CSV/PDF/KML/KMZ"]
```

## 7. Fluxo de Navegação Principal

```mermaid
flowchart TD
    APP["Aplicativo"]
    HOME["Início"]
    RUNS["Levantamentos"]
    PROPS["Propriedades"]
    RESULTS["Resultados"]
    SETTINGS["Ajustes"]

    APP --> HOME
    APP --> RUNS
    APP --> PROPS
    APP --> RESULTS
    APP --> SETTINGS

    HOME --> NEW_RUN["Criar novo levantamento"]
    HOME --> CONTINUE_RUN["Continuar levantamento em andamento"]
    HOME --> LAST_DONE["Resumo do último levantamento concluído"]

    RUNS --> OPEN_RUN["Abrir levantamento"]
    OPEN_RUN --> RUN_STANDS["Talhões do levantamento"]
    RUN_STANDS --> RUN_PLOTS["Parcelas"]
    RUN_PLOTS --> RUN_TREES["Árvores e medições"]

    PROPS --> PROPERTY_DETAIL["Detalhe da propriedade"]
    PROPERTY_DETAIL --> PROPERTY_STANDS["Talhões cadastrados"]
    PROPERTY_DETAIL --> PROPERTY_RUNS["Levantamentos da propriedade"]

    RESULTS --> SELECT_PROPERTY["Selecionar propriedade"]
    SELECT_PROPERTY --> PROPERTY_DASHBOARD["Dashboard da propriedade"]

    SETTINGS --> SPECIES["Espécies"]
    SETTINGS --> FORMULAS["Fórmulas/modelos"]
```

## 8. Diagrama de Atividade — Realizar Levantamento

```mermaid
flowchart TD
    START([Início])
    CREATE["Criar ou continuar levantamento"]
    SELECT_PROP["Selecionar/cadastrar propriedade"]
    SELECT_STAND["Selecionar/cadastrar talhões"]
    CONFIRM_MODEL["Confirmar espécie/modelo por talhão"]
    CREATE_PLOT["Criar parcela"]
    GEO_DECISION{"Capturar geolocalização?"}
    CAPTURE_POINTS["Capturar pontos da parcela"]
    ADD_TREE["Registrar árvore"]
    MORE_TREES{"Há mais árvores na parcela?"}
    MORE_PLOTS{"Há mais parcelas?"}
    CALCULATE["Calcular/atualizar resultados"]
    CLOSE_DECISION{"Concluir levantamento?"}
    CLOSE["Marcar como concluído"]
    SAVE_OPEN["Manter em andamento"]
    END([Fim])

    START --> CREATE
    CREATE --> SELECT_PROP
    SELECT_PROP --> SELECT_STAND
    SELECT_STAND --> CONFIRM_MODEL
    CONFIRM_MODEL --> CREATE_PLOT
    CREATE_PLOT --> GEO_DECISION
    GEO_DECISION -- Sim --> CAPTURE_POINTS
    GEO_DECISION -- Não --> ADD_TREE
    CAPTURE_POINTS --> ADD_TREE
    ADD_TREE --> MORE_TREES
    MORE_TREES -- Sim --> ADD_TREE
    MORE_TREES -- Não --> MORE_PLOTS
    MORE_PLOTS -- Sim --> CREATE_PLOT
    MORE_PLOTS -- Não --> CALCULATE
    CALCULATE --> CLOSE_DECISION
    CLOSE_DECISION -- Sim --> CLOSE
    CLOSE_DECISION -- Não --> SAVE_OPEN
    CLOSE --> END
    SAVE_OPEN --> END
```

## 9. Diagrama de Sequência — Calcular Volume

```mermaid
sequenceDiagram
    actor Usuario as Usuário
    participant Tela as Tela de Resultados/Levantamento
    participant Servico as InventoryCalculationService
    participant Repo as Repositórios SQLite
    participant Calc as CalculadoraVolume

    Usuario->>Tela: Solicita visualizar/calcular resultados
    Tela->>Servico: calcularResultado(levantamentoId)
    Servico->>Repo: buscar levantamento, talhaolevantamentos, parcelas, árvores, fórmula, variáveis e coeficientes
    Repo-->>Servico: dados do levantamento
    Servico->>Calc: calcular volumes por árvore
    Calc-->>Servico: volumes calculados
    Servico->>Calc: consolidar resultados disponíveis
    Calc-->>Servico: resumo do levantamento
    Servico-->>Tela: ResultadoInventario
    Tela-->>Usuario: Exibe volume, produtividade e valor bruto
```

## 10. Diagrama de Sequência — Capturar Ponto GPS

```mermaid
sequenceDiagram
    actor Usuario as Usuário
    participant Tela as Tela da Parcela
    participant Geo as GeolocationService
    participant Device as Dispositivo
    participant Repo as PlotGeoPointRepository

    Usuario->>Tela: Toca em "Capturar ponto"
    Tela->>Geo: capturarPonto(parcelaId, ordem)
    Geo->>Device: verificar permissão/localização
    Device-->>Geo: permissão concedida
    Geo->>Device: obter posição atual
    Device-->>Geo: latitude, longitude, precisão
    Geo->>Repo: salvar ponto geográfico
    Repo-->>Geo: ponto salvo
    Geo-->>Tela: ponto capturado
    Tela-->>Usuario: Atualiza lista/mapa de pontos
```

## 11. Diagrama de Sequência — Cadastrar Fórmula Personalizada

```mermaid
sequenceDiagram
    actor Usuario as Responsável técnico
    participant Tela as Tela de Fórmulas
    participant Service as FormulaService
    participant Parser as ExpressionParser
    participant Repo as FormulaRepository

    Usuario->>Tela: Informa nome, expressão, variáveis/símbolos e coeficientes
    Tela->>Service: salvarFormula(dados)
    Service->>Repo: verificar nome único
    Repo-->>Service: nome disponível
    Service->>Parser: validar expressão
    Parser-->>Service: expressão válida e variáveis identificadas
    Service->>Service: verificar se símbolos possuem variáveis reconhecidas
    Service->>Repo: salvar fórmula, variáveis e coeficientes
    Repo-->>Service: fórmula salva
    Service-->>Tela: sucesso
    Tela-->>Usuario: Exibe fórmula cadastrada
```

## 12. Diagrama de Estados — Levantamento

```mermaid
stateDiagram-v2
    [*] --> EmAndamento: criar levantamento
    EmAndamento --> EmAndamento: editar dados / registrar parcelas / registrar árvores
    EmAndamento --> Concluido: concluir levantamento
    Concluido --> EmAndamento: reabrir, se permitido futuramente
    Concluido --> [*]
```

## 13. Observações e Pendências dos Modelos

- Confirmar unidade oficial de produtividade.
- Validar tecnicamente a implementação operacional da extrapolação para amostragem sistemática com parcelas de área fixa.
- Definir quais exportações entram no MVP e quais ficam como evolução.
- Definir se o contorno do talhão será cadastrado, desenhado ou importado futuramente.
