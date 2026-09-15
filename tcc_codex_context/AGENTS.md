# AGENTS.md

## Projeto
Aplicação mobile para apoio à coleta, armazenamento e análise de dados de inventário florestal em florestas plantadas de **Pinus** e **Eucalyptus**, com foco inicial no **Rio Grande do Sul**.

## Estado vigente — revisão de 14/09/2026

O usuário autorizou uma refatoração de nomenclatura para português e substituição das chaves textuais por IDs inteiros autoincrementados, sem alterar regras, cálculos ou funcionalidades. D-045 em docs/DECISIONS.md e os documentos revisados descrevem o estado real. Não implementar pendências funcionais por inferência. Decisões anteriores e referências visuais são histórico/projeto, não prova de funcionalidade.
O banco está na versão 11, com 15 tabelas. Cálculos implementados: Spurr, Schumacher-Hall e Fator de Forma. Cadastro de expressões existe, mas não há parser genérico. Estimativa econômica e KMZ não foram implementados. Não acrescentar esses itens aos diagramas como entregues.

Antes de alterar código, leia nesta ordem:
1. `docs/PROJECT_CONTEXT.md`
2. `docs/REQUIREMENTS.md`
3. `docs/BUSINESS_RULES.md`
4. `docs/ARCHITECTURE.md`
5. `docs/DECISIONS.md`
6. `docs/ENGINEERING_MODELS.md`
7. `docs/BRANDING.md`
8. `docs/UI_REFERENCE.md`

## Diretrizes para o Codex
- O aplicativo é **mobile e offline-first**.
- Nome oficial do aplicativo: **DENDRO Mobile**.
- Nome completo/subtítulo: **DENDRO Mobile - Sistema para Inventário Florestal**.
- Logo-base: `tcc_codex_context/assets/branding/dendro_mobile_logo.png`.
- Stack definida: **Dart + Flutter + SQLite**.
- Camada SQLite definida: **Drift**.
- Gerenciamento de estado definido: **Riverpod**.
- Avaliação genérica com **math_expressions** foi planejada, mas não implementada. Documentar a seleção de modelos existente em CalculadoraVolumeFlorestal; só retomar implementação mediante novo pedido.
- A primeira versão **não possui backend nem servidor externo**.
- Não introduzir Firebase, Supabase, MySQL, PostgreSQL, APIs remotas ou autenticação online sem solicitação explícita.
- A estrutura permanente do cadastro parte de **Propriedade -> Talhão**.
- A coleta deve ser organizada por **Levantamento**, vinculado a uma propriedade e podendo conter um ou mais talhões, parcelas e árvores medidos naquele evento.
- Uma propriedade pode possuir vários levantamentos ao longo do tempo, inclusive levantamentos em áreas/talhões diferentes.
- O usuário pode ter mais de um levantamento em andamento ao mesmo tempo; o aplicativo deve sugerir retomar o levantamento em aberto mais recente na tela inicial.
- Preservar a separação entre interface, regras de negócio/cálculo e persistência.
- Não colocar fórmulas florestais diretamente em widgets de interface.
- Não hardcodar coeficientes volumétricos como se fossem universais.
- Os coeficientes dependem de espécie, região e condições do povoamento. O sistema **não calcula/ajusta estatisticamente esses coeficientes**; ele aplica valores previamente definidos a partir de estudos técnicos ou informados/configurados pelo usuário.
- Modelos implementados: **Spurr**, **Schumacher-Hall** e **Fator de Forma**.
- Além dos modelos inicialmente considerados, o sistema deve ser preparado para permitir cadastro de fórmulas volumétricas personalizadas pelo usuário, com nome único, expressão validada, variáveis permitidas e coeficientes informados/configurados.
- Fórmulas personalizadas devem ser avaliadas por biblioteca/serviço seguro de expressão matemática; não executar código arbitrário informado pelo usuário.
- As espécies/categorias iniciais previstas para cadastro base são **Pinus** e **Eucalyptus**.
- Áreas de propriedades e talhões devem ser tratadas em **hectares (ha)**.
- Unidades oficiais iniciais: DAP em **cm**, altura em **m**, volume em **m³** e área em **ha**.
- Método de amostragem definido: **amostragem sistemática com parcelas de área fixa**, preferencialmente retangulares.
- Extrapolação parcela -> talhão deve usar volume por unidade de área amostrada, extrapolado para hectare/talhão, exigindo área amostrada disponível.
- Parcelas podem receber pontos de geolocalização capturados pelo dispositivo durante o levantamento. Esses pontos servem para documentação/georreferenciamento e não devem ser usados como medição topográfica precisa sem validação técnica.
- Árvores devem possuir identificação sequencial automática dentro da parcela e podem receber coordenada opcional capturada pelo dispositivo.
- Exportação geográfica **KML** está implementada; **KMZ** permanece fora da entrega.
- Relatórios/exportações futuras devem considerar como referência o inventário técnico salvo em `tcc_codex_context/assets/references/inventario_referencia_engenheiro_outubro_2025.png`.
- Se uma fórmula, coeficiente, unidade, método de amostragem ou regra florestal não estiver documentada, **não inventar**. Marcar como pendência e solicitar definição.
- Toda rotina matemática relevante deve ter testes automatizados com entradas e saídas conhecidas.
- Validar entradas numéricas e impedir valores claramente inválidos (negativos, zero onde não fizer sentido etc.). Limites agronômicos/florestais específicos só devem ser aplicados quando houver regra validada.
- A estimativa econômica não está implementada. No objetivo original representaria valor bruto da madeira, não lucro líquido; não apresentá-la como resultado entregue.
- Priorizar código simples, legível e adequado a um TCC. Evitar arquiteturas excessivamente complexas sem necessidade.
- Manter o projeto preparado para evolução futura, mas não implementar funcionalidades fora do escopo atual sem pedido.
- Interface destinada ao contexto brasileiro; preferir textos em **pt-BR**.

## Fluxo de trabalho
Antes de implementar uma funcionalidade:
1. identificar o requisito correspondente;
2. verificar regras de negócio;
3. verificar impacto no banco local;
4. implementar;
5. criar/atualizar testes;
6. atualizar documentação se uma decisão nova for tomada.

## Git
- Commits pequenos e descritivos.
- Não alterar histórico Git, apagar branches ou executar comandos destrutivos sem autorização.
- Não versionar arquivos de build, segredos, caches ou arquivos do sistema operacional.
