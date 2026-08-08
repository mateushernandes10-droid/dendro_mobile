# ARCHITECTURE.md

## Estado da arquitetura
O TCC define a stack e o funcionamento autônomo/offline, mas não fixa um padrão arquitetural de software específico. A estrutura abaixo é uma **arquitetura inicial recomendada para implementação**, mantendo simplicidade adequada ao TCC.

## Stack
- Flutter
- Dart
- SQLite
- Git/GitHub
- Sem backend na primeira versão

## Princípio principal
**Offline-first / local-first**: banco e processamento ficam no próprio dispositivo.

## Camadas recomendadas

### 1. Presentation
Responsável por telas, widgets, navegação e estado visual.

Não deve conter SQL nem fórmulas volumétricas diretamente.

### 2. Application / Services
Orquestra casos de uso, por exemplo:
- cadastrar propriedade;
- cadastrar talhão;
- registrar árvore;
- calcular inventário;
- gerar estimativa econômica;
- exportar dados.

### 3. Domain
Contém entidades e regras de negócio independentes da interface:
- Property / Propriedade;
- Stand / Talhão;
- Plot / Parcela;
- Tree / Árvore;
- Species / Espécie;
- VolumeModel / ModeloVolumétrico;
- Coefficients / Coeficientes;
- Measurements / Medições;
- InventoryResult / ResultadoInventário.

Também deve conter serviços puros de cálculo, testáveis sem Flutter/SQLite.

### 4. Data
Responsável por SQLite, mapeamento e repositórios.

Exemplos:
- PropertyRepository
- StandRepository
- PlotRepository
- TreeRepository
- VolumeModelRepository

## Estrutura de pastas sugerida
```text
lib/
├── app/
│   ├── app.dart
│   └── routes/
├── core/
│   ├── database/
│   ├── errors/
│   ├── utils/
│   └── constants/
├── features/
│   ├── properties/
│   ├── stands/
│   ├── plots/
│   ├── trees/
│   ├── volume_models/
│   ├── inventory/
│   └── export/
└── main.dart
```

Dentro de cada feature, manter separação simples entre `data`, `domain` e `presentation` apenas quando isso trouxer clareza. Não criar abstrações vazias apenas para seguir padrão.

## Modelo conceitual inicial
```text
Propriedade 1 ---- N Talhão
Talhão      1 ---- N Parcela
Parcela     1 ---- N Árvore

Talhão/Inventário ---- Espécie
Talhão/Inventário ---- Modelo Volumétrico
Modelo Volumétrico ---- Coeficientes
```

A localização exata de espécie/modelo/coeficientes no esquema deve ser confirmada durante a modelagem. Evitar duplicação desnecessária.

## Banco de dados — proposta inicial
Tabelas candidatas:
- `properties`
- `stands`
- `plots`
- `trees`
- `species`
- `volume_models`
- `model_coefficients`
- opcionalmente `inventory_runs` / `inventories`, caso seja necessário manter diferentes levantamentos da mesma área ao longo do tempo.

**Importante:** não fechar o schema antes de confirmar se o sistema precisa permitir múltiplos inventários para a mesma propriedade/talhão em datas diferentes. Essa decisão impacta fortemente o banco.

## Cálculos
Criar funções/serviços puros, por exemplo:
```text
calculateTreeVolume(...)
calculatePlotSummary(...)
calculateStandSummary(...)
calculateGrossEconomicEstimate(...)
```

Não misturar cálculo com persistência ou widgets.

## Estratégia para modelos matemáticos
Criar uma abstração que permita mais de um modelo, por exemplo:
```text
VolumeModelCalculator
  - SpurrCalculator
  - SchumacherHallCalculator
```

Os coeficientes devem ser fornecidos ao cálculo, não embutidos como constantes universais.

## Estado e gerenciamento de dependências
Ainda não há decisão formal no TCC sobre Provider, Riverpod, Bloc etc.

Para o início, escolher a solução mais simples compatível com o tamanho do aplicativo. Registrar a escolha em `DECISIONS.md` antes de espalhá-la pelo projeto.

## Exportação
A exportação deve consumir dados de domínio/repositórios e gerar arquivos sem alterar as regras de cálculo.

## Testes
Prioridade alta para:
1. modelos volumétricos;
2. consolidação de volume;
3. estimativa econômica;
4. validações de entrada;
5. repositórios SQLite principais.

## Evolução futura
A arquitetura deve permitir adicionar futuramente uma camada de sincronização remota sem substituir o domínio local. O banco SQLite continua sendo útil como armazenamento local/cache mesmo em uma eventual versão conectada.
