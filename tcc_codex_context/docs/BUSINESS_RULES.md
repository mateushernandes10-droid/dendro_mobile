# BUSINESS_RULES.md

## BR-001 — Hierarquia dos dados
Uma propriedade pode possuir vários talhões.
Um talhão pertence a uma propriedade e pode possuir várias parcelas.
Uma parcela pertence a um talhão e pode possuir várias árvores.
Uma árvore pertence a uma parcela.

## BR-002 — Coleta por árvore
As medições centrais previstas para cada árvore são DAP e altura, além da identificação/espécie necessária ao inventário.

## BR-003 — Unidades
As unidades exatas devem ser padronizadas e documentadas antes da implementação final dos cálculos.

Não converter silenciosamente unidades sem regra explícita.

## BR-004 — Modelos volumétricos
O sistema deve suportar inicialmente os modelos estudados no TCC:
- Spurr;
- Schumacher-Hall.

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
- Campos requeridos para o modelo selecionado devem estar preenchidos antes do cálculo.
- Coeficientes obrigatórios para o modelo selecionado devem estar disponíveis antes do cálculo.

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
