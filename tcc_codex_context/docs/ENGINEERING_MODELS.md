# Modelos de engenharia da versão implementada

Revisão em 14/09/2026, versão v11 com IDs inteiros. Substitui os diagramas conceituais anteriores. Fontes editáveis estão em diagrams/. Os diagramas representam código e persistência atuais; não certificam validação científica ou ensaios com usuários.

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
| UC-005 | Preparar e gerenciar parcelas; acompanhar situacao | RF-003, RF-015 |
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
    RP["Provedores Riverpod<br/>estado e acesso aos repositórios"]
    REPO["Repositórios por funcionalidade<br/>persistência, orquestração e agregações"]
    CALC["CalculadoraVolumeFlorestal<br/>equações por árvore e conversões"]
    DB["BancoDendro / Drift<br/>migrações e SQL explícito"]
    SQL[("SQLite local — 15 tabelas")]
    GEO["Geolocator<br/>permissão e posição do dispositivo"]
    EXPORT["RepositorioExportacaoDados<br/>PDF, CSV, XLSX e KML"]
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
    Propriedade "1" --> "0..*" Talhao
    Propriedade "1" --> "0..*" Levantamento
    Levantamento "1" --> "0..*" TalhaoLevantamento
    Talhao "1" --> "0..*" TalhaoLevantamento
    Especie "1" --> "0..*" Talhao
    Especie "1" --> "0..*" TalhaoLevantamento
    ModeloMatematico "1" --> "0..*" TalhaoLevantamento
    TalhaoLevantamento "1" --> "0..*" Parcela
    Parcela "1" --> "0..*" Arvore
    Parcela "1" --> "0..*" PontoGeograficoParcela
    ModeloMatematico "1" --> "0..*" VariavelModelo
    ModeloMatematico "1" --> "0..*" CoeficienteModelo
    Especie "1" --> "0..*" EspecieModelo
    ModeloMatematico "1" --> "0..*" EspecieModelo
    Especie "1" --> "0..*" CoeficienteEspecieModelo
    ModeloMatematico "1" --> "0..*" CoeficienteEspecieModelo
    class Arvore {
        int id
        int parcelaId
        int numero
        double dapCm
        double alturaM
        bool possuiTroncoTortuoso
    }
    class TalhaoLevantamento {
        int id
        int levantamentoId
        int talhaoId
        int especieId
        int modeloMatematicoId
    }
    class Propriedade {
        int id
    }
    class Talhao {
        int id
        int propriedadeId
        int especieId
    }
    class Levantamento {
        int id
        int propriedadeId
    }
    class Especie {
        int id
        String codigo
    }
    class ModeloMatematico {
        int id
        String codigo
    }
    class Parcela {
        int id
        int talhaoLevantamentoId
    }
    class PontoGeograficoParcela {
        int id
        int parcelaId
    }
    class VariavelModelo {
        int id
        int modeloMatematicoId
    }
    class CoeficienteModelo {
        int id
        int modeloMatematicoId
    }
    class EspecieModelo {
        int especieId
        int modeloMatematicoId
    }
    class CoeficienteEspecieModelo {
        int id
        int especieId
        int modeloMatematicoId
    }
    class RegistroAtividade {
        int id
        int entidadeId
        String referenciaLegada
    }
    class PainelResultados
    class RepositorioResultados {
        observarPainel(filtros)
    }
    class CalculadoraVolumeFlorestal {
        volumeArvoreM3()
        estimarAlturaM()
        conversaoParaEspecie()
    }
    RepositorioResultados ..> PainelResultados : produz em memoria
    RepositorioResultados ..> CalculadoraVolumeFlorestal : usa
    RepositorioResultados ..> Arvore : consulta
```

São nomes reais de registros gerados pelo Drift e de classes de cálculo/resultados, com atributos selecionados. Não são entidades de domínio com métodos fictícios concluir()/reabrir(). Ações de persistência ficam nos repositórios. As duas tabelas SQL explícitas (coeficientes da coleta e atividades) são representadas integralmente no modelo do banco, não como registros Drift gerados.

## 4. Relacionamentos do banco

```mermaid
erDiagram
    %% Schema v11: PKs e FKs inteiras; cardinalidades preservadas.
    propriedades ||--o{ talhoes : possui
    propriedades ||--o{ levantamentos : possui
    especies ||--o{ talhoes : classifica
    levantamentos ||--o{ talhao_levantamentos : contem
    talhoes ||--o{ talhao_levantamentos : participa
    especies ||--o{ talhao_levantamentos : classifica
    modelos_matematicos ||--o{ talhao_levantamentos : selecionada
    talhao_levantamentos ||--o{ parcelas : contem
    parcelas ||--o{ arvores : possui
    parcelas ||--o{ pontos_geograficos_parcela : documenta
    modelos_matematicos ||--o{ variaveis_modelo : declara
    modelos_matematicos ||--o{ coeficientes_modelo : define
    especies ||--o{ especies_modelos : associa
    modelos_matematicos ||--o{ especies_modelos : associa
    especies ||--o{ coeficientes_especie_modelo : configura
    modelos_matematicos ||--o{ coeficientes_especie_modelo : parametriza
    talhao_levantamentos ||--o{ coeficientes_talhao_levantamento : preserva
    registros_atividade {
        text id PK
        text tipo_entidade
        text entidade_id
    }
```

Cada filho das ligações acima possui uma chave estrangeira obrigatória para exatamente um pai; o pai pode ter zero ou muitos filhos. A representação é estrutural: um levantamento criado pela interface normalmente tem talhão, mas a cardinalidade mínima de filhos não é imposta por uma FK.

registros_atividade é independente: tipo_entidade/entidade_id são referências lógicas opcionais, sem FK. Não desenhar uma FK inexistente. coeficientes_especie_modelo possui FKs independentes para especies e modelos_matematicos, não uma FK composta para especies_modelos.

## 5. Modelo físico completo — 15 tabelas

Fonte: classes Table e comandos CREATE TABLE em banco_dendro.dart, schemaVersion 11. IDs inteiros autoincrementados; FKs inteiras, números reais, booleanos armazenados como inteiros, enums como texto e datas no armazenamento inteiro padrão do Drift. “nullable” identifica campo opcional.

```mermaid
erDiagram
    propriedades ||--o{ talhoes : possui
    propriedades ||--o{ levantamentos : possui
    especies ||--o{ talhoes : classifica
    levantamentos ||--o{ talhao_levantamentos : contem
    talhoes ||--o{ talhao_levantamentos : participa
    especies ||--o{ talhao_levantamentos : classifica
    modelos_matematicos ||--o{ talhao_levantamentos : selecionada
    talhao_levantamentos ||--o{ parcelas : contem
    parcelas ||--o{ arvores : possui
    parcelas ||--o{ pontos_geograficos_parcela : documenta
    modelos_matematicos ||--o{ variaveis_modelo : declara
    modelos_matematicos ||--o{ coeficientes_modelo : define
    especies ||--o{ especies_modelos : associa
    modelos_matematicos ||--o{ especies_modelos : associa
    especies ||--o{ coeficientes_especie_modelo : configura
    modelos_matematicos ||--o{ coeficientes_especie_modelo : parametriza
    talhao_levantamentos ||--o{ coeficientes_talhao_levantamento : preserva
    propriedades {
        integer id PK
        text nome
        text municipio
        text estado
        real area_total_ha
        integer criado_em
        integer atualizado_em
    }
    especies {
        integer id PK
        text codigo UK "nullable"
        text nome UK
        text nome_cientifico "nullable"
        text descricao "nullable"
        integer ativo
        integer criado_em
        integer atualizado_em
    }
    modelos_matematicos {
        integer id PK
        text codigo UK "nullable"
        text nome UK
        text descricao "nullable"
        text expressao
        integer ativo
        integer criado_em
        integer atualizado_em
    }
    variaveis_modelo {
        integer id PK
        integer modelo_matematico_id FK
        text simbolo
        text rotulo
        text unidade
        text origem_valor
        text chave_variavel
    }
    coeficientes_modelo {
        integer id PK
        integer modelo_matematico_id FK
        text simbolo
        text rotulo
        real valor "nullable"
    }
    especies_modelos {
        integer especie_id PK,FK
        integer modelo_matematico_id PK,FK
        integer padrao
        integer criado_em
    }
    coeficientes_especie_modelo {
        integer id PK
        integer especie_id FK
        integer modelo_matematico_id FK
        text simbolo
        text rotulo
        real valor "nullable"
        integer atualizado_em
    }
    talhoes {
        integer id PK
        integer propriedade_id FK
        text identificacao
        integer especie_id FK
        real area_ha
        integer ano_plantio "nullable"
        text espacamento "nullable"
        text regime_manejo "nullable"
        real largura_parcela_m "nullable"
        real comprimento_parcela_m "nullable"
        text observacoes "nullable"
        integer criado_em
        integer atualizado_em
    }
    levantamentos {
        integer id PK
        integer propriedade_id FK
        text situacao
        integer iniciado_em
        integer atualizado_em
        integer concluido_em "nullable"
    }
    talhao_levantamentos {
        integer id PK
        integer levantamento_id FK
        integer talhao_id FK
        integer especie_id FK
        integer modelo_matematico_id FK
        real area_padrao_parcela_ha "nullable"
        integer criado_em
        integer atualizado_em
    }
    coeficientes_talhao_levantamento {
        integer id PK
        integer talhao_levantamento_id FK
        text simbolo
        text rotulo
        real valor "nullable"
    }
    parcelas {
        integer id PK
        integer talhao_levantamento_id FK
        text identificacao
        text situacao
        real area_ha "nullable"
        text posicao_referencia "nullable"
        integer criado_em
        integer atualizado_em
    }
    pontos_geograficos_parcela {
        integer id PK
        integer parcela_id FK
        integer ordem_ponto
        text posicao_referencia "nullable"
        real latitude
        real longitude
        real precisao_metros "nullable"
        integer capturado_em
    }
    arvores {
        integer id PK
        integer parcela_id FK
        integer numero
        real dap_cm
        real altura_m
        integer possui_tronco_tortuoso
        real latitude "nullable"
        real longitude "nullable"
        real precisao_metros "nullable"
        integer localizacao_capturada_em "nullable"
        text posicao_referencia_parcela "nullable"
        integer criado_em
        integer atualizado_em
    }
    registros_atividade {
        integer id PK
        text tipo
        text titulo
        text subtitulo
        text tipo_entidade "nullable"
        integer entidade_id "nullable"
        text referencia_legada "nullable"
        integer ocorrido_em
    }
```

### Chaves e restrições compostas

- propriedades: PK id.
- especies e modelos_matematicos: PK id, nome único.
- especies_modelos: PK composta (especie_id, modelo_matematico_id).
- talhoes: UNIQUE(propriedade_id, identificacao).
- talhao_levantamentos: UNIQUE(levantamento_id, talhao_id).
- parcelas: UNIQUE(talhao_levantamento_id, identificacao).
- arvores: UNIQUE(parcela_id, numero).
- pontos_geograficos_parcela: UNIQUE(parcela_id, ordem_ponto).
- variaveis_modelo e coeficientes_modelo: UNIQUE(modelo_matematico_id, simbolo).
- coeficientes_especie_modelo: UNIQUE(especie_id, modelo_matematico_id, simbolo).
- coeficientes_talhao_levantamento: UNIQUE(talhao_levantamento_id, simbolo).
- Todas as demais tabelas usam PK id; registros_atividade não possui FK.

As FKs declaram CASCADE, exceto talhoes.especie_id e talhao_levantamentos.especie_id/modelo_matematico_id, que declaram RESTRICT. Essa descrição é do esquema; repositórios também executam exclusões explícitas. Não afirmar que constraints sozinhas cobrem toda regra de interface.

coeficientes_talhao_levantamento e registros_atividade são criadas por SQL nas rotinas de criação/migração, além das 13 tabelas de @DriftDatabase. ResultadoInventario, Medicoes e VolumeModel não são tabelas adicionais. DAP/altura ficam em arvores; o catálogo volumétrico fica em modelos_matematicos.

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
    participant P as Provedor Riverpod
    participant R as RepositorioResultados
    participant D as BancoDendro
    participant C as CalculadoraVolumeFlorestal
    U->>T: Selecionar filtros
    T->>P: Observar painel filtrado
    P->>R: observarPainel(filtros)
    R->>D: Consultar parcelas, vínculos, fórmulas e árvores
    D-->>R: Registros locais
    R->>D: Ler coeficientes da coleta ou catálogo
    D-->>R: Coeficientes
    loop Árvores incluídas
        R->>C: volumeArvoreM3(medições, modelo, coeficientes)
        C-->>R: Volume da árvore
    end
    R->>R: Somar volumes, áreas e indicadores
    R-->>P: PainelResultados
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

Os nomes persistidos são planejamento, emAndamento e concluido. O diagrama mostra o percurso de criação/coleta/conclusão, omitindo exclusões e rotinas de normalização. Não inclui reabertura futura como função implementada.

Parcelas têm pendente, emAndamento e coletada. A gravação de árvores e a finalização de parcela são ações separadas; situacao da parcela e do levantamento não são uma única máquina de estados.

## 9. Uso das figuras no artigo

A visão de relacionamentos é mais legível no corpo do artigo; o modelo com todos os atributos pode ser apêndice ou dividido em coleta e catálogos. Manter nomes/cardinalidades ao redesenhar. Legendas sugeridas: “Funções implementadas do DENDRO Mobile”, “Arquitetura da aplicação” e “Modelo de dados da aplicação”. Indicar elaboração própria com base na implementação.

Para descrever resultados, observar as limitações em BUSINESS_RULES.md: fórmulas genéricas não interpretadas, valores padrão, ausência de estimativa econômica, escopos históricos distintos e validação acadêmica pendente.

No diagrama de classes, codigo de Especie/ModeloMatematico e entidadeId/referenciaLegada de RegistroAtividade são opcionais. A nulabilidade física está detalhada no diagrama completo. EspecieModelo conserva PK composta; RegistroAtividade não tem FK para uma entidade única.

## Identificadores — schema v11

As 14 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a PK composta (especie_id, modelo_matematico_id), ambas inteiras. Espécies e modelos têm codigo textual único e opcional: os padrões conservam seus códigos estáveis; cadastros personalizados não precisam gerar códigos nem UUID. As regras de escolha de modelos usam codigo, sem alterar expressões ou coeficientes. registros_atividade usa entidade_id inteiro opcional, sem FK polimórfica; referencia_legada conserva apenas referências antigas sem entidade correspondente. São 15 tabelas e 115 colunas.
