# Modelos de engenharia da versão implementada

Revisão em 13/09/2026, código-base ce282bb. Substitui os diagramas conceituais anteriores. Fontes editáveis estão em diagrams/. Os diagramas representam código e persistência atuais; não certificam validação científica ou ensaios com usuários.

## 1. Atores e funções

Não há autenticação ou perfis distintos. Usuário de campo e engenheiro têm acesso às mesmas funções; a responsabilidade técnica é externa às permissões do software.

O gráfico abaixo é uma visão funcional em Mermaid, não uma notação UML formal de casos de uso. As linhas indicam associação ao usuário, sem sugerir include/extend ou ordem obrigatória. Para UML formal, manter esse escopo ao redesenhar ator, fronteira e elipses.

```mermaid
flowchart LR
    U["Usuário do aplicativo<br/>(profissional de campo ou engenheiro)"]
    subgraph APP["DENDRO Mobile — funções implementadas"]
        C1(["Gerenciar propriedades e talhões"])
        C2(["Preparar parcelas"])
        C3(["Iniciar ou retomar levantamento"])
        C4(["Configurar espécies, modelos e coeficientes"])
        C5(["Registrar e corrigir árvores"])
        C6(["Capturar coordenadas opcionais"])
        C7(["Finalizar parcelas e levantamento"])
        C8(["Consultar resultados calculados"])
        C9(["Exportar dados e resultados"])
        C10(["Consultar atividades e ajustar tema"])
    end
    U --- C1
    U --- C2
    U --- C3
    U --- C4
    U --- C5
    U --- C6
    U --- C7
    U --- C8
    U --- C9
    U --- C10
```

Casos de uso entregues e rastreabilidade:

| Caso | Descrição | Requisitos |
|---|---|---|
| UC-001 | Cadastrar, consultar, editar e excluir propriedade; disponível também em Novo levantamento | RF-001 |
| UC-002 | Gerenciar talhões da propriedade e dimensões de parcela | RF-002 |
| UC-003 | Iniciar levantamento, escolher modelo/coeficientes e aproveitar planejamento/levantamento ativo da propriedade | RF-017 |
| UC-004 | Retomar talhão em coleta pelo Início ou Levantamentos | RF-018 |
| UC-005 | Preparar e gerenciar parcelas; acompanhar status | RF-003, RF-015 |
| UC-006 | Registrar, editar e excluir árvores com DAP/altura e sequência Salvar/Próxima | RF-004, RF-005, RF-012 |
| UC-007 | Capturar localização opcional da árvore e associar referência P1–P4 | RF-020 |
| UC-008 | Gerenciar espécies, vínculos e modelo padrão | RF-006 |
| UC-009 | Cadastrar modelos e configurar coeficientes; sem parser de expressões arbitrárias | RF-007 parcial, RF-008 |
| UC-010 | Calcular volumes ao consultar resultados, com os modelos reconhecidos pela calculadora | RF-009 |
| UC-011 | Filtrar e consultar painel | RF-010, RF-021 |
| UC-012 | Selecionar escopo e exportar PDF, CSV, XLSX ou variantes brutas | RF-016 |
| UC-013 | Exportar KML com coordenadas disponíveis | RF-016, RF-020 |
| UC-014 | Finalizar parcela e concluir levantamento por ações próprias | RF-015, RF-017 |
| UC-015 | Consultar histórico de atividades e alterar tema | Funções auxiliares implementadas |

Não incluir estimativa econômica, parser genérico, sincronização ou KMZ como casos entregues. Captura GPS é opcional e não uma etapa obrigatória de registrar árvore.

## 2. Arquitetura efetiva

```mermaid
flowchart TB
    UI["Telas e widgets Flutter<br/>features/*/presentation"]
    RP["Providers Riverpod<br/>estado e acesso aos repositórios"]
    REPO["Repositórios por funcionalidade<br/>persistência, orquestração e agregações"]
    CALC["ForestVolumeCalculator<br/>equações por árvore e conversões"]
    DB["DendroDatabase / Drift<br/>migrações e SQL explícito"]
    SQL[("SQLite local — 15 tabelas")]
    GEO["Geolocator<br/>permissão e posição do dispositivo"]
    EXPORT["DataExportRepository<br/>PDF, CSV, XLSX e KML"]
    FILE["Salvamento Android / share_plus"]
    UI --> RP
    RP --> REPO
    REPO --> DB
    DB --> SQL
    REPO --> CALC
    UI --> GEO
    GEO --> UI
    UI --> EXPORT
    EXPORT --> DB
    EXPORT --> CALC
    UI --> FILE
    EXPORT --> UI
```

Telas/providers acessam repositórios. O banco usa Drift e SQL explícito; repositórios agregam dados. A calculadora por árvore é separada, enquanto geração de arquivos e agregações de relatório estão no exportador. GPS é solicitado pela tela de coleta; não há GeolocationService separado. Não desenhar camadas Application/Domain inexistentes nem bibliotecas apenas planejadas.

## 3. Modelo de classes de dados

```mermaid
classDiagram
    PropertyRecord "1" --> "0..*" StandRecord
    PropertyRecord "1" --> "0..*" InventoryRunRecord
    InventoryRunRecord "1" --> "0..*" TalhaoLevantamentoRecord
    StandRecord "1" --> "0..*" TalhaoLevantamentoRecord
    SpeciesRecord "1" --> "0..*" StandRecord
    SpeciesRecord "1" --> "0..*" TalhaoLevantamentoRecord
    FormulaRecord "1" --> "0..*" TalhaoLevantamentoRecord
    TalhaoLevantamentoRecord "1" --> "0..*" PlotRecord
    PlotRecord "1" --> "0..*" TreeRecord
    PlotRecord "1" --> "0..*" PlotGeoPointRecord
    FormulaRecord "1" --> "0..*" FormulaVariableRecord
    FormulaRecord "1" --> "0..*" FormulaCoefficientRecord
    SpeciesRecord "1" --> "0..*" SpeciesFormulaRecord
    FormulaRecord "1" --> "0..*" SpeciesFormulaRecord
    SpeciesRecord "1" --> "0..*" SpeciesFormulaCoefficientRecord
    FormulaRecord "1" --> "0..*" SpeciesFormulaCoefficientRecord
    class TreeRecord {
        String id
        String plotId
        int number
        double dapCm
        double heightM
        bool hasTortuousStem
    }
    class TalhaoLevantamentoRecord {
        String id
        String inventoryRunId
        String standId
        String speciesId
        String formulaId
    }
    class ResultsDashboard
    class ResultsRepository {
        watchDashboard(filters)
    }
    class ForestVolumeCalculator {
        treeVolumeM3()
        estimatedHeightM()
        conversionForSpecies()
    }
    ResultsRepository ..> ResultsDashboard : produz em memoria
    ResultsRepository ..> ForestVolumeCalculator : usa
    ResultsRepository ..> TreeRecord : consulta
```

São nomes reais de registros gerados pelo Drift e de classes de cálculo/resultados, com atributos selecionados. Não são entidades de domínio com métodos fictícios concluir()/reabrir(). Ações de persistência ficam nos repositórios. As duas tabelas SQL explícitas (coeficientes da coleta e atividades) são representadas integralmente no modelo do banco, não como registros Drift gerados.

## 4. Relacionamentos do banco

```mermaid
erDiagram
    properties ||--o{ stands : possui
    properties ||--o{ inventory_runs : possui
    species ||--o{ stands : classifica
    inventory_runs ||--o{ talhao_levantamentos : contem
    stands ||--o{ talhao_levantamentos : participa
    species ||--o{ talhao_levantamentos : classifica
    formulas ||--o{ talhao_levantamentos : selecionada
    talhao_levantamentos ||--o{ plots : contem
    plots ||--o{ trees : possui
    plots ||--o{ plot_geo_points : documenta
    formulas ||--o{ formula_variables : declara
    formulas ||--o{ formula_coefficients : define
    species ||--o{ species_formulas : associa
    formulas ||--o{ species_formulas : associa
    species ||--o{ species_formula_coefficients : configura
    formulas ||--o{ species_formula_coefficients : parametriza
    talhao_levantamentos ||--o{ talhao_formula_coefficients : preserva
    activity_logs {
        text id PK
        text entity_type
        text entity_id
    }
```

Cada filho das ligações acima possui uma chave estrangeira obrigatória para exatamente um pai; o pai pode ter zero ou muitos filhos. A representação é estrutural: um levantamento criado pela interface normalmente tem talhão, mas a cardinalidade mínima de filhos não é imposta por uma FK.

activity_logs é independente: entity_type/entity_id são referências lógicas opcionais, sem FK. Não desenhar uma FK inexistente. species_formula_coefficients possui FKs independentes para species e formulas, não uma FK composta para species_formulas.

## 5. Modelo físico completo — 15 tabelas

Fonte: classes Table e comandos CREATE TABLE em dendro_database.dart, schemaVersion 9. IDs textuais, números reais, booleanos armazenados como inteiros, enums como texto e datas no armazenamento inteiro padrão do Drift. “nullable” identifica campo opcional.

```mermaid
erDiagram
    properties ||--o{ stands : possui
    properties ||--o{ inventory_runs : possui
    species ||--o{ stands : classifica
    inventory_runs ||--o{ talhao_levantamentos : contem
    stands ||--o{ talhao_levantamentos : participa
    species ||--o{ talhao_levantamentos : classifica
    formulas ||--o{ talhao_levantamentos : selecionada
    talhao_levantamentos ||--o{ plots : contem
    plots ||--o{ trees : possui
    plots ||--o{ plot_geo_points : documenta
    formulas ||--o{ formula_variables : declara
    formulas ||--o{ formula_coefficients : define
    species ||--o{ species_formulas : associa
    formulas ||--o{ species_formulas : associa
    species ||--o{ species_formula_coefficients : configura
    formulas ||--o{ species_formula_coefficients : parametriza
    talhao_levantamentos ||--o{ talhao_formula_coefficients : preserva
    properties {
        text id PK
        text name
        text municipality
        text state
        real total_area_ha
        integer created_at
        integer updated_at
    }
    species {
        text id PK
        text name UK
        text scientific_name "nullable"
        text description "nullable"
        integer active
        integer created_at
        integer updated_at
    }
    formulas {
        text id PK
        text name UK
        text description "nullable"
        text expression
        integer active
        integer created_at
        integer updated_at
    }
    formula_variables {
        text id PK
        text formula_id FK
        text symbol
        text label
        text unit
        text value_source
        text variable_key
    }
    formula_coefficients {
        text id PK
        text formula_id FK
        text symbol
        text label
        real value "nullable"
    }
    species_formulas {
        text species_id PK,FK
        text formula_id PK,FK
        integer is_default
        integer created_at
    }
    species_formula_coefficients {
        text id PK
        text species_id FK
        text formula_id FK
        text symbol
        text label
        real value "nullable"
        integer updated_at
    }
    stands {
        text id PK
        text property_id FK
        text identification
        text species_id FK
        real area_ha
        integer planting_year "nullable"
        text spacing "nullable"
        text management_regime "nullable"
        real plot_width_m "nullable"
        real plot_length_m "nullable"
        text notes "nullable"
        integer created_at
        integer updated_at
    }
    inventory_runs {
        text id PK
        text property_id FK
        text status
        integer started_at
        integer updated_at
        integer completed_at "nullable"
    }
    talhao_levantamentos {
        text id PK
        text inventory_run_id FK
        text stand_id FK
        text species_id FK
        text formula_id FK
        real default_plot_area_ha "nullable"
        integer created_at
        integer updated_at
    }
    talhao_formula_coefficients {
        text id PK
        text talhao_levantamento_id FK
        text symbol
        text label
        real value "nullable"
    }
    plots {
        text id PK
        text talhao_levantamento_id FK
        text identification
        text status
        real area_ha "nullable"
        text reference_position "nullable"
        integer created_at
        integer updated_at
    }
    plot_geo_points {
        text id PK
        text plot_id FK
        integer point_order
        text reference_position "nullable"
        real latitude
        real longitude
        real accuracy_meters "nullable"
        integer captured_at
    }
    trees {
        text id PK
        text plot_id FK
        integer number
        real dap_cm
        real height_m
        integer has_tortuous_stem
        real latitude "nullable"
        real longitude "nullable"
        real accuracy_meters "nullable"
        integer location_captured_at "nullable"
        text plot_reference_position "nullable"
        integer created_at
        integer updated_at
    }
    activity_logs {
        text id PK
        text type
        text title
        text subtitle
        text entity_type "nullable"
        text entity_id "nullable"
        integer occurred_at
    }
```

### Chaves e restrições compostas

- properties: PK id.
- species e formulas: PK id, nome único.
- species_formulas: PK composta (species_id, formula_id).
- stands: UNIQUE(property_id, identification).
- talhao_levantamentos: UNIQUE(inventory_run_id, stand_id).
- plots: UNIQUE(talhao_levantamento_id, identification).
- trees: UNIQUE(plot_id, number).
- plot_geo_points: UNIQUE(plot_id, point_order).
- formula_variables e formula_coefficients: UNIQUE(formula_id, symbol).
- species_formula_coefficients: UNIQUE(species_id, formula_id, symbol).
- talhao_formula_coefficients: UNIQUE(talhao_levantamento_id, symbol).
- Todas as demais tabelas usam PK id; activity_logs não possui FK.

As FKs declaram CASCADE, exceto stands.species_id e talhao_levantamentos.species_id/formula_id, que declaram RESTRICT. Essa descrição é do esquema; repositórios também executam exclusões explícitas. Não afirmar que constraints sozinhas cobrem toda regra de interface.

talhao_formula_coefficients e activity_logs são criadas por SQL nas rotinas de criação/migração, além das 13 tabelas de @DriftDatabase. ResultadoInventario, Measurements e VolumeModel não são tabelas adicionais. DAP/altura ficam em trees; o catálogo volumétrico fica em formulas.

## 6. Fluxo operacional

```mermaid
flowchart TD
    A(["Início"]) --> B["Selecionar ou cadastrar propriedade e talhão"]
    B --> C{"Já existe coleta ativa?"}
    C -- Sim --> D["Retomar talhão no levantamento"]
    C -- Não --> E["Escolher modelo e coeficientes"]
    E --> F["Iniciar coleta / aproveitar planejamento<br/>e levantamento ativo da propriedade"]
    F --> G["Abrir ou cadastrar parcela"]
    D --> G
    G --> H["Informar DAP cm, altura m e tronco torto"]
    H --> I{"Capturar GPS?"}
    I -- Sim --> J["Solicitar localização<br/>e referência P1–P4 quando escolhida"]
    I -- Não --> K["Salvar árvore"]
    J --> K
    K --> L{"Registrar próxima árvore?"}
    L -- Sim --> H
    L -- Não --> M{"Finalizar parcela?"}
    M -- Sim --> N["Marcar parcela como coletada"]
    M -- Não --> O["Preservar dados e coleta em andamento"]
    N --> P["Continuar parcelas ou consultar resultados"]
    O --> P
    P --> Q["Finalizar levantamento quando solicitado"]
    Q --> R["Exportar no escopo selecionado"]
    R --> S(["Fim"])
```

Este é um percurso de uso, não uma regra que obrigue finalizar tudo antes de consultar/exportar: o aplicativo permite resultados e exportação com coleta em andamento. As etapas acadêmicas da pesquisa devem ser representadas em outro fluxograma, baseado na metodologia efetivamente executada do artigo.

## 7. Sequência de consulta de resultados

```mermaid
sequenceDiagram
    actor U as Usuário
    participant T as Tela de resultados
    participant P as Provider Riverpod
    participant R as ResultsRepository
    participant D as DendroDatabase
    participant C as ForestVolumeCalculator
    U->>T: Selecionar filtros
    T->>P: Observar painel filtrado
    P->>R: watchDashboard(filters)
    R->>D: Consultar parcelas, vínculos, fórmulas e árvores
    D-->>R: Registros locais
    R->>D: Ler coeficientes da coleta ou catálogo
    D-->>R: Coeficientes
    loop Árvores incluídas
        R->>C: treeVolumeM3(medições, modelo, coeficientes)
        C-->>R: Volume da árvore
    end
    R->>R: Somar volumes, áreas e indicadores
    R-->>P: ResultsDashboard
    P-->>T: Estado atualizado
    T-->>U: Apresentar resultados
```

A sequência usa componentes reais. O stream da consulta acompanha dados locais; o painel agrega registros compatíveis com os filtros. A exportação tem escopo próprio, conforme REQUIREMENTS.md.

## 8. Estados

```mermaid
stateDiagram-v2
    [*] --> Planejamento: preparar parcelas
    [*] --> EmAndamento: iniciar coleta
    Planejamento --> EmAndamento: promover planejamento
    EmAndamento --> EmAndamento: continuar coleta ou incluir talhão
    EmAndamento --> Finalizado: concluir levantamento
    Finalizado --> [*]
```

Os nomes persistidos são planning, inProgress e completed. O diagrama mostra o percurso de criação/coleta/conclusão, omitindo exclusões e rotinas de normalização. Não inclui reabertura futura como função implementada.

Parcelas têm pending, inProgress e collected. A gravação de árvores e a finalização de parcela são ações separadas; status da parcela e do levantamento não são uma única máquina de estados.

## 9. Uso das figuras no artigo

A visão de relacionamentos é mais legível no corpo do artigo; o modelo com todos os atributos pode ser apêndice ou dividido em coleta e catálogos. Manter nomes/cardinalidades ao redesenhar. Legendas sugeridas: “Funções implementadas do DENDRO Mobile”, “Arquitetura da aplicação” e “Modelo de dados da aplicação”. Indicar elaboração própria com base na implementação.

Para descrever resultados, observar as limitações em BUSINESS_RULES.md: fórmulas genéricas não interpretadas, valores padrão, ausência de estimativa econômica, escopos históricos distintos e validação acadêmica pendente.
