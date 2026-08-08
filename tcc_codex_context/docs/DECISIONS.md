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

`Propriedade -> Talhão -> Parcela -> Árvore`

Essa hierarquia deve orientar navegação e modelagem do banco.

## D-006 — Escopo florestal inicial
**Status:** decidido

Foco em florestas plantadas de Pinus e Eucalyptus e validação no Rio Grande do Sul.

## D-007 — Modelos volumétricos
**Status:** decidido no referencial / implementação a validar

Modelos considerados inicialmente:
- Spurr;
- Schumacher-Hall.

As fórmulas e coeficientes exatos usados no software precisam ser confirmados a partir das fontes técnicas antes de codificar.

## D-008 — Coeficientes configuráveis
**Status:** intenção funcional discutida

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

## D-015 — Múltiplos inventários no tempo
**Status:** aberto e importante

É necessário decidir se uma mesma propriedade/talhão poderá possuir vários inventários realizados em datas diferentes.

Se sim, criar entidade `Inventory`/`InventoryRun` separando a estrutura física da propriedade dos dados de cada levantamento.

## D-016 — Método de amostragem
**Status:** pendente de validação técnica

O método definitivo deve ser validado antes de implementar extrapolações de parcela para talhão/produtividade.

## D-017 — Autenticação
**Status:** fora do escopo atual

Não há requisito atual de login/conta online.

## D-018 — Plataforma alvo inicial
**Status:** parcialmente definido

Flutter permite multiplataforma, mas a primeira execução/teste será orientada ao ambiente mobile Android. Confirmar necessidade de iOS antes de assumir suporte de produção.
