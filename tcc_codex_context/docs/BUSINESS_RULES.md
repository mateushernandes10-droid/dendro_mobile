# Regras de negócio e limites observados

Revisão em 29/09/2026. Descreve o comportamento implementado, inclusive limitações; não certifica a validade científica das equações.

## BR-001 — Hierarquia
Propriedade possui talhões e levantamentos. TalhaoLevantamentos associa um talhão a um levantamento, com espécie/modelo. Parcela pertence a essa associação; árvore pertence à parcela. Há histórico de diferentes levantamentos.

## BR-002 — Medições
Árvore armazena número, DAP cm, altura m, tronco torto, datas e coordenada opcional. A espécie vem do contexto do talhão do levantamento, não de um campo individual de árvore.

## BR-003 — Unidades
DAP é registrado em cm, altura em m e área em ha. Spurr e Schumacher-Hall usam DAP cm no cálculo. Fator de Forma converte DAP para metros. Volume é apresentado em m³. Dimensões lineares da parcela são informadas em metros.

## BR-004 — Modelos disponíveis
Spurr: `V = a + b × DAPcm² × Hm`.
Schumacher-Hall: `V = exp(a + b × ln(DAPcm) + c × ln(Hm))`.
Fator de Forma: `V = (π / 4) × (DAPcm/100)² × Hm × ff`.
O código usa `math.pi` da biblioteca `dart:math`. A divisão por 4 transforma o quadrado do diâmetro na área da seção circular: `g = (π / 4) × D²`; em seguida, o volume é calculado por `V = g × H × ff`.

## BR-005 — Coeficientes e validade
Os coeficientes não são universais. O aplicativo possui valores padrão, mas sua existência no código não demonstra adequação para qualquer espécie/região.

## BR-006 — Origem e valores padrão
Não há ajuste estatístico de coeficientes. Os valores presentes em CalculadoraVolumeFlorestal são:
- Spurr: a = 0.0175858265880592; b = 0.0000329326161133665.
- Schumacher-Hall: a = -11.584059201173265; b = 1.8114471288118603; c = 1.6187968875426328.
- Fator de Forma: `ff = 0,50` para Pinus e `ff = 0,45` para Eucalyptus no pré-cadastro por espécie; o modelo global mantém o valor vazio.
São parâmetros de referência do desenvolvimento. Os valores de `ff` foram informados por orientação técnica e continuam editáveis na configuração do levantamento. A aplicabilidade deve ser descrita no trabalho acadêmico sem atribuir validação científica apenas à rotina de carga inicial.

## BR-007 — Alcance regional
O foco do TCC é Rio Grande do Sul, Pinus e Eucalyptus. O cadastro permite outras espécies, mas isso não valida automaticamente modelos para elas.

## BR-008 — Seleção do cálculo e valores alternativos
A calculadora identifica Fator de Forma pelo código específico ou pela expressão normalizada correspondente. Exige ff finito e positivo; se inválido, retorna zero.
Nos demais casos, usa Schumacher-Hall quando o código contém “schumacher” ou a expressão normalizada começa com “exp(”; caso contrário, utiliza Spurr. Portanto uma expressão personalizada desconhecida pode ser calculada como Spurr, e não como a expressão cadastrada.
Spurr e Schumacher-Hall usam coeficientes fornecidos ou os valores padrão quando ausentes. Altura não positiva recebida pela calculadora é substituída por `6.4229 × ln(DAPcm) + 0.8203`; o formulário normal exige altura positiva. DAP/altura resolvida não positivos retornam zero; volumes negativos ou não finitos também retornam zero.
Esse comportamento deve ser documentado como limite da implementação, sem afirmar que qualquer fórmula cadastrada é corretamente interpretada.

## BR-009 — Amostragem
O método de referência é amostragem sistemática com parcelas de área fixa. O app registra parcelas e permite dimensões/áreas; não posiciona parcelas automaticamente nem verifica o protocolo de distribuição. Largura × comprimento / 10000 fornece a área padrão em ha quando configurada.

Cada talhão do levantamento armazena o erro amostral máximo desejado, inicialmente 3% e editável durante a coleta. Ao finalizar e ao montar o painel de resultados, o aplicativo calcula a suficiência com 95% de confiança a partir do volume em m³/ha de cada parcela finalizada: média, desvio padrão, coeficiente de variação, erro amostral relativo e número estimado de parcelas. A intensidade é calculada iterativamente com t de Student e usa correção para população finita quando a área do talhão e a área da parcela permitem estimar o número de unidades possíveis.

Equações implementadas: `CV% = (s / média) × 100`; `Er% = t × CV% / √n`, com fator `√((N-n)/(N-1))` quando a população é finita; `n0 = t² × CV%² / LE%²`; e `n = N × n0 / (N + n0 - 1)` para a correção finita. O valor de t e a quantidade estimada são recalculados até estabilização; em uma oscilação de arredondamento, conserva-se o maior valor.

São necessárias pelo menos duas parcelas finalizadas, com área válida e média positiva, para calcular a variabilidade. O resultado é uma orientação estatística; o usuário pode confirmar o encerramento mesmo quando a amostragem é insuficiente.

Nos resultados, cada talhão exibe permanentemente parcelas utilizadas, erro amostral atual, erro máximo desejado, parcelas estimadas, parcelas adicionais recomendadas e situação. Quando a amostra ainda não permite o cálculo, o cartão informa dados insuficientes em vez de produzir uma estimativa.

## BR-010 — Estimativa econômica
Não implementada. Entrada de preço e estimativa de valor bruto eram requisitos originais. Não há cálculo de receita ou lucro na versão atual.

## BR-011 — Qualidade
Dados e parâmetros são responsabilidade do levantamento. Validação de campos não assegura medição correta, precisão GPS ou adequação científica.

## BR-012 — Validação de entrada
Os formulários de árvore exigem DAP e altura positivos. Há obrigatoriedade de campos e unicidade no cadastro/banco. A seleção de Fator de Forma exige ff positivo e finito. Não há parser completo para validar sintaxe e símbolos de toda expressão matemática cadastrada.

## BR-013 — Offline
Cadastros, coleta, consultas, cálculos e geração de arquivos ocorrem localmente. Compartilhar arquivos depende dos aplicativos/destinos escolhidos pelo usuário.

## BR-014 — Persistência
SQLite via Drift. Há 14 tabelas de aplicação declaradas no banco. Resultados calculados não têm tabela própria.

## BR-015 — Histórico
Datas, situacao e registros_atividade apoiam a organização. Coeficientes por talhão do levantamento são armazenados separadamente. A expressão da fórmula permanece vinculada ao catálogo por ID; não existe versionamento histórico completo nem trilha de todas as alterações.

## BR-016 — Agregação e extrapolação
No painel e nos conjuntos de exportação de resultados, entram somente parcelas com situacao coletada. Volume amostrado é a soma dos volumes das árvores dessas parcelas, e área medida soma suas áreas válidas. Parcelas pendentes ou em andamento permanecem armazenadas e aparecem nas exportações brutas, mas não participam de médias, volumes, extrapolações nem da suficiência amostral.
Por talhão do levantamento: volume/ha = volume amostrado / área medida; volume extrapolado = volume/ha × área do talhão; árvores/ha = número de árvores / área medida. Sem área medida positiva, os quocientes não são disponibilizados. Se apenas algumas parcelas têm área ausente, elas não contribuem para o denominador, mas suas árvores podem contribuir para o numerador: isso limita a interpretação.
Médias de DAP e altura usam medições armazenadas. A substituição de altura da calculadora não altera essas medições.
O painel informa a quantidade de árvores com tronco tortuoso e o percentual em relação ao total de árvores incluídas nos filtros, tanto no consolidado quanto por talhão. Essa classificação é informativa e não altera o cálculo de volume.
O exportador também calcula área basal por árvore como π × (DAPcm/200)² e área basal/ha dividindo a soma pela área medida. O PDF apresenta idade quando há ano de plantio válido, mas não foi identificada rotina de cálculo de IMA: a menção a IMA em um aviso do exportador não comprova sua implementação.
Conversões por nome da espécie: Pinus usa 0.9367 ton/m³; Eucalyptus/Eucalipto usa 1.4 mst/m³; demais nomes mantêm m³. Não são fatores universais.
Quando um levantamento é selecionado, o painel agrega somente os registros compatíveis daquela campanha. Sem essa seleção, usa o levantamento mais recente de cada talhão compatível com os demais filtros, evitando somar medições históricas diferentes do mesmo talhão.

## BR-017 — Exclusão
Interfaces solicitam confirmação para exclusões. O banco declara relações em cascata e restrições; repositórios também removem dados relacionados explicitamente. Excluir talhão de um levantamento preserva o cadastro permanente do talhão; excluir o levantamento remove seus dados de coleta. Não desenhar exclusão da propriedade como requisito obrigatório para encerrar levantamento.

## BR-018 — Exportação
PDF, CSV com dados/resultados, XLSX de resultados, CSV bruto, XLSX bruto e KML estão implementados. XLS binário e KMZ não.
Por levantamento: apenas os vínculos daquela coleta. Por propriedade: vínculo atualizado mais recentemente para cada talhão selecionado, não todo o histórico.
CSV bruto conserva medições e campos auxiliares por árvore. XLSX bruto prioriza propriedade/talhão e parcelas lado a lado, com número/DAP/altura. Ambos incluem árvores de parcelas ainda em andamento e não substituem altura nem calculam volume.

## BR-019 — Estados de levantamento
O enum inclui planejamento (planejamento), emAndamento (em andamento) e concluido (finalizado). Parcelas preparadas podem pertencer a planejamento, promovido para coleta. A operação reúne talhões de uma mesma propriedade em seu levantamento ativo; a leitura normaliza registros ativos antigos quando possível, com tratamento de colisões. Diferentes propriedades podem ter coletas simultâneas. Não há ação dedicada de reabrir levantamento concluído documentada como fluxo entregue.

## BR-020 — Espécie/modelo/coeficientes
Uma espécie pode associar várias fórmulas e indicar uma padrão. Há definições globais de coeficientes, valores por espécie/fórmula e cópias por talhão do levantamento. No painel, se há coeficientes da coleta, usa esse conjunto; sem ele, consulta configuração da espécie, global e padrões da calculadora. Não representar espécie-fórmula como relação um-para-um.

## BR-021 — Cadastro de expressões
Nome único, expressão textual, descrição, situacao, variáveis e coeficientes são persistidos. O enum de variáveis contém DAP, altura, idade e área basal, mas a calculadora não resolve genericamente essas referências. A interface exige expressão preenchida; não existe ExpressionParser/math_expressions. Cadastro disponível não equivale a cálculo genérico entregue.

## BR-022 — GPS
Captura opcional pelo Geolocator com verificação de serviço e permissão; latitude, longitude, precisão e data ficam no banco. Os pontos são documentação de campo, não levantamento topográfico certificado.

## BR-023 — KML
Exporta a representação geográfica a partir das coordenadas registradas nas árvores. Quando uma coordenada possui referência P1–P4, ela também compõe os pontos e o polígono da parcela. Não existe exportação KMZ nem importação/desenho completo de contorno de talhão.

## BR-024 — Filtros
Painel permite propriedade, espécie e talhões; exige propriedade ou espécie como filtro base. Alterar filtros modifica a consulta, não os dados. O escopo histórico do painel difere da seleção mais recente por talhão na exportação por propriedade.

## BR-025 — Estados de parcela
pendente, emAndamento e coletada. Registrar árvores inicia/atualiza a coleta; finalizar parcela é ação explícita. Sair da tela preserva árvores já salvas. O situacao do levantamento é separado do situacao das parcelas. Ao encerrar um levantamento com parcelas abertas, um primeiro aviso informa que elas serão preservadas, porém desconsideradas nos cálculos; depois da confirmação, a suficiência é sempre exibida antes da decisão final.

## BR-026 — Sequência de árvores
O próximo número é o maior número existente na parcela mais um; com parcela vazia, começa em 1. Exclusão não renumera as demais árvores, mas excluir o maior número pode permitir reutilizá-lo depois. Salvar grava e recolhe o formulário; Próxima grava e prepara novo registro.

## BR-027 — Referência geográfica
A coordenada é opcional por árvore. O usuário pode associá-la explicitamente a P1–P4 da parcela. Pontos existentes são indicados e a substituição requer confirmação no fluxo da interface. Não representar a captura GPS como etapa obrigatória da coleta.

## Evidência
A apresentação do PDF possui formatação própria para Spurr, Schumacher-Hall e Fator de Forma. A narrativa metodológica descreve amostragem sistemática sem verificar sua execução; esse texto não constitui evidência de validação científica.

Fontes: lib/nucleo/banco/banco_dendro.dart; lib/nucleo/floresta/calculadora_volume_florestal.dart; lib/nucleo/floresta/calculadora_suficiencia_amostral.dart; repositórios de resultados, exportação, parcelas e levantamentos; formulários correspondentes.

## Identificadores

As 13 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a chave primária composta (especie_id, modelo_matematico_id). Espécies e modelos possuem codigo textual único e opcional para os itens conhecidos do catálogo. registros_atividade usa entidade_id inteiro opcional e sem chave estrangeira porque pode apontar para diferentes tipos de cadastro. São 14 tabelas e 106 colunas.
