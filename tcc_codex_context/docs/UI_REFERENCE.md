# UI_REFERENCE.md

> Referência visual de projeto, não inventário das telas entregues. Na revisão de 13/09/2026, os fluxos efetivamente implementados foram documentados em ENGINEERING_MODELS.md e REQUIREMENTS.md. Exemplos do protótipo abaixo não devem ser apresentados como capturas da versão final do aplicativo.

Referência visual inicial a partir do export do Stitch AI salvo em:

```text
stitch_forestly_invent_rio_florestal_offline/
```

Este material deve ser usado como norte visual, não como cópia direta. O fluxo, os textos, as entidades e a navegação oficial continuam sendo os documentos de requisitos, regras de negócio e decisões do DENDRO Mobile.

## Direção aproveitável

- Visual profissional e técnico, adequado a uso em campo.
- Paleta baseada em verde escuro, verde musgo/claro e fundo claro/off-white.
- Cartões com bordas sutis e pouca sombra.
- Botões principais em verde escuro com bom contraste.
- Campos numéricos com botões de incremento/decremento para medições em campo.
- Tipografia forte para títulos e aparência monoespaçada para números, medições e coordenadas.
- Cards de status para levantamentos, parcelas, progresso, volume e produtividade.
- Listas com altura confortável para toque em celular.
- A lateral direita do topo deve manter a logo do DENDRO Mobile. Ações de adicionar/cadastrar devem usar botão flutuante no canto inferior direito, como o `+` da tela de parcelas.
- A barra inferior deve ficar fixa em todo o app. Em telas principais, exibir ícones e nomes; em telas internas, exibir apenas ícones para reduzir a altura ocupada.
- Os nomes da barra inferior devem ser responsivos: abreviados em celular para evitar corte automático e completos em telas largas/tablets.

## O que adaptar

- Substituir nomes e rótulos em inglês por pt-BR.
- Substituir “Dashboard” por **Início** quando for a aba inicial.
- Usar a navegação oficial: **Início, Levantamentos, Propriedades, Resultados, Ajustes**.
- Não usar indicador de sincronização como elemento central no MVP, pois a primeira versão não possui backend. Quando necessário, preferir indicador de operação local/offline, por exemplo **Offline** ou **Dados locais**.
- Remover elementos de perfil/login, pois autenticação está fora do escopo atual.
- Evitar telas muito vazias ou dependentes de imagens remotas.
- Não copiar fórmulas, coeficientes ou números de exemplo do Stitch como dados reais do TCC.

## Telas de referência do export

- `abertura_dendro_mobile/screen.png`: referência para abertura/splash com imagem de floresta, mas deve ser adaptada para imagem em tela inteira.
- `dashboard/screen.png`: referência de cabeçalho, barra inferior e estilo geral, mas precisa ser adaptada para a aba Início do DENDRO.
- `coleta_de_rvores/screen.png`: boa referência para entrada rápida de DAP e altura com botões `-` e `+`, adaptada para painel deslizante sobre a lista de árvores da parcela.
- `parcelas_do_talh_o/screen.png`: boa referência para lista de parcelas com status coletada, em andamento e pendente.
- `modelos_matem_ticos/screen.png`: referência útil para tela de fórmulas/modelos e coeficientes, adaptando o ícone de informação para menu de três pontos.
- `resultados_do_invent_rio/screen.png`: referência útil para resultados, volume estimado, produtividade, distribuição diamétrica, filtros e estimativa econômica bruta.
- `exporta_o_de_dados/screen.png`: referência para exportação, incluindo PDF/CSV/planilha e adaptação para KML/KMZ.

## Componentes candidatos para Flutter

- `DendroScaffold`: estrutura com app bar e barra inferior.
- `DendroBottomNavigation`: abas oficiais do DENDRO.
- `StatusChip`: chips como `Em andamento`, `Concluído`, `Offline`, `Dados locais`.
- `MetricCard`: cartão para volume, produtividade, árvores medidas, área em ha.
- `PrimaryActionCard`: card principal para continuar levantamento em aberto.
- `MeasurementStepperField`: campo numérico com botões de menos/mais.
- `InventoryListItem`: item de lista para levantamentos, propriedades, talhões e parcelas.
- `FormulaCard`: cartão para fórmula/modelo, expressão e coeficientes.

## Splash / tela de carregamento

A tela inicial de carregamento deve usar uma imagem de floresta ocupando todo o fundo da tela, sem bloco sólido verde ocupando parte inferior.

Direção desejada:

- imagem de floresta em tela cheia;
- escurecimento/overlay sutil para garantir contraste;
- logo oficial centralizada;
- texto **DENDRO Mobile** abaixo ou ao lado conforme composição;
- subtítulo **Sistema para Inventário Florestal**;
- retângulo/faixa horizontal verde escuro semi-transparente atrás da logo e dos textos, para dar destaque;
- não usar a imagem como card pequeno dentro de outro fundo.

O print enviado pelo usuário em 2026-08-09 mostra a intenção geral, mas a parte inferior verde deve ser removida. A floresta precisa preencher todo o fundo.

## Tela Início / Dashboard operacional

A tela Início deve priorizar ações na seguinte hierarquia visual:

1. **Novo Levantamento +** como ação principal.
2. Card de levantamento em andamento, quando existir.
3. Resumos e atividades recentes.

Direção desejada:

- O botão **Novo Levantamento +** deve ficar acima do card de levantamento em andamento.
- O botão deve ser retangular horizontal, ocupar praticamente toda a largura útil da tela e ter altura confortável, sem ficar exageradamente alto.
- O botão principal deve usar verde forte/primário para chamar mais atenção.
- O card de levantamento em andamento deve aparecer logo abaixo, usando verde mais fraco ou superfície esverdeada, sem ser branco puro.
- O card de levantamento em andamento deve permitir continuar a coleta, mostrando propriedade/talhão, total de árvores medidas, área medida e data/última atualização quando disponível.
- O card de levantamento em andamento não precisa exibir porcentagem de progresso como informação principal, pois esse valor pode ser artificial enquanto o método/plano de amostragem não estiver fechado.
- O restante da tela pode exibir informações secundárias, como total de árvores medidas, área medida, último levantamento concluído e atividade recente.
- A seção **Atividade recente** deve mostrar um resumo das últimas ações feitas no app, limitada inicialmente às 4 atividades mais recentes.
- Exemplos de atividades recentes: parcela coletada, nova parcela iniciada, exportação realizada, novo cadastro de propriedade, levantamento concluído, fórmula/modelo alterado.
- Essa seção serve para o usuário confirmar rapidamente o que acabou de fazer, não como auditoria completa.

O objetivo é deixar clara a prioridade:

```text
Novo levantamento = foco principal
Continuar coleta de um levantamento em andamento = foco secundário
Resumo/atividade = informação de apoio
```

Se não houver levantamento em andamento, o botão de novo levantamento continua como CTA principal e o espaço secundário pode mostrar o último levantamento concluído ou uma mensagem curta orientando o início da primeira coleta.

## Tela de parcelas do talhão

A tela de parcelas deve representar as parcelas existentes dentro de um talhão no contexto de um levantamento.

Informações de topo desejadas:

- espécie principal do talhão/levantamento;
- área total do talhão em hectares;
- data de início do levantamento;
- total de parcelas cadastradas;
- fração de parcelas coletadas, por exemplo `5/10`.

Comportamento esperado:

- permitir cadastrar nova parcela com botão `+`;
- permitir cadastrar todas as parcelas antes de iniciar a coleta;
- parcelas ainda não medidas devem aparecer como `pendente`;
- parcelas com coleta iniciada e não finalizada devem aparecer como `em andamento`;
- parcelas já medidas devem aparecer como `coletada`;
- ao tocar em uma parcela, abrir a tela de coleta/edição daquela parcela;
- para parcelas coletadas, exibir total de árvores medidas e coordenadas/geolocalização resumida quando existir;
- a fração de parcelas coletadas deve atualizar conforme parcelas forem gravadas/finalizadas.
- área/tamanho da parcela é opcional.

O print de referência mostra porcentagem de progresso, mas para o DENDRO a informação principal deve ser a fração de parcelas coletadas, por ser mais concreta e fácil de entender.

## Tela da parcela / coleta de árvores

A tela da parcela deve ter como base a lista de árvores já medidas na parcela.

Estrutura desejada:

- topo com identificação da parcela, resumo de quantidade de árvores e ação para encerrar/finalizar parcela;
- botão **Nova árvore** no topo da área de conteúdo;
- lista de árvores já medidas, exibindo número/identificação da árvore, DAP e altura;
- cada árvore listada deve permitir editar e excluir;
- árvores com coordenada capturada podem exibir pequeno indicador de localização.

Cadastro/edição de árvore:

- ao tocar em **Nova árvore**, abrir um painel/janela deslizante sobreposta;
- o painel deve ocupar cerca de meia tela, mantendo a lista visível parcialmente abaixo quando possível;
- a identificação deve ser gerada automaticamente como `Árvore 1`, `Árvore 2`, `Árvore 3` etc.;
- ao lado da identificação da árvore, deve haver botão/ícone para capturar coordenada;
- ao capturar coordenada, o usuário pode marcar explicitamente se essa coordenada também representa um ponto da parcela, por exemplo `P1`, `P2`, `P3` ou `P4`;
- pontos da parcela já gravados devem aparecer com cor/estado visual diferente dos pontos ainda não registrados;
- o ponto selecionado no momento deve ter destaque próprio, para o usuário saber qual ponto está registrando agora;
- se o usuário selecionar um ponto da parcela já gravado, o app deve solicitar confirmação para substituir;
- o painel deve conter os campos de medição, como DAP, altura e opções adicionais;
- campos numéricos devem usar botões `-` e `+` para facilitar uso em campo;
- o painel deve ter dois botões logo abaixo das medidas: **Salvar** e **Próxima**.

Comportamento dos botões:

- **Salvar** grava os dados e recolhe o painel, retornando à lista;
- **Próxima** grava os dados, atualiza a lista e mantém/abre o painel limpo para registrar outra árvore;
- ao editar uma árvore existente, o painel deve abrir preenchido com os dados salvos anteriormente;
- ao editar uma árvore com coordenada salva, o painel deve indicar que existe coordenada capturada e permitir atualizar a captura;
- excluir árvore deve ficar disponível na lista e pedir confirmação quando apropriado.

Status da parcela:

- finalizar/encerrar a parcela muda seu status para `coletada`;
- apenas voltar da tela não finaliza a parcela;
- se houver dados salvos e o usuário voltar sem finalizar, a parcela permanece `em andamento`.

A experiência desejada é de coleta rápida e contínua: o usuário registra árvore, toca em **Próxima** e continua a sequência sem perder o contexto da lista.

## Tela Resultados

A tela Resultados é uma aba da navegação inferior e funciona como dashboard analítico filtrável.

Entrada e navegação:

- pode ser aberta diretamente pela aba **Resultados**;
- pode ser aberta a partir do cadastro/detalhe de uma propriedade por botão/ícone de gráfico, já com a propriedade selecionada;
- pode ser aberta a partir do cadastro/detalhe de um talhão por botão/ícone de gráfico, já com propriedade e talhão selecionados.

Filtros:

- seleção de propriedade;
- seleção opcional de um ou mais talhões;
- seleção opcional de espécie;
- filtros futuros podem incluir período, status do levantamento ou modelo/fórmula.

Regras de interação:

- filtros de talhão e espécie são opcionais e independentes;
- alterar filtros deve atualizar os cards, gráficos e estimativas exibidas;
- se nenhuma espécie for selecionada, considerar todas as espécies da propriedade/talhões filtrados;
- se nenhum talhão for selecionado, considerar todos os talhões compatíveis com a propriedade e demais filtros;
- filtros ativos devem ficar visíveis para o usuário, com opção clara de limpar/remover.

Informações visuais esperadas:

- volume estimado total;
- produtividade, quando regra técnica estiver definida;
- árvores amostradas;
- DAP médio;
- altura média;
- distribuição diamétrica;
- estimativa econômica bruta com preço por m³ informado;
- ações de exportação/relatório quando disponíveis.

O print de referência serve para a composição dos cards e gráficos, mas o topo precisa incluir seleção/filtros de propriedade, talhões e espécie conforme o fluxo do DENDRO.

## Resultados inspirados em inventário de referência

O inventário fornecido pelo engenheiro responsável foi salvo como referência em:

```text
tcc_codex_context/assets/references/inventario_referencia_engenheiro_outubro_2025.png
```

Ele deve ser considerado referência para telas de resultado e principalmente para exportações/relatórios futuros.

O inventário usa indicadores tabulares como:

- área em hectares;
- ano de plantio/idade;
- número de árvores por hectare;
- DAP médio;
- altura média;
- área basal (`G`, m²/ha);
- volume médio por árvore (`m³/árv.`);
- volume por hectare (`m³/ha`);
- IMA em centímetros por ano (`cm/ano`);
- IMA em volume por hectare por ano (`m³/ha/ano`);
- volume total estimado (`m³`).

Para o app, esses dados não devem aparecer como planilha estática. A tela Resultados pode transformar esses indicadores em cards e gráficos:

- card de volume total estimado;
- card de volume por hectare;
- card de área basal;
- card de árvores por hectare;
- card de DAP médio e altura média;
- gráfico de barras de volume total por talhão/projeto;
- gráfico de barras de volume por hectare por talhão;
- gráfico de distribuição diamétrica por classes de DAP;
- gráfico de área analisada por espécie/talhão;
- gráfico de comparação entre espécies quando houver mais de uma na propriedade;
- tabela/resumo compacto por talhão para exportação ou consulta detalhada.

Indicadores dependentes de extrapolação, IMA, área basal ou produtividade devem ficar condicionados à validação técnica das fórmulas, unidades e método de amostragem.

## Tela Fórmulas / Modelos matemáticos

A tela de fórmulas/modelos fica dentro de **Ajustes**.

Conteúdo inicial:

- Spurr;
- Schumacher-Hall;
- fórmulas personalizadas cadastradas pelo usuário.

Estrutura visual:

- lista em blocos/cards;
- cada card mostra o nome da fórmula/modelo;
- abaixo do nome, mostrar a expressão matemática;
- na mesma linha do nome, usar ícone de três pontos para menu de ações;
- o menu de três pontos deve oferecer pelo menos **Editar** e **Excluir**.

Comportamento expansível:

- tocar no card abre uma área expansível/recolhida;
- a área expandida mostra coeficientes/variáveis configuráveis;
- tocar novamente no card recolhe a área se não houver alterações pendentes;
- se houver alteração sem salvar, perguntar se deseja salvar ou descartar antes de recolher/sair;
- botão **Salvar alterações** deve ficar dentro da área expandida.

Entrada de coeficientes:

- campos numéricos podem usar botões `-` e `+` como no print;
- nomes dos coeficientes devem ficar visíveis;
- expressão e coeficientes precisam ser claros para revisão técnica.

Cuidados:

- não tratar os coeficientes pré-preenchidos do print como valores reais do TCC;
- fórmulas personalizadas precisam passar por validação de expressão;
- exclusão de fórmula/modelo associado a espécie ou levantamento deve pedir confirmação e informar impacto.

## Tela Exportar Dados

A tela de exportação deve poder ser aberta a partir de:

- cadastro/detalhe da propriedade;
- tela Resultados;
- detalhe de levantamento.

Quando aberta a partir de uma propriedade, todos os talhões/áreas da propriedade devem vir selecionados por padrão.

Quando aberta a partir de um levantamento, os talhões/áreas vinculados ao levantamento devem vir selecionados por padrão.

Opções de formato:

- **Relatório PDF**;
- **Dados brutos (CSV)**;
- **Planilha (XLS/XLSX)**;
- **Google Earth (KML/KMZ)** para coordenadas, pontos e polígonos.

Seleção de dados:

- lista de talhões/áreas com checkbox;
- opção **Selecionar todos**;
- usuário pode desmarcar talhões que não deseja exportar;
- cada item pode mostrar nome do talhão, espécie, quantidade de parcelas e área em ha quando disponível.

Comportamento:

- a exportação deve respeitar somente os talhões/áreas selecionados;
- o botão principal deve indicar ação clara, como **Gerar relatório**, **Exportar arquivo** ou **Compartilhar relatório**, conforme o formato escolhido;
- para KML/KMZ, exportar apenas itens com dados geográficos disponíveis e informar quando não houver coordenadas.

## Direção visual inicial do DENDRO

Usar como base:

- verde principal escuro: próximo de `#012D1D`;
- verde de superfície/realce: próximo de `#1B4332`;
- verde claro de destaque: próximo de `#A5D0B9`;
- fundo claro/off-white: próximo de `#F9F9F8`;
- texto principal escuro: próximo de `#191C1C`;
- bordas sutis: próximo de `#C1C8C2`.

Esses valores podem ser refinados durante a implementação para combinar melhor com a logo oficial do DENDRO Mobile.

## Prioridade de uso

Para iniciar o app, aproveitar principalmente:

1. barra inferior com ícones e rótulos, adaptada para as cinco abas oficiais;
2. tela Início com card de continuar levantamento e cards de resumo;
3. tela de coleta de árvore com campos DAP/altura usando stepper;
4. tela de parcelas com status visual;
5. tela de resultados com cards e estimativa econômica.
