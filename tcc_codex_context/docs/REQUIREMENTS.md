# REQUIREMENTS.md

## Escopo do MVP
O MVP deve permitir executar localmente o fluxo essencial de um inventário florestal simplificado, desde a organização da área até a apresentação dos resultados calculados.

## Requisitos funcionais

### RF-001 — Gerenciar propriedades
O usuário deve poder cadastrar, visualizar, editar e excluir propriedades.

Inicialmente considerar:
- nome da propriedade;
- município;
- UF;
- área total em hectares (`ha`).

A listagem de propriedades deve permitir busca por nome e filtros por município, faixa de área em hectares e faixa de quantidade de talhões.

Na listagem, tocar na propriedade deve abrir seus detalhes. Ações como editar e excluir devem ficar em menu próprio, por exemplo em ícone de três pontos no final da linha/card.

### RF-002 — Gerenciar talhões
O usuário deve poder cadastrar, visualizar, editar e excluir talhões vinculados a uma propriedade.

O talhão deve possuir vínculo com a propriedade selecionada no fluxo. O município pertence à propriedade e não deve ser repetido no cadastro do talhão.

Campos do talhão:
- identificação;
- espécie, selecionada entre espécies cadastradas;
- área em hectares (`ha`);
- ano do plantio, opcional;
- espaçamento, opcional;
- regime de manejo, opcional;
- observação, opcional.

### RF-003 — Gerenciar parcelas
O usuário deve poder cadastrar, visualizar, editar e excluir parcelas vinculadas a um talhão.

O usuário deve poder criar parcelas antes de realizar a medição de campo. Enquanto não forem medidas, essas parcelas devem permanecer com status `pendente`.

Ao cadastrar nova parcela, o sistema deve sugerir identificação sequencial automaticamente, por exemplo `P01`, `P02`, `P03`.

A tela de parcelas de um talhão/levantamento deve exibir:
- espécie principal do talhão/levantamento;
- área total em hectares;
- total de parcelas cadastradas;
- quantidade de parcelas coletadas em formato de fração, por exemplo `5/10`;
- lista de parcelas com status.

Cada parcela coletada deve exibir, quando disponível, total de árvores medidas e coordenadas/geolocalização resumida.

A área/tamanho da parcela é opcional, pois pode variar, embora normalmente siga um padrão de campo.

Campos da parcela, além das árvores medidas:
- identificação sequencial;
- talhão vinculado;
- status;
- área/tamanho opcional;
- pontos GPS opcionais;
- posição de referência opcional (`P1`, `P2`, `P3` ou `P4`) quando definida durante captura de coordenada.

A tela deve possuir ação clara para cadastrar nova parcela, por exemplo botão `+`.

### RF-004 — Gerenciar árvores
O usuário deve poder registrar, visualizar, editar e excluir árvores vinculadas a uma parcela.

A tela da parcela deve exibir a lista de árvores já medidas, com DAP e altura registrados. Cada item deve permitir edição e exclusão.

O cadastro/edição de árvore deve ocorrer por painel/janela deslizante sobreposta à tela da parcela, mantendo a lista visível parcialmente quando possível.

A tela da parcela deve possuir ação **Nova árvore**. Ao acionar essa opção, o painel de cadastro deve ser aberto.

Ao criar uma nova árvore, o sistema deve sugerir automaticamente a identificação sequencial, por exemplo `Árvore 1`, `Árvore 2`, `Árvore 3`.

No painel de cadastro/edição, ao lado da identificação da árvore, deve existir ação para capturar coordenada usando a localização do dispositivo. Essa captura é opcional e pode ser usada, por exemplo, quando a árvore medida estiver em uma quina/referência da parcela.

No painel de cadastro/edição de árvore devem existir duas ações:
- **Salvar**: grava os dados e recolhe o painel, retornando à lista de árvores;
- **Próxima**: grava os dados, atualiza a lista e mantém o painel aberto/limpo para registrar outra árvore.

Ao editar uma árvore existente, o painel deve abrir preenchido com os dados registrados anteriormente.

A tela da parcela deve possuir opção para encerrar/finalizar a parcela. Ao encerrar, o status da parcela deve mudar para `coletada`. Se o usuário apenas voltar/sair da tela sem encerrar, os dados registrados permanecem salvos, mas a parcela continua `em andamento`.

### RF-005 — Registrar medições dendrométricas
Para cada árvore, o sistema deve permitir registrar as variáveis necessárias ao cálculo definido para o projeto, incluindo inicialmente:
- DAP;
- altura.

Unidades oficiais iniciais:
- DAP em centímetros (`cm`);
- altura em metros (`m`).

O motor de fórmulas deve reconhecer inicialmente quatro referências de variável: DAP, altura, idade e área basal. DAP e altura são medições registradas na árvore; idade e área basal podem ser derivadas a partir de dados cadastrados/calculados quando a fórmula escolhida exigir.

### RF-006 — Registrar/selecionar espécie
O sistema deve associar a coleta a espécies do escopo do projeto, inicialmente dos gêneros Pinus e Eucalyptus.

O cadastro base inicial deve conter Pinus e Eucalyptus/Eucalipto. Se o TCC exigir espécies botânicas específicas, a lista detalhada deve ser confirmada antes de ser tratada como definitiva.

Cada espécie deve poder ser associada a uma ou mais fórmulas/modelos matemáticos permitidos. O usuário deve poder definir uma fórmula/modelo padrão para a espécie.

### RF-007 — Configurar fórmulas/modelos volumétricos
O sistema deve permitir selecionar e cadastrar a fórmula/modelo matemático utilizado no cálculo volumétrico.

Modelos inicialmente previstos:
- Spurr;
- Schumacher-Hall.

Além dos modelos inicialmente previstos, o sistema deve permitir cadastro de fórmulas personalizadas pelo usuário, desde que a expressão matemática seja validada antes do uso.

Cada fórmula/modelo deve possuir nome único, descrição opcional, expressão matemática, variáveis declaradas e coeficientes necessários.

No cadastro da fórmula, o usuário deve poder definir quais símbolos/letras serão usados na expressão matemática. Cada símbolo precisa estar associado a uma variável reconhecida pelo sistema, por exemplo DAP, altura, idade ou área basal, para que o aplicativo saiba qual valor fornecer na hora do cálculo.

A tela de fórmulas/modelos deve exibir uma lista em blocos/cards. Cada card deve mostrar, inicialmente, o nome da fórmula/modelo e sua expressão matemática.

Ao tocar no card, uma área expansível deve abrir mostrando coeficientes/variáveis configuráveis. Ao tocar novamente, a área deve recolher.

Se o usuário alterar coeficientes/variáveis e tentar recolher/sair sem salvar, o sistema deve perguntar se deseja salvar ou descartar as alterações.

Na linha do nome do modelo deve existir um menu de três pontos com ações como editar e excluir.

### RF-008 — Configurar coeficientes
O sistema deve utilizar coeficientes adequados à espécie/região/modelo.

A intenção funcional é permitir configuração/cadastro dos coeficientes, evitando tratá-los como constantes universais. Para fórmulas personalizadas, o sistema deve exigir que todos os coeficientes utilizados pela expressão estejam disponíveis antes do cálculo.

### RF-009 — Calcular volume
O sistema deve calcular o volume a partir dos dados coletados, modelo escolhido e coeficientes configurados.

Devem existir resultados no nível necessário para consolidar o inventário, no mínimo volume calculado a partir das árvores medidas e seus agrupamentos.

O método de amostragem definido para o projeto é amostragem sistemática com parcelas de área fixa, preferencialmente retangulares.

A extrapolação de parcela para talhão deve seguir a lógica de volume médio por unidade de área amostrada, extrapolada para hectare e para a área total do talhão, desde que a área amostrada necessária esteja disponível.

### RF-010 — Apresentar produtividade/resultados consolidados
O sistema deve consolidar e apresentar resultados do inventário por parcela e/ou talhão conforme as regras técnicas validadas no projeto.

### RF-011 — Estimar valor econômico bruto
O usuário deve poder informar o preço do metro cúbico da madeira.

O sistema deve apresentar a estimativa econômica bruta com base no volume estimado e no preço informado.

### RF-012 — Editar dados coletados
O usuário deve conseguir corrigir registros de propriedade, talhão, parcela, árvore e medições antes ou depois do cálculo.

### RF-013 — Operar offline
Todo o fluxo principal deve funcionar sem internet.

### RF-014 — Persistir dados localmente
Os registros devem permanecer disponíveis após fechar/reabrir o aplicativo, utilizando SQLite.

### RF-015 — Exibir progresso/organização da coleta
A interface deve facilitar a navegação hierárquica entre propriedade, talhão, parcela e árvore e permitir ao usuário identificar o que já foi registrado.

### RF-016 — Exportar dados/resultados
Requisito desejado para a aplicação prática: permitir exportar informações coletadas e/ou resultados, preferencialmente em formato de planilha (ex.: CSV/XLSX) e, se viável, relatório PDF.

A prioridade e o formato final devem ser definidos durante o desenvolvimento. Não é requisito central explicitado no objetivo do TCC, portanto não deve bloquear o MVP inicial.

Também é desejável exportar pontos/polígonos de parcelas em KML/KMZ para uso no Google Earth.

A exportação futura deve considerar como referência o modelo de inventário fornecido pelo engenheiro responsável, salvo em `tcc_codex_context/assets/references/inventario_referencia_engenheiro_outubro_2025.png`, contendo agrupamentos, subtotais, totais e indicadores dendrométricos semelhantes quando houver regras técnicas validadas.

A tela de exportação deve poder ser aberta a partir do cadastro/detalhe da propriedade, da tela de resultados e do detalhe de um levantamento.

Ao abrir a exportação a partir de uma propriedade, todos os talhões da propriedade devem vir selecionados por padrão, permitindo ao usuário desmarcar talhões que não deseja incluir.

Ao abrir a exportação a partir de um levantamento, os talhões/áreas vinculados ao levantamento devem vir selecionados por padrão, respeitando o escopo daquele levantamento.

Formatos inicialmente desejados:
- relatório PDF;
- dados brutos CSV;
- planilha XLS/XLSX;
- arquivo geográfico KML/KMZ para Google Earth.

O usuário deve poder selecionar o formato do arquivo e o conjunto de talhões/áreas incluídos na exportação.

### RF-017 — Gerenciar levantamentos/contagens
O usuário deve poder criar, visualizar, editar, continuar e concluir levantamentos vinculados a uma propriedade.

Uma propriedade pode possuir vários levantamentos ao longo do tempo. O sistema deve permitir mais de um levantamento em andamento simultaneamente.

Cada levantamento deve possuir, no mínimo:
- propriedade vinculada;
- um ou mais talhões vinculados;
- status (`em andamento` ou `concluído`);
- data/hora de início;
- data/hora de atualização;
- data/hora de conclusão, quando aplicável;
- espécie e fórmula/modelo utilizados, conforme a estrutura final definida.

Ao iniciar uma nova contagem, o usuário deve selecionar uma propriedade já cadastrada ou cadastrar uma propriedade no momento do fluxo, quando viável.

O fluxo inicial previsto para novo levantamento é:
1. selecionar ou cadastrar a propriedade;
2. selecionar um ou mais talhões da propriedade;
3. confirmar a espécie e o modelo/fórmula de cada talhão selecionado;
4. criar ou reutilizar parcelas no contexto daquele levantamento;
5. registrar as árvores e finalizar parcelas quando a coleta for encerrada.

Internamente, cada talhão selecionado em um levantamento deve gerar um vínculo `talhaolevantamento`, que guarda o contexto daquela coleta para permitir histórico e recontagem futura do mesmo talhão.

### RF-018 — Tela inicial e retomada rápida
A tela inicial deve funcionar como dashboard operacional.

Ela deve permitir:
- criar novo levantamento;
- continuar o levantamento em andamento mais recente;
- acessar a lista de levantamentos em aberto;
- visualizar resumo do último levantamento concluído, quando existir.

### RF-019 — Navegação principal
A aplicação deve utilizar navegação principal por barra inferior com as seguintes áreas:
- Início;
- Levantamentos;
- Propriedades;
- Resultados;
- Ajustes.

### RF-020 — Geolocalizar parcelas
Durante o levantamento, o usuário deve poder capturar pontos de geolocalização da parcela utilizando a localização do dispositivo.

O fluxo inicial deve permitir registrar pontos ordenados, por exemplo quatro cantos de uma parcela retangular/quadrada. Cada ponto deve armazenar latitude, longitude, precisão informada pelo dispositivo e data/hora da captura.

Durante a coleta de árvores, o usuário também deve poder capturar coordenada opcional para uma árvore específica, registrando latitude, longitude, precisão informada pelo dispositivo e data/hora da captura.

Quando uma coordenada de árvore for usada como ponto da parcela, o usuário deve selecionar explicitamente o ponto correspondente (`P1`, `P2`, `P3`, `P4` etc.). Pontos já registrados devem ser exibidos com cor/estado diferente dos pontos pendentes, e o ponto atualmente selecionado deve ficar destacado.

O uso de geolocalização deve ser opcional e não deve bloquear a coleta dendrométrica quando a localização do dispositivo estiver indisponível.

### RF-021 — Consultar resultados por propriedade
A área de resultados deve funcionar como dashboard analítico, inicialmente orientado à seleção de uma propriedade para visualizar levantamentos e resultados consolidados.

Os resultados detalhados também devem estar acessíveis a partir de cada levantamento concluído.

A tela de resultados deve permitir selecionar uma propriedade. A partir dela, o usuário pode aplicar filtros opcionais e independentes, incluindo:
- um ou mais talhões;
- uma espécie;
- outros filtros futuros, como período ou status, se definidos.

Os filtros não devem depender uns dos outros: o usuário pode filtrar apenas por propriedade, propriedade + talhão, propriedade + espécie, ou propriedade + talhão + espécie.

Ao alterar filtros, os indicadores e gráficos exibidos devem ser recalculados/atualizados considerando somente os dados compatíveis com os filtros ativos.

A tela de resultados deve poder ser aberta pela aba **Resultados** da barra inferior ou por atalhos em outras telas:
- a partir de uma propriedade, abrindo com a propriedade já selecionada;
- a partir de um talhão, abrindo com propriedade e talhão já selecionados.

A tela de resultados deve ser preparada para apresentar indicadores semelhantes aos utilizados em inventários florestais de referência, incluindo, quando houver regra técnica e dados suficientes:
- área analisada em hectares;
- ano de plantio ou idade do povoamento;
- número de árvores por hectare;
- DAP médio;
- altura média;
- área basal (`G`, em m²/ha);
- volume médio por árvore (`m³/árv.`);
- volume por hectare (`m³/ha`);
- IMA em centímetros por ano (`cm/ano`);
- IMA em metros cúbicos por hectare por ano (`m³/ha/ano`);
- volume total estimado (`m³`).

Indicadores dependentes de extrapolação, idade, área basal ou método de amostragem devem ser implementados somente após validação das fórmulas e unidades correspondentes.

Unidades oficiais iniciais para resultados:
- volume em metros cúbicos (`m³`);
- área em hectares (`ha`).

## Requisitos não funcionais

### RNF-001 — Mobile
A aplicação deve ser desenvolvida em Flutter/Dart e ter foco em uso em smartphone.

### RNF-002 — Offline-first
Nenhuma funcionalidade essencial de coleta e cálculo pode depender de conexão com a internet.

### RNF-003 — Persistência local
Utilizar SQLite na primeira versão.

### RNF-004 — Usabilidade em campo
A interface deve priorizar simplicidade, poucos passos, boa legibilidade e facilidade de preenchimento durante a coleta.

### RNF-005 — Confiabilidade matemática
Os cálculos devem ser determinísticos e testados contra resultados de referência.

### RNF-006 — Validação de entrada
Campos numéricos devem rejeitar entradas impossíveis do ponto de vista lógico, como valores negativos e formatos inválidos.

Limites florestais específicos não devem ser impostos sem validação técnica.

### RNF-007 — Manutenibilidade
Separar UI, regras de negócio e acesso ao banco para permitir testes e evolução.

### RNF-008 — Portabilidade futura
Evitar decisões que impeçam futura sincronização com servidor ou expansão de espécies/modelos, embora essas funcionalidades não façam parte do núcleo atual.

### RNF-009 — Segurança no cálculo de fórmulas personalizadas
Fórmulas cadastradas pelo usuário devem ser avaliadas por mecanismo controlado de expressão matemática. O aplicativo não deve executar código arbitrário informado pelo usuário.

### RNF-010 — Localização e permissões
O uso de localização deve solicitar permissão ao usuário somente quando necessário e deve tratar recusa, indisponibilidade do GPS e baixa precisão de forma clara.

### RNF-011 — Identidade visual
A interface deve utilizar o nome **DENDRO Mobile** e seguir a identidade visual derivada da logo fornecida, mantendo legibilidade, simplicidade e adequação ao uso em campo.

## Fora do escopo atual
- backend obrigatório;
- autenticação online;
- sincronização em nuvem;
- aplicação web;
- cálculo estatístico dos coeficientes volumétricos;
- criação de novos modelos científicos de volume;
- uso da geolocalização como levantamento topográfico preciso sem validação técnica;
- substituição da avaliação técnica de um engenheiro florestal.

## Pendências de requisitos que precisam ser confirmadas
- campos adicionais de Propriedade, além de nome, município, UF e área em ha;
- necessidade de espécies botânicas específicas além dos cadastros base Pinus e Eucalyptus/Eucalipto;
- dimensão/padrão inicial das parcelas fixas, quando houver;
- fórmula operacional final para extrapolação e cálculo de produtividade;
- unidade oficial de produtividade;
- fórmulas/coeficientes definitivos que virão pré-cadastrados;
- formato e prioridade das exportações;
- formato exato dos arquivos KML/KMZ e quais dados devem ser incluídos.
