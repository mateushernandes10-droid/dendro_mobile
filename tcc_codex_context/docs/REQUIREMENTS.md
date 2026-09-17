# Requisitos e atendimento na versão atual

Revisão em 14/09/2026. “Implementado” indica existência no código, não validação científica ou aprovação por usuários.

## Requisitos funcionais

| ID | Requisito | Estado e comportamento atual |
|---|---|---|
| RF-001 | Gerenciar propriedades | Implementado: cadastro, consulta, edição, exclusão, busca/filtros; nome, município, UF e área em ha. Nova propriedade também pode ser cadastrada em Novo levantamento. |
| RF-002 | Gerenciar talhões | Implementado: vínculo à propriedade, identificação, espécie, área; ano de plantio, espaçamento, manejo, observações e dimensões de parcela opcionais. |
| RF-003 | Gerenciar parcelas | Implementado: identificação sequencial, área opcional, situacao e vínculo ao talhão dentro de um levantamento. Permite preparar parcelas antes da coleta. |
| RF-004 | Gerenciar árvores | Implementado: número sequencial na parcela, edição/exclusão, ações Salvar e Próxima, indicação de tronco torto e coordenada opcional. |
| RF-005 | Registrar medições | Implementado: DAP em cm e altura em m; formulário exige valores positivos. |
| RF-006 | Gerenciar espécies | Implementado: nome, nome científico/observação opcionais, ativo/inativo e fórmulas associadas; catálogo base Pinus e Eucalyptus. A espécie é definida no talhão/contexto do levantamento, não individualmente na árvore. |
| RF-007 | Configurar fórmulas/modelos | Parcial: cadastro de nome, expressão, descrição, variáveis e coeficientes existe; avaliação de expressões arbitrárias e validação por parser não foram implementadas. |
| RF-008 | Configurar coeficientes | Implementado: definições globais, valores por espécie/fórmula e valores por talhão do levantamento; inclui ff informado pelo usuário. Não há ajuste estatístico. |
| RF-009 | Calcular volume | Implementado para Spurr, Schumacher-Hall e Fator de Forma. Ver equações, seleção interna e valores alternativos em BUSINESS_RULES.md. A adequação científica ainda depende de validação. |
| RF-010 | Apresentar resultados | Implementado: contagens, área medida, médias, distribuição diamétrica, quantidade e percentual de árvores com tronco tortuoso, volume amostrado, por hectare, extrapolado e conversões por espécie; relatórios contêm indicadores adicionais. |
| RF-011 | Estimar valor econômico bruto | Não implementado: objetivo original do TCC, sem fluxo de preço da madeira ou cálculo monetário no código atual. Não incluir como caso de uso entregue. |
| RF-012 | Corrigir dados coletados | Implementado: edição de cadastros e medições. Datas e atividades apoiam organização; não constituem auditoria completa de versões. |
| RF-013 | Operar offline | Implementado para os fluxos locais de coleta, consulta e cálculo; não há backend. |
| RF-014 | Persistir localmente | Implementado com SQLite/Drift. |
| RF-015 | Exibir progresso da coleta | Implementado: parcelas pendentes, em andamento e coletadas; contagens e retomada. |
| RF-016 | Exportar | Implementado: PDF, CSV, XLSX, CSV bruto, XLSX bruto e KML; KMZ e XLS binário não implementados. |
| RF-017 | Gerenciar levantamentos | Implementado: planejamento, início/retomada, conclusão, edição do contexto de talhões e exclusão. Coletas ativas da mesma propriedade são reunidas; pode haver atividade simultânea em propriedades distintas. |
| RF-018 | Retomada rápida | Implementado: Início apresenta acesso ao levantamento ativo mais recente e ao talhão em foco. |
| RF-019 | Navegação principal | Implementado: Início, Levantamentos, Propriedades, Resultados e Ajustes. |
| RF-020 | Geolocalização | Implementado na coleta com permissão do dispositivo, coordenada opcional de árvore e associação explícita a P1–P4 da parcela. Não mede contorno do talhão nem distribui parcelas automaticamente. |
| RF-021 | Filtrar resultados | Implementado: propriedade, espécie e um ou mais talhões. O painel não restringe automaticamente ao levantamento mais recente; ver diferenças de escopo das exportações. |

## Exportação bruta e escopo

CSV bruto: uma linha por árvore, começando por propriedade, talhão, parcela, número, DAP cm e altura m. Inclui levantamento, espécie, situacao/área de parcela, tronco torto, um único conjunto de campos do ponto geográfico (referência P1–P4, latitude, longitude, precisão e data da captura), datas e ID da árvore. Usa UTF-8 com BOM, separador ponto e vírgula e decimal com vírgula.

XLSX bruto: uma aba por talhão, identificação de propriedade/talhão/levantamento no topo; títulos de parcelas em A6, E6, I6 etc. Cada grupo tem três colunas (árvore, DAP cm, altura m); dados começam na linha 7. Parcelas vazias preservam o título. O XLSX bruto não contém todos os campos auxiliares do CSV.

Ambos preservam as medições originais sem estimativa de altura ou volume. Exportação por levantamento restringe os dados àquele levantamento. Exportação por propriedade escolhe o vínculo mais recentemente atualizado de cada talhão; não é um backup de todos os levantamentos históricos. A seleção de talhões é respeitada.

O CSV de resultados também apresenta apenas um conjunto de coordenadas por árvore registrada. No XLSX de resultados, as coordenadas ficam concentradas na aba `Coordenadas`; a aba `Árvores` mantém as medições e os resultados sem repetir os campos geográficos.

## Requisitos não funcionais

| ID | Atendimento atual |
|---|---|
| RNF-001 — Mobile | Flutter com alvo inicial Android; houve build de APK e preparação de emulador de tablet. Validação formal em múltiplos dispositivos não realizada. |
| RNF-002 — Offline | Dados e processamento essenciais locais. |
| RNF-003 — Persistência | SQLite/Drift com estrutura física em português, chaves inteiras e relacionamentos por chaves estrangeiras. |
| RNF-004 — Usabilidade | Interface pt-BR para coleta sequencial; avaliação com usuários ainda pendente. |
| RNF-005 — Confiabilidade matemática | Testes automatizados de casos conhecidos existem; comparação independente de inventário completo ainda pendente. |
| RNF-006 — Entradas | Formulários validam campos e valores numéricos; não há validação agronômica universal ou garantia sobre qualquer expressão cadastrada. |
| RNF-007 — Manutenção | Organização por funcionalidades, telas/repositórios e calculadora separada; não há camadas completas de Clean Architecture. |
| RNF-008 — Expansão | Portabilidade/sincronização futura são possibilidades, não funcionalidades entregues. |
| RNF-009 — Expressões | Parser seguro de expressões genéricas não implementado. O código não executa a expressão como código arbitrário. |
| RNF-010 — Localização | Solicita permissão e trata indisponibilidade; GPS é opcional. |
| RNF-011 — Identidade | DENDRO Mobile, tema e preferência de modo escuro persistida localmente. |

## Limites da entrega e do artigo

Não foram implementados backend, login, nuvem, estimativa econômica, regressão para obter coeficientes, parser genérico, KMZ, importação de contorno ou distribuição automática de parcelas. Não descrever essas funções como concluídas.

O método de referência é amostragem sistemática com parcelas de área fixa, mas a execução e adequação do protocolo dependem do responsável técnico. Não há resultados documentados de validação com usuários/engenheiro que sustentem ganhos de tempo ou precisão florestal.

A decisão de encerrar alterações no aplicativo não transforma requisitos não atendidos em implementados: eles são limitações da versão final de desenvolvimento.

## Identificadores

As 13 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a chave primária composta (especie_id, modelo_matematico_id). Espécies e modelos possuem codigo textual único e opcional para os itens conhecidos do catálogo. São 14 tabelas e 105 colunas.
