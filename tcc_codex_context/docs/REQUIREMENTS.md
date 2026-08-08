# REQUIREMENTS.md

## Escopo do MVP
O MVP deve permitir executar localmente o fluxo essencial de um inventário florestal simplificado, desde a organização da área até a apresentação dos resultados calculados.

## Requisitos funcionais

### RF-001 — Gerenciar propriedades
O usuário deve poder cadastrar, visualizar, editar e excluir propriedades.

Dados exatos obrigatórios da propriedade ainda devem ser validados. Inicialmente considerar, no mínimo, uma identificação/nome.

### RF-002 — Gerenciar talhões
O usuário deve poder cadastrar, visualizar, editar e excluir talhões vinculados a uma propriedade.

O talhão deve possuir identificação própria e vínculo com a propriedade.

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

A lista exata de espécies da primeira versão deve ser confirmada antes de ser hardcodada.

### RF-007 — Configurar modelo volumétrico
O sistema deve permitir selecionar o modelo matemático utilizado no cálculo volumétrico.

Modelos inicialmente previstos:
- Spurr;
- Schumacher-Hall.

### RF-008 — Configurar coeficientes
O sistema deve utilizar coeficientes adequados à espécie/região/modelo.

A intenção funcional é permitir configuração/cadastro dos coeficientes, evitando tratá-los como constantes universais.

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

## Fora do escopo atual
- backend obrigatório;
- autenticação online;
- sincronização em nuvem;
- aplicação web;
- cálculo estatístico dos coeficientes volumétricos;
- criação de novos modelos científicos de volume;
- substituição da avaliação técnica de um engenheiro florestal.

## Pendências de requisitos que precisam ser confirmadas
- campos exatos de Propriedade;
- campos exatos de Talhão;
- campos exatos de Parcela;
- espécies exatas oferecidas inicialmente;
- método de amostragem definitivo;
- regra exata para extrapolação e cálculo de produtividade;
- unidades oficiais exibidas em cada campo;
- fórmulas/coeficientes definitivos que virão pré-cadastrados;
- política de exclusão de dados relacionados;
- formato e prioridade das exportações.
