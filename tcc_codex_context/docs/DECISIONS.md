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
**Status:** decidido conceitualmente

Cadastro permanente:

`Propriedade -> Talhão`

Coleta:

`Propriedade -> Levantamento/Contagem -> Talhão -> Parcela -> Árvore`

Essa hierarquia deve orientar navegação e modelagem do banco. A entidade Levantamento/Contagem separa o cadastro permanente da propriedade dos dados medidos em uma coleta específica.

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

## D-009 — Sistema não calcula coeficientes
**Status:** decidido

Não faz parte do projeto ajustar estatisticamente novos coeficientes. Eles devem vir de estudos técnicos ou ser informados/configurados por usuário qualificado.

## D-010 — Estimativa econômica
**Status:** decidido

O usuário informa o preço do metro cúbico. O sistema apresenta uma estimativa **bruta** do valor da madeira, e não lucro líquido.

## D-011 — Exportação
**Status:** desejada, prioridade a definir

Existe interesse em exportar dados, por exemplo para planilha e possivelmente PDF. Implementar após o fluxo central de cadastro/coleta/cálculo, salvo mudança de prioridade.

## D-012 — IDEs e ferramentas
**Status:** decidido

- Visual Studio Code: desenvolvimento principal.
- Android Studio: SDK/emulador/configuração Android.
- Git: controle de versão.
- GitHub: hospedagem do repositório.

## D-013 — Gerenciamento de estado Flutter
**Status:** aberto

Ainda não definido entre Provider, Riverpod, Bloc ou solução mais simples.

Critério: simplicidade, legibilidade, testabilidade e adequação ao tamanho do TCC.

## D-014 — ORM/camada SQLite
**Status:** aberto

Ainda não foi definido se o acesso ao SQLite será feito com `sqflite`, Drift ou outra biblioteca.

Não escolher sem avaliar complexidade e necessidade real.

## D-015 — Múltiplos levantamentos no tempo
**Status:** decidido

Uma mesma propriedade poderá possuir vários levantamentos/contagens realizados em datas diferentes.

Criar entidade `InventoryRun`/`Levantamento` separando a estrutura física da propriedade dos dados de cada coleta. Um levantamento deve possuir status e datas de início/atualização/conclusão.

## D-016 — Método de amostragem
**Status:** pendente de validação técnica

O método definitivo deve ser validado antes de implementar extrapolações de parcela para talhão/produtividade.

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

Cada fórmula deve possuir nome único, expressão validada e coeficientes/variáveis necessários. A biblioteca definitiva para avaliação matemática ainda será escolhida.

## D-026 — Geolocalização de parcelas
**Status:** desejada para o fluxo de levantamento

Durante a criação/coleta de uma parcela, o usuário poderá capturar pontos de localização com o dispositivo, por exemplo os quatro cantos da parcela. Esses pontos servem para documentação e apoio visual, não como medição topográfica precisa sem validação técnica.

## D-027 — Exportação para Google Earth
**Status:** desejada

O sistema deve ser preparado para exportar pontos/polígonos de parcelas em KML/KMZ, permitindo abertura no Google Earth e uso na documentação do inventário.

## D-028 — Resultados como dashboard
**Status:** decidido para o desenho inicial

A aba Resultados deve funcionar como dashboard analítico, inicialmente orientado à seleção de uma propriedade para visualizar levantamentos e resultados consolidados. Resultados detalhados também devem estar disponíveis dentro de cada levantamento.
