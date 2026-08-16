# DECISIONS.md

Registro de decisões arquiteturais e de escopo. Atualizar este arquivo quando uma escolha relevante for consolidada.

## D-001 — Aplicação mobile
**Status:** decidido

A primeira versão será uma aplicação mobile.

## D-002 — Flutter + Dart
**Status:** decidido

Dart será a linguagem de programação e Flutter o framework de desenvolvimento mobile.

## D-003 — SQLite
**Status:** decidido

SQLite será utilizado para persistência local.

**Motivo:** o sistema será utilizado em campo, onde pode não existir conexão com a internet.

## D-004 — Sem servidor na primeira versão
**Status:** decidido

O aplicativo será autônomo. Coleta, armazenamento, processamento e resultados serão executados localmente.

Sincronização remota fica como evolução futura.

## D-005 — Hierarquia principal
**Status:** decidido

Cadastro permanente:

`Propriedade -> Talhão`

Coleta:

`Propriedade -> Levantamento/Contagem -> talhaolevantamento -> Parcela -> Árvore`

Essa hierarquia deve orientar navegação e modelagem do banco. A entidade Levantamento/Contagem separa o cadastro permanente da propriedade dos dados medidos em uma coleta específica.

`talhaolevantamento` é a entidade intermediária oficial que representa um talhão dentro de um levantamento específico. Ela permite que o mesmo talhão seja recontado em datas diferentes, mantendo histórico nos levantamentos e exibindo no cadastro do talhão a última informação coletada.

## D-006 — Escopo florestal inicial
**Status:** decidido

Foco em florestas plantadas de Pinus e Eucalyptus e validação no Rio Grande do Sul.

## D-007 — Modelos volumétricos
**Status:** decidido no referencial / implementação a validar

Modelos considerados inicialmente:
- Spurr;
- Schumacher-Hall.

As fórmulas e coeficientes exatos usados no software precisam ser confirmados a partir das fontes técnicas antes de codificar.

Além desses modelos, o sistema deverá permitir fórmulas personalizadas cadastradas pelo usuário, desde que sejam avaliadas por mecanismo seguro de expressão matemática e não por execução de código arbitrário.

## D-008 — Coeficientes configuráveis
**Status:** decidido para o desenho inicial

A aplicação deve evitar coeficientes rígidos/universais e ser estruturada para permitir configuração de parâmetros por espécie/região/modelo.

Isso possibilita expansão futura para outras localidades, desde que existam coeficientes tecnicamente adequados.

Os coeficientes iniciais serão preenchidos posteriormente com base em trabalhos relacionados voltados a florestas plantadas de Pinus e Eucalyptus no Rio Grande do Sul.

## D-009 — Sistema não calcula coeficientes
**Status:** decidido

Não faz parte do projeto ajustar estatisticamente novos coeficientes. Eles devem vir de estudos técnicos ou ser informados/configurados por usuário qualificado.

## D-010 — Estimativa econômica
**Status:** decidido

O usuário informa o preço do metro cúbico. O sistema apresenta uma estimativa **bruta** do valor da madeira, e não lucro líquido.

## D-011 — Exportação
**Status:** desejada

Existe interesse em exportar dados e resultados. Implementar após o fluxo central de cadastro/coleta/cálculo, salvo mudança de prioridade.

A tela de exportação deve poder ser aberta a partir da propriedade, da tela Resultados e do detalhe de um levantamento.

Formatos desejados:
- PDF;
- CSV;
- XLS/XLSX;
- KML/KMZ.

Ao abrir a partir de uma propriedade, todos os talhões devem vir selecionados por padrão, permitindo desmarcar os que ficarão fora da exportação.

Ao abrir a partir de um levantamento, os talhões/áreas do levantamento devem vir selecionados por padrão.

## D-012 — IDEs e ferramentas
**Status:** decidido

- Visual Studio Code: desenvolvimento principal.
- Android Studio: SDK/emulador/configuração Android.
- Git: controle de versão.
- GitHub: hospedagem do repositório.

## D-013 — Gerenciamento de estado Flutter
**Status:** decidido

Usar **Riverpod** para gerenciamento de estado.

Critério: organização, testabilidade, bom suporte a dados locais e complexidade adequada ao tamanho do TCC.

## D-014 — ORM/camada SQLite
**Status:** decidido

Usar **Drift** como camada sobre SQLite.

Motivo: o projeto terá várias tabelas relacionadas, consultas filtradas, migrações e necessidade de reduzir erros de SQL/mapeamento manual.

## D-015 — Múltiplos levantamentos no tempo
**Status:** decidido

Uma mesma propriedade poderá possuir vários levantamentos/contagens realizados em datas diferentes.

Criar entidade `InventoryRun`/`Levantamento` separando a estrutura física da propriedade dos dados de cada coleta. Um levantamento deve possuir status e datas de início/atualização/conclusão.

Um levantamento pode envolver mais de um talhão, pois representa o serviço/coleta realizado em determinado dia ou período.

A associação entre levantamento e talhão deve ser modelada pela entidade `talhaolevantamento`.

## D-016 — Método de amostragem
**Status:** decidido conceitualmente / implementação a validar

O método definido é **amostragem sistemática com parcelas de área fixa**, preferencialmente retangulares.

A regra operacional de extrapolação deve usar a lógica de volume médio por unidade de área amostrada e extrapolação para hectare/talhão. A implementação final deve ser validada tecnicamente antes de apresentar produtividade como resultado oficial.

## D-017 — Autenticação
**Status:** fora do escopo atual

Não há requisito atual de login/conta online.

## D-018 — Plataforma alvo inicial
**Status:** parcialmente definido

Flutter permite multiplataforma, mas a primeira execução/teste será orientada ao ambiente mobile Android. Confirmar necessidade de iOS antes de assumir suporte de produção.

## D-019 — Navegação principal
**Status:** decidido para o desenho inicial

A interface principal deve usar barra inferior com cinco abas:
- Início;
- Levantamentos;
- Propriedades;
- Resultados;
- Ajustes.

## D-020 — Tela inicial operacional
**Status:** decidido para o desenho inicial

A tela Início deve funcionar como painel de retomada rápida, permitindo criar novo levantamento, continuar o levantamento em andamento mais recente e visualizar resumo do último levantamento concluído.

## D-021 — Status dos levantamentos
**Status:** decidido para o MVP

Estados iniciais:
- `em andamento`;
- `concluído`.

O usuário pode manter mais de um levantamento em andamento ao mesmo tempo.

## D-022 — Área em hectares
**Status:** decidido

Áreas de propriedades e talhões devem ser armazenadas/exibidas em hectares (`ha`).

## D-023 — Tela de propriedades
**Status:** decidido para o desenho inicial

A listagem de propriedades deve exibir nome, município/UF, área total em hectares e quantidade de talhões. Deve permitir busca por nome e filtros por município, faixa de área e faixa de quantidade de talhões.

Tocar na propriedade abre seus detalhes. Editar e excluir ficam em menu de ações, por exemplo ícone de três pontos.

## D-024 — Espécies/categorias iniciais
**Status:** decidido para o cadastro base

O sistema deve iniciar com Pinus e Eucalyptus/Eucalipto como cadastros base. Se o TCC exigir espécies botânicas específicas, isso será refinado antes da implementação final.

## D-025 — Fórmulas personalizadas
**Status:** decidido como requisito do produto

O usuário deve poder cadastrar fórmulas novas, não apenas selecionar Spurr e Schumacher-Hall.

Cada fórmula deve possuir nome único, expressão validada e coeficientes/variáveis necessários. A avaliação matemática será feita inicialmente com `math_expressions`.

As variáveis reconhecidas inicialmente pelo motor de fórmulas devem cobrir quatro referências: DAP, altura, idade e área basal. No cadastro da fórmula, cada variável deve possuir um símbolo/letra usado na expressão e um vínculo com seu significado, unidade e origem do valor.

A tela de fórmulas/modelos deve usar cards recolhíveis/expansíveis. O card fechado mostra nome e expressão; o card expandido mostra coeficientes/variáveis e botão para salvar alterações. O menu de três pontos deve oferecer ações como editar e excluir.

## D-026 — Geolocalização de parcelas
**Status:** desejada para o fluxo de levantamento

Durante a criação/coleta de uma parcela, o usuário poderá capturar pontos de localização com o dispositivo, por exemplo os quatro cantos da parcela. Esses pontos servem para documentação e apoio visual, não como medição topográfica precisa sem validação técnica.

## D-027 — Exportação para Google Earth
**Status:** desejada

O sistema deve ser preparado para exportar pontos/polígonos de parcelas em KML/KMZ, permitindo abertura no Google Earth e uso na documentação do inventário.

## D-027.1 — Relatório de inventário de referência
**Status:** referência adotada

O inventário fornecido pelo engenheiro responsável foi salvo como referência para exportação futura em:

```text
tcc_codex_context/assets/references/inventario_referencia_engenheiro_outubro_2025.png
```

Relatórios exportados pelo DENDRO Mobile devem buscar estrutura semelhante quando as regras técnicas estiverem validadas, incluindo agrupamentos, subtotais, totais e indicadores dendrométricos.

## D-028 — Resultados como dashboard
**Status:** decidido para o desenho inicial

A aba Resultados deve funcionar como dashboard analítico filtrável, inicialmente orientado à seleção de uma propriedade para visualizar levantamentos e resultados consolidados.

Filtros iniciais:
- propriedade;
- um ou mais talhões;
- espécie.

Os filtros são opcionais e independentes. A tela também pode ser aberta a partir de uma propriedade ou talhão, já com os filtros correspondentes preenchidos.

Resultados detalhados também devem estar disponíveis dentro de cada levantamento.

## D-029 — Nome e identidade do aplicativo
**Status:** decidido

Nome oficial: **DENDRO Mobile**.

Nome completo/subtítulo: **DENDRO Mobile - Sistema para Inventário Florestal**.

Logo-base salva em:

```text
tcc_codex_context/assets/branding/dendro_mobile_logo.png
```

A identidade visual deve partir da logo fornecida, com predominância de verde escuro e verde claro.

## D-030 — Parcelas pré-cadastradas e status
**Status:** decidido para o desenho inicial

O usuário poderá cadastrar parcelas antes de realizar a medição de campo. Parcelas sem medição devem aparecer como `pendente`.

Estados iniciais de parcela:
- `pendente`;
- `em andamento`;
- `coletada`.

A tela de parcelas deve exibir o total de parcelas cadastradas e a fração de parcelas coletadas, por exemplo `5/10`.

A área/tamanho da parcela é opcional.

## D-031 — Coleta de árvores por painel deslizante
**Status:** decidido para o desenho inicial

A tela da parcela deve exibir a lista de árvores já medidas. O cadastro e edição de árvore devem ocorrer por painel/janela deslizante sobreposta, aberto a partir do botão **Nova árvore** ou da ação de editar.

O painel deve possuir as ações:
- **Salvar**: grava e recolhe o painel;
- **Próxima**: grava, atualiza a lista e prepara o cadastro da próxima árvore.

Finalizar a parcela deve ser uma ação explícita separada. Voltar da tela mantém dados salvos, mas deixa a parcela `em andamento` quando ela ainda não foi encerrada.

## D-032 — Numeração e coordenada das árvores
**Status:** decidido para o desenho inicial

Árvores devem receber identificação sequencial automática dentro da parcela, por exemplo `Árvore 1`, `Árvore 2`, `Árvore 3`.

O cadastro/edição de árvore deve permitir capturar coordenada opcional do dispositivo ao lado da identificação da árvore. Essa coordenada pode apoiar a documentação geográfica, especialmente em árvores localizadas em quinas ou pontos de referência da parcela.

Árvores já registradas não devem ser renumeradas automaticamente após exclusões ou edições.

## D-033 — Unidades oficiais iniciais
**Status:** decidido

Unidades iniciais:
- DAP em centímetros (`cm`);
- altura em metros (`m`);
- volume em metros cúbicos (`m³`);
- área em hectares (`ha`).

## D-034 — Exclusão com dados filhos
**Status:** decidido para o desenho inicial

O sistema pode permitir excluir registros com dados filhos, mas deve solicitar confirmação explícita e informar o impacto antes de apagar os dados relacionados.

Exemplo: ao excluir um talhão com parcelas, avisar que as parcelas e dados armazenados também serão apagados se o usuário confirmar.

## D-035 — Campos do talhão
**Status:** decidido para o desenho inicial

O talhão é cadastrado dentro de uma propriedade, portanto não deve repetir município ou vínculo manual com propriedade no formulário.

Campos:
- identificação;
- espécie;
- área em ha;
- ano do plantio, opcional;
- espaçamento, opcional;
- regime de manejo, opcional;
- observação, opcional.

## D-036 — Campos da parcela
**Status:** decidido para o desenho inicial

Parcelas são criadas dentro de um talhão.

Campos:
- identificação sequencial automática, por exemplo `P01`, `P02`;
- talhão vinculado;
- status;
- área/tamanho opcional;
- pontos GPS opcionais;
- posição de referência opcional (`P1`, `P2`, `P3` ou `P4`) quando definida na captura de coordenada.

## D-037 — Biblioteca de fórmulas personalizadas
**Status:** decidido para o desenho inicial

Usar **math_expressions** para interpretar e avaliar fórmulas matemáticas personalizadas de forma controlada.

A implementação deve validar a expressão contra um catálogo de variáveis permitidas. Cada variável usada na fórmula precisa estar cadastrada, possuir símbolo/letra reconhecível e estar vinculada a uma origem de valor, como DAP medido, altura medida, idade derivada do ano de plantio ou área basal calculada.

Também deve tratar erros de expressão inválida, variável ausente, divisão por zero e resultado não numérico.

## D-038 — Bibliotecas principais previstas
**Status:** decidido para o desenho inicial

Escolhas iniciais:
- banco local: Drift;
- estado: Riverpod;
- fórmulas personalizadas: math_expressions;
- GPS/localização: geolocator;
- gráficos: fl_chart;
- PDF: pdf + printing;
- CSV: csv;
- XLS/XLSX: excel;
- KML: geração própria via XML.

## D-039 — Padrão de ações no topo e cadastro
**Status:** decidido para a interface

Em telas com cabeçalho próprio, a lateral direita do topo deve exibir a logo do DENDRO Mobile como padrão visual consistente.

Ações principais de criação/cadastro, como novo levantamento, nova propriedade, novo talhão e nova parcela, devem usar botão flutuante no canto inferior direito, seguindo o padrão do botão `+` da tela de parcelas.

Ações contextuais que não são cadastro, como resultados e exportação dentro de uma propriedade, devem ficar dentro do bloco/card de contexto correspondente, e não substituir a logo no topo.

## D-040 — Barra inferior sempre disponível
**Status:** decidido para a interface

A barra inferior de navegação deve permanecer fixa durante o uso do aplicativo, inclusive em telas internas como detalhe de propriedade, levantamento, parcelas e coleta.

Nas telas principais, a barra exibe ícones e nomes. Em telas internas, a barra passa para modo compacto, exibindo apenas os ícones para ocupar menos espaço vertical.

Os rótulos da barra inferior devem ser responsivos: em celulares, usar abreviações planejadas para evitar cortes automáticos; em telas largas/tablets, usar nomes completos.

Cada aba mantém sua própria pilha de navegação. Ao tocar novamente na aba atual enquanto estiver em uma tela interna, o app deve voltar para a tela principal daquela aba.
