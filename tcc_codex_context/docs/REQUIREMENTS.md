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

O talhão deve possuir identificação própria e vínculo com a propriedade. Quando aplicável, sua área deve ser tratada em hectares (`ha`).

### RF-003 — Gerenciar parcelas
O usuário deve poder cadastrar, visualizar, editar e excluir parcelas vinculadas a um talhão.

### RF-004 — Gerenciar árvores
O usuário deve poder registrar, visualizar, editar e excluir árvores vinculadas a uma parcela.

### RF-005 — Registrar medições dendrométricas
Para cada árvore, o sistema deve permitir registrar as variáveis necessárias ao cálculo definido para o projeto, incluindo inicialmente:
- DAP;
- altura.

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

Cada fórmula/modelo deve possuir nome único, descrição opcional, expressão matemática, variáveis permitidas e coeficientes necessários.

### RF-008 — Configurar coeficientes
O sistema deve utilizar coeficientes adequados à espécie/região/modelo.

A intenção funcional é permitir configuração/cadastro dos coeficientes, evitando tratá-los como constantes universais. Para fórmulas personalizadas, o sistema deve exigir que todos os coeficientes utilizados pela expressão estejam disponíveis antes do cálculo.

### RF-009 — Calcular volume
O sistema deve calcular o volume a partir dos dados coletados, modelo escolhido e coeficientes configurados.

Devem existir resultados no nível necessário para consolidar o inventário, no mínimo volume calculado a partir das árvores medidas e seus agrupamentos.

A fórmula exata de extrapolação de parcela para talhão deve ser implementada somente após definição/validação do método de amostragem.

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

### RF-017 — Gerenciar levantamentos/contagens
O usuário deve poder criar, visualizar, editar, continuar e concluir levantamentos vinculados a uma propriedade.

Uma propriedade pode possuir vários levantamentos ao longo do tempo. O sistema deve permitir mais de um levantamento em andamento simultaneamente.

Cada levantamento deve possuir, no mínimo:
- propriedade vinculada;
- status (`em andamento` ou `concluído`);
- data/hora de início;
- data/hora de atualização;
- data/hora de conclusão, quando aplicável;
- espécie e fórmula/modelo utilizados, conforme a estrutura final definida.

Ao iniciar uma nova contagem, o usuário deve selecionar uma propriedade já cadastrada ou cadastrar uma propriedade no momento do fluxo, quando viável.

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

O uso de geolocalização deve ser opcional e não deve bloquear a coleta dendrométrica quando a localização do dispositivo estiver indisponível.

### RF-021 — Consultar resultados por propriedade
A área de resultados deve funcionar como dashboard analítico, inicialmente orientado à seleção de uma propriedade para visualizar levantamentos e resultados consolidados.

Os resultados detalhados também devem estar acessíveis a partir de cada levantamento concluído.

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
- campos exatos de Talhão, além de identificação, vínculo com propriedade e possível área em ha;
- campos exatos de Parcela;
- necessidade de espécies botânicas específicas além dos cadastros base Pinus e Eucalyptus/Eucalipto;
- método de amostragem definitivo;
- regra exata para extrapolação e cálculo de produtividade;
- unidades oficiais de DAP, altura, volume e produtividade;
- fórmulas/coeficientes definitivos que virão pré-cadastrados;
- biblioteca/mecanismo definitivo para avaliação de expressões matemáticas personalizadas;
- política de exclusão de dados relacionados;
- formato e prioridade das exportações;
- formato exato dos arquivos KML/KMZ e quais dados devem ser incluídos.
