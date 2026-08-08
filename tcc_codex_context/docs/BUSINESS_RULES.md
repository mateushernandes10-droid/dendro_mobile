# BUSINESS_RULES.md

## BR-001 — Hierarquia dos dados
Uma propriedade pode possuir vários talhões.
Uma propriedade pode possuir vários levantamentos/contagens ao longo do tempo.
Um levantamento pertence a uma propriedade e pode envolver um ou mais talhões.
Um talhão pertence a uma propriedade e pode participar de vários levantamentos.
Uma parcela pertence ao contexto de um levantamento e deve estar vinculada a um talhão.
Uma parcela pode possuir várias árvores.
Uma árvore pertence a uma parcela.

## BR-002 — Coleta por árvore
As medições centrais previstas para cada árvore são DAP e altura, além da identificação/espécie necessária ao inventário.

## BR-003 — Unidades
As unidades exatas devem ser padronizadas e documentadas antes da implementação final dos cálculos.

Não converter silenciosamente unidades sem regra explícita.

Áreas de propriedades e talhões devem ser tratadas em hectares (`ha`).

## BR-004 — Modelos volumétricos
O sistema deve suportar inicialmente os modelos estudados no TCC:
- Spurr;
- Schumacher-Hall.

Além dos modelos inicialmente estudados, o sistema deve permitir cadastrar fórmulas volumétricas personalizadas de forma controlada.

## BR-005 — Coeficientes não são universais
Coeficientes de modelos volumétricos dependem de contexto técnico, incluindo espécie e região, podendo também depender de idade, manejo e condições do povoamento.

Nunca assumir que um coeficiente serve para todo Pinus ou todo Eucalyptus.

## BR-006 — Origem dos coeficientes
O sistema não realiza regressão estatística nem cubagem rigorosa para descobrir coeficientes.

Ele utiliza coeficientes previamente definidos com respaldo técnico/científico ou configurados pelo usuário responsável.

## BR-007 — Expansão regional
A primeira validação do projeto é voltada ao Rio Grande do Sul. A estrutura do software pode aceitar outros coeficientes/modelos no futuro, permitindo uso em outras regiões quando parâmetros adequados estiverem disponíveis.

## BR-008 — Cálculo de volume
O cálculo de volume deve usar exatamente o modelo selecionado, seus coeficientes e as medições necessárias.

As equações definitivas devem ser transcritas de fonte validada antes da implementação. Não usar fórmulas inferidas a partir de texto truncado ou extração automática do documento.

Para fórmulas personalizadas, a expressão deve ser validada antes de ser salva ou utilizada. A avaliação deve aceitar apenas variáveis e funções matemáticas permitidas pelo sistema.

## BR-009 — Método de amostragem
O método de amostragem impacta a consolidação/extrapolação dos resultados. A implementação dessa parte deve aguardar a definição técnica final do método utilizado no TCC.

## BR-010 — Estimativa econômica
O usuário informa o preço por metro cúbico da madeira.

A aplicação calcula uma **estimativa econômica bruta** a partir do volume estimado e do preço informado.

Essa estimativa não representa lucro líquido e não deve ser apresentada como tal, pois não contempla automaticamente custos de colheita, transporte, impostos, qualidade/sortimento ou outras despesas.

## BR-011 — Qualidade da entrada
O resultado depende dos dados fornecidos pelo usuário.

O sistema deve reduzir erros de digitação com validações, mas não pode garantir a correção de uma medição de campo ou de um coeficiente tecnicamente inadequado.

## BR-012 — Validações mínimas
- DAP não pode ser negativo.
- Altura não pode ser negativa.
- Preço por m³ não pode ser negativo.
- Área em hectares não pode ser negativa.
- Campos requeridos para o modelo selecionado devem estar preenchidos antes do cálculo.
- Coeficientes obrigatórios para o modelo selecionado devem estar disponíveis antes do cálculo.
- Nome de fórmula/modelo não pode ser duplicado.
- Fórmula personalizada não pode ser salva se possuir expressão inválida ou variável não reconhecida.

Se zero deve ou não ser permitido em cada campo, confirmar tecnicamente antes de bloquear.

## BR-013 — Funcionamento offline
Cadastro, edição, consulta, coleta e cálculos principais devem funcionar sem internet.

## BR-014 — Persistência
Os dados devem ser salvos localmente para que o usuário possa interromper e retomar a coleta.

## BR-015 — Edição e rastreabilidade básica
O usuário deve poder corrigir medições. Se forem adicionados registros de data/hora ou status de conclusão, eles devem servir à organização da coleta, não alterar resultados sem regra explícita.

## BR-016 — Resultado por níveis
O sistema deve ser capaz de organizar resultados seguindo a estrutura do inventário (árvore/parcela/talhão), mas a fórmula exata de agregação e extrapolação deve respeitar o método de amostragem validado.

## BR-017 — Exclusões em cascata
A política para apagar propriedade/talhão/parcela com registros filhos ainda precisa ser decidida.

Recomendação: nunca apagar dados relacionados silenciosamente. Solicitar confirmação explícita e informar o impacto.

## BR-018 — Exportação
Quando implementada, a exportação deve refletir os dados armazenados e os resultados calculados sem recalcular utilizando regras diferentes.

## BR-019 — Status dos levantamentos
Um levantamento deve possuir status para organizar a coleta.

Estados iniciais:
- `em andamento`;
- `concluído`.

O usuário pode manter mais de um levantamento em andamento ao mesmo tempo. A tela inicial deve sugerir a retomada do levantamento em andamento atualizado mais recentemente, sem impedir a criação de novo levantamento.

## BR-020 — Relação entre espécie e fórmula/modelo
Uma espécie pode possuir uma ou mais fórmulas/modelos associados.

Uma fórmula/modelo pode ser marcada como padrão para uma espécie. Ao criar um levantamento, o sistema pode sugerir a fórmula padrão da espécie selecionada, mas o usuário deve poder alterar a fórmula/modelo do levantamento quando existirem outras opções associadas.

## BR-021 — Fórmulas personalizadas
Fórmulas personalizadas devem ter nome único e expressão matemática validada.

O sistema deve identificar ou exigir os coeficientes necessários para a fórmula e impedir o cálculo quando algum coeficiente obrigatório estiver ausente.

O cadastro de uma fórmula não garante validade técnica/científica. A responsabilidade pela origem e adequação da fórmula/coeficientes é do usuário responsável ou da fonte técnica adotada no TCC.

## BR-022 — Geolocalização de parcelas
Pontos de geolocalização capturados em campo devem ser armazenados com latitude, longitude, precisão informada pelo dispositivo, ordem do ponto e data/hora de captura.

A marcação geográfica da parcela serve como documentação e apoio visual. Não deve ser apresentada como medição topográfica precisa sem validação técnica.

O contorno completo do talhão não é obrigatório no fluxo de campo. A primeira versão pode priorizar o georreferenciamento das parcelas amostrais.

## BR-023 — Exportação geográfica
Quando implementada, a exportação KML/KMZ deve refletir os pontos/polígonos armazenados, preservando a relação com propriedade, levantamento, talhão e parcela.
