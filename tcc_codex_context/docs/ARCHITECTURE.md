# ARCHITECTURE.md

## Estado da arquitetura
O TCC define a stack e o funcionamento autônomo/offline, mas não fixa um padrão arquitetural de software específico. A estrutura abaixo é uma **arquitetura inicial recomendada para implementação**, mantendo simplicidade adequada ao TCC.

## Stack
- Flutter
- Dart
- SQLite
- Drift
- Riverpod
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
- criar levantamento;
- continuar levantamento em andamento;
- registrar árvore;
- calcular inventário;
- gerar estimativa econômica;
- capturar pontos de geolocalização;
- exportar dados.
- exportar KML/KMZ.

### 3. Domain
Contém entidades e regras de negócio independentes da interface:
- Property / Propriedade;
- Stand / Talhão;
- InventoryRun / Levantamento;
- TalhaoLevantamento / talhaolevantamento;
- Plot / Parcela;
- Tree / Árvore;
- Species / Espécie;
- VolumeModel / ModeloVolumétrico;
- Formula / Fórmula personalizada;
- Coefficients / Coeficientes;
- GeoPoint / Ponto de geolocalização;
- Measurements / Medições;
- InventoryResult / ResultadoInventário.

Também deve conter serviços puros de cálculo, testáveis sem Flutter/SQLite.

### 4. Data
Responsável por SQLite, mapeamento e repositórios.

Exemplos:
- PropertyRepository
- StandRepository
- InventoryRepository
- PlotRepository
- TreeRepository
- SpeciesRepository
- VolumeModelRepository
- FormulaRepository
- PlotGeoPointRepository

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
│   ├── inventory_runs/
│   ├── plots/
│   ├── trees/
│   ├── species/
│   ├── formulas/
│   ├── volume_models/
│   ├── inventory/
│   ├── results/
│   ├── geolocation/
│   ├── settings/
│   └── export/
└── main.dart
```

Dentro de cada feature, manter separação simples entre `data`, `domain` e `presentation` apenas quando isso trouxer clareza. Não criar abstrações vazias apenas para seguir padrão.

## Modelo conceitual inicial
```text
Propriedade 1 ---- N Talhão
Propriedade 1 ---- N Levantamento
Levantamento 1 ---- N talhaolevantamento
Talhão      1 ---- N talhaolevantamento
talhaolevantamento 1 ---- N Parcela
Parcela     1 ---- N Árvore

talhaolevantamento ---- Espécie
talhaolevantamento ---- Fórmula/Modelo Volumétrico
Fórmula/Modelo Volumétrico ---- Coeficientes
Parcela ---- Pontos de geolocalização
Árvore ---- Coordenada opcional
```

`talhaolevantamento` é a associação entre um levantamento e um talhão. Essa entidade guarda o contexto da coleta daquele talhão naquele levantamento, incluindo espécie/modelo/fórmula escolhidos, área padrão de parcela quando existir e informações necessárias para manter histórico de novas coletas.

Como uma propriedade pode possuir vários levantamentos, a entidade `InventoryRun`/`Levantamento` deve separar o cadastro permanente da propriedade/talhão dos dados medidos em uma coleta específica.

## Banco de dados — proposta inicial
Tabelas candidatas:
- `properties`
- `stands`
- `inventory_runs`
- `talhao_levantamentos`
- `plots`
- `trees`
- `species`
- `volume_models`
- `formulas`
- `model_coefficients`
- `formula_variables`
- `species_formulas`
- `plot_geo_points`

**Importante:** múltiplos levantamentos por propriedade são requisito do projeto. Um levantamento pode envolver vários talhões, portanto a modelagem deve prever associação entre levantamento e talhões por meio de `talhao_levantamentos`.

Campos candidatos para `properties`:
- `id`
- `name`
- `municipality`
- `state`
- `total_area_ha`
- `created_at`
- `updated_at`

Campos candidatos para `inventory_runs`:
- `id`
- `property_id`
- `status`
- `started_at`
- `updated_at`
- `completed_at`

Campos candidatos para `talhao_levantamentos`:
- `id`
- `inventory_run_id`
- `stand_id`
- `species_id`
- `volume_model_id` ou `formula_id`
- `default_plot_area_ha` opcional
- `created_at`
- `updated_at`

Campos candidatos para `stands`:
- `id`
- `property_id`
- `identification`
- `species_id`
- `area_ha`
- `planting_year` opcional
- `spacing` opcional
- `management_regime` opcional
- `notes` opcional
- `created_at`
- `updated_at`

Campos candidatos para `plots`:
- `id`
- `talhao_levantamento_id`
- `identification`
- `status`
- `area_ha` opcional
- `reference_position` opcional
- `created_at`
- `updated_at`

Campos candidatos para `plot_geo_points`:
- `id`
- `plot_id`
- `point_order`
- `latitude`
- `longitude`
- `accuracy_meters`
- `captured_at`

Campos opcionais candidatos para `trees`:
- `latitude`
- `longitude`
- `accuracy_meters`
- `location_captured_at`

## Cálculos
Criar funções/serviços puros, por exemplo:
```text
calculateTreeVolume(...)
calculatePlotSummary(...)
calculateStandSummary(...)
calculateVolumePerHectare(...)
calculateStandExtrapolatedVolume(...)
calculateGrossEconomicEstimate(...)
```

Não misturar cálculo com persistência ou widgets.

Para amostragem sistemática com parcelas de área fixa, a consolidação deve considerar:
- volume total medido nas parcelas;
- área total amostrada;
- volume por hectare;
- área do talhão;
- volume extrapolado do talhão.

Sem área amostrada disponível, não calcular indicadores por hectare ou extrapolados.

## Estratégia para modelos matemáticos
Criar uma abstração que permita mais de um modelo, por exemplo:
```text
VolumeModelCalculator
  - SpurrCalculator
  - SchumacherHallCalculator
  - ExpressionFormulaCalculator
```

Os coeficientes devem ser fornecidos ao cálculo, não embutidos como constantes universais.

Para fórmulas personalizadas, usar `math_expressions`. A implementação deve validar a expressão, limitar variáveis/funções permitidas e tratar erros de avaliação, como variável ausente, divisão por zero ou resultado não numérico.

Cada fórmula deve declarar os símbolos/letras usados na expressão. Esses símbolos devem apontar para variáveis reconhecidas pelo domínio, inicialmente DAP, altura, idade e área basal. Exemplo conceitual: uma fórmula pode usar `D` para DAP, `H` para altura, `I` para idade e `G` para área basal, desde que esses vínculos estejam salvos junto da fórmula.

Não executar código arbitrário informado pelo usuário.

## Navegação e telas principais
A navegação principal prevista usa barra inferior com:
- Início;
- Levantamentos;
- Propriedades;
- Resultados;
- Ajustes.

A aba Ajustes deve concentrar cadastros auxiliares, como espécies e fórmulas/modelos matemáticos.

A aba Resultados deve funcionar como dashboard analítico, inicialmente orientado à seleção de uma propriedade e aos levantamentos vinculados.

## Estado e gerenciamento de dependências

Usar Riverpod para estado e injeção de dependências da aplicação.

Usar Drift para acesso ao SQLite local e migrações.

Bibliotecas previstas:
- `drift`;
- `flutter_riverpod`;
- `math_expressions`;
- `geolocator`;
- `fl_chart`;
- `pdf`;
- `printing`;
- `csv`;
- `excel`.

## Exportação
A exportação deve consumir dados de domínio/repositórios e gerar arquivos sem alterar as regras de cálculo.

Exportação KML/KMZ deve consumir pontos de geolocalização armazenados e gerar representação compatível com Google Earth para parcelas, árvores com coordenada capturada e, futuramente, outros elementos geográficos.

## Testes
Prioridade alta para:
1. modelos volumétricos;
2. consolidação de volume;
3. estimativa econômica;
4. validações de entrada;
5. fórmulas personalizadas e erros de avaliação;
6. repositórios SQLite principais;
7. geração de KML/KMZ, quando implementada.

## Evolução futura
A arquitetura deve permitir adicionar futuramente uma camada de sincronização remota sem substituir o domínio local. O banco SQLite continua sendo útil como armazenamento local/cache mesmo em uma eventual versão conectada.
