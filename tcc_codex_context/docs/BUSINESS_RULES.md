# BUSINESS_RULES.md

## BR-001 — Hierarquia dos dados
Uma propriedade pode possuir vários talhões.
Uma propriedade pode possuir vários levantamentos/contagens ao longo do tempo.
Um levantamento pertence a uma propriedade e pode envolver um ou mais talhões.
Um talhão pertence a uma propriedade e pode participar de vários levantamentos.
Cada talhão incluído em um levantamento deve ser representado pela entidade intermediária `talhaolevantamento`.
Uma parcela pertence ao contexto de um `talhaolevantamento`.
Uma parcela pode possuir várias árvores.
Uma árvore pertence a uma parcela.

## BR-002 — Coleta por árvore
As medições centrais previstas para cada árvore são DAP e altura, além da identificação/espécie necessária ao inventário.

## BR-003 — Unidades
As unidades exatas devem ser padronizadas e documentadas antes da implementação final dos cálculos.

Não converter silenciosamente unidades sem regra explícita.

Áreas de propriedades e talhões devem ser tratadas em hectares (`ha`).

Unidades oficiais iniciais:
- DAP em centímetros (`cm`);
- altura em metros (`m`);
- volume em metros cúbicos (`m³`);
- área em hectares (`ha`).

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

As variáveis usadas em uma fórmula devem ser declaradas no cadastro da própria fórmula. Cada símbolo/letra usado na expressão precisa estar associado a uma variável reconhecida, inicialmente DAP, altura, idade ou área basal. O sistema só deve executar o cálculo quando conseguir obter todos os valores exigidos pela expressão.

## BR-009 — Método de amostragem
O método de amostragem definido para o projeto é amostragem sistemática com parcelas de área fixa, preferencialmente retangulares.

Esse método impacta a consolidação/extrapolação dos resultados. A implementação operacional deve considerar a área amostrada, a área do talhão e as fórmulas validadas para volume/produtividade.

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
- Fórmula personalizada não pode ser utilizada se algum símbolo/letra da expressão não estiver vinculado a uma variável conhecida pelo sistema.

Se zero deve ou não ser permitido em cada campo, confirmar tecnicamente antes de bloquear.

## BR-013 — Funcionamento offline
Cadastro, edição, consulta, coleta e cálculos principais devem funcionar sem internet.

## BR-014 — Persistência
Os dados devem ser salvos localmente para que o usuário possa interromper e retomar a coleta.

## BR-015 — Edição e rastreabilidade básica
O usuário deve poder corrigir medições. Se forem adicionados registros de data/hora ou status de conclusão, eles devem servir à organização da coleta, não alterar resultados sem regra explícita.

## BR-016 — Resultado por níveis
O sistema deve ser capaz de organizar resultados seguindo a estrutura do inventário (árvore/parcela/talhão), mas a fórmula exata de agregação e extrapolação deve respeitar o método de amostragem validado.

Indicadores como árvores por hectare, área basal (`G`), volume por hectare, IMA e volume total extrapolado dependem de fórmulas, unidades e método de amostragem validados. Não apresentar esses valores como resultado técnico final sem as regras correspondentes documentadas.

Para parcelas de área fixa, a lógica básica de extrapolação é calcular o volume por unidade de área amostrada e extrapolar para hectare/talhão. A implementação deve exigir área da parcela ou área amostrada padrão disponível; sem área amostrada, não calcular `m³/ha` ou volume extrapolado do talhão.

## BR-017 — Exclusões em cascata
O sistema pode permitir exclusão de registros que possuam dados filhos, como talhão com parcelas ou propriedade com talhões/levantamentos.

Nunca apagar dados relacionados silenciosamente. Solicitar confirmação explícita e informar o impacto.

Exemplo de mensagem: `O talhão já contém parcelas com dados armazenados. Se confirmar, todos os dados salvos relacionados serão apagados. Deseja continuar?`

## BR-018 — Exportação
Quando implementada, a exportação deve refletir os dados armazenados e os resultados calculados sem recalcular utilizando regras diferentes.

Ao exportar dados de uma propriedade, todos os talhões devem vir selecionados por padrão. O usuário pode desmarcar talhões/áreas para limitar o escopo da exportação.

A exportação deve respeitar o escopo selecionado pelo usuário e informar de forma clara quais talhões/áreas foram incluídos.

Formatos desejados incluem PDF, CSV, XLS/XLSX e KML/KMZ.

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

O sistema deve permitir que o usuário cadastre os símbolos/letras usados na expressão e associe cada um deles a uma variável suportada. A primeira versão deve suportar DAP, altura, idade e área basal como referências de variável. Novas referências podem ser adicionadas futuramente se forem necessárias para outros modelos.

O cadastro de uma fórmula não garante validade técnica/científica. A responsabilidade pela origem e adequação da fórmula/coeficientes é do usuário responsável ou da fonte técnica adotada no TCC.

Alterações em coeficientes, variáveis ou expressão de uma fórmula/modelo não devem ser descartadas silenciosamente. Se o usuário tentar recolher o card, sair da tela ou abrir outra edição sem salvar, o sistema deve solicitar confirmação para salvar ou descartar.

Excluir fórmula/modelo deve exigir confirmação, especialmente se ela estiver associada a espécies ou levantamentos.

## BR-022 — Geolocalização de parcelas
Pontos de geolocalização capturados em campo devem ser armazenados com latitude, longitude, precisão informada pelo dispositivo, ordem do ponto e data/hora de captura.

A marcação geográfica da parcela serve como documentação e apoio visual. Não deve ser apresentada como medição topográfica precisa sem validação técnica.

O contorno completo do talhão não é obrigatório no fluxo de campo. A primeira versão pode priorizar o georreferenciamento das parcelas amostrais.

## BR-023 — Exportação geográfica
Quando implementada, a exportação KML/KMZ deve refletir os pontos/polígonos armazenados, preservando a relação com propriedade, levantamento, talhão e parcela.

## BR-024 — Filtros de resultados
A tela de resultados deve calcular e apresentar indicadores a partir dos dados filtrados.

Filtros iniciais previstos:
- propriedade;
- talhão ou múltiplos talhões;
- espécie.

Os filtros são opcionais e independentes, exceto quando um filtro depender naturalmente da seleção de propriedade para listar opções relacionadas.

Aplicar filtros não deve alterar dados armazenados; apenas muda o recorte dos resultados exibidos.

Atalhos a partir da tela de propriedade ou talhão podem abrir a aba Resultados com filtros já preenchidos.

## BR-025 — Status das parcelas
Parcelas podem ser cadastradas antes da medição de campo.

Estados iniciais:
- `pendente`: parcela cadastrada, mas ainda sem contagem registrada;
- `em andamento`: parcela com coleta iniciada, mas ainda não finalizada;
- `coletada`: parcela com coleta finalizada.

A interface deve permitir acompanhar o total de parcelas coletadas em relação ao total cadastrado, por exemplo `5/10`.

Uma parcela coletada deve poder exibir total de árvores medidas e resumo de coordenadas/geolocalização quando esses dados estiverem disponíveis.

Ao registrar a primeira árvore ou iniciar edição/coleta em uma parcela pendente, a parcela pode passar para `em andamento`.

Salvar árvores não encerra automaticamente a parcela. A parcela só deve mudar para `coletada` quando o usuário acionar explicitamente a opção de encerrar/finalizar parcela.

Se o usuário sair da tela da parcela sem encerrar, os dados já registrados devem permanecer salvos e a parcela deve continuar `em andamento`.

## BR-026 — Registro sequencial de árvores
O cadastro de árvores deve permitir registro sequencial em campo.

A identificação padrão deve ser gerada automaticamente a partir do número sequencial da árvore dentro da parcela, por exemplo `Árvore 1`, `Árvore 2`, `Árvore 3`.

Árvores já registradas não devem ser renumeradas automaticamente após edição ou exclusão, para preservar rastreabilidade básica da coleta.

A ação **Salvar** grava a árvore atual e retorna/recolhe o formulário.

A ação **Próxima** grava a árvore atual, atualiza a lista de árvores e prepara o formulário para registrar a próxima árvore da mesma parcela.

Editar uma árvore existente deve carregar os dados salvos anteriormente. Excluir uma árvore deve solicitar confirmação quando houver risco de perda de dados.

## BR-027 — Coordenada opcional por árvore
Durante o cadastro/edição de uma árvore, o usuário pode capturar a coordenada atual do dispositivo para associá-la à árvore.

A coordenada da árvore deve armazenar latitude, longitude, precisão informada pelo dispositivo e data/hora da captura.

Essa coordenada é opcional e serve como apoio documental/geográfico, especialmente quando a árvore medida estiver localizada em uma quina ou ponto de referência da parcela.

Capturar coordenada de uma árvore não substitui automaticamente os pontos ordenados da parcela, a menos que uma regra futura defina essa associação. A exportação geográfica pode incluir árvores com coordenadas capturadas.

Quando a coordenada de uma árvore for usada como ponto da parcela, o usuário deve escolher explicitamente qual ponto está registrando, por exemplo `P1`, `P2`, `P3` ou `P4`.

Pontos da parcela já registrados devem ser visualmente diferenciados dos pontos pendentes. O ponto selecionado para captura deve ter destaque para reduzir erro de campo.

Se o usuário tentar gravar novamente um ponto da parcela já registrado, o sistema deve solicitar confirmação antes de substituir.
