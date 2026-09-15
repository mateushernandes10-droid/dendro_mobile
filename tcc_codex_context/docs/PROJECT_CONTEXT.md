# Contexto atual — DENDRO Mobile

Revisão em 14/09/2026. Esta documentação retrata a versão v11 com IDs inteiros e a migração solicitada pelo usuário.

## Tema e objetivo

Aplicativo mobile para apoio à coleta, armazenamento e processamento de inventários florestais em florestas plantadas, com foco original em Pinus e Eucalyptus no Rio Grande do Sul. O público-alvo inclui profissionais de campo, engenheiros florestais e produtores.

O problema estudado é a organização de medições de campo e seu processamento posterior. Redução de retrabalho, erros ou tempo são benefícios pretendidos, ainda não demonstrados por validação de usuários nesta documentação.

O objetivo original do TCC incluía estimativa econômica. A versão implementada cobre coleta, cálculos volumétricos e exportação; não possui entrada de preço ou cálculo de valor monetário. O artigo deve reconhecer essa diferença.

## Produto implementado

Flutter/Dart, gerenciamento de estado com Riverpod e SQLite via Drift. Dados e cálculos são locais. Não existe backend, login, sincronização em nuvem ou separação de permissões entre usuário de campo e engenheiro.

Cadastros permanentes: propriedade e talhão. Um levantamento pertence a uma propriedade e contém vínculos com talhões. Parcelas e árvores pertencem ao contexto de cada coleta, preservando levantamentos anteriores. A operação reúne coletas ativas da mesma propriedade; propriedades distintas podem ter levantamentos ativos simultâneos.

Fluxo principal: cadastrar/selecionar propriedade e talhão, iniciar ou retomar levantamento, configurar modelo/coeficientes, preparar parcelas, registrar árvores com DAP e altura, capturar GPS opcional, encerrar parcelas, consultar resultados e exportar.

As abas são Início, Levantamentos, Propriedades, Resultados e Ajustes. Ajustes contém espécies, fórmulas e modo escuro. Há histórico local de atividades.

## Cálculos

Modelos implementados: Spurr, Schumacher-Hall e Fator de Forma. DAP é registrado em cm e altura em m. No Fator de Forma, o cálculo converte DAP para metros e usa ff informado pelo usuário. O cadastro de fórmulas não equivale a um interpretador genérico de expressões.

O sistema aplica coeficientes configurados e valores de referência presentes no código; não estima coeficientes por regressão. A existência de valores padrão não comprova sua aplicabilidade a qualquer espécie ou região. As equações e comportamentos alternativos estão em BUSINESS_RULES.md.

## Método e recursos

O método de referência é amostragem sistemática com parcelas de área fixa. O app permite registrar dimensões/áreas e extrapola volumes por área amostrada; não verifica a distribuição sistemática nem executa um planejamento estatístico completo da amostragem.

GPS é documental, opcional e sujeito à precisão do dispositivo. Não substitui levantamento topográfico.

Exportações: PDF, CSV e XLSX com resultados, CSV/XLSX brutos e KML. Há diferenças de escopo entre painel, exportação por propriedade e exportação por levantamento, documentadas nos requisitos.

## Como usar estes documentos no TCC

- REQUIREMENTS.md: requisitos e estado real de atendimento.
- BUSINESS_RULES.md: regras e limitações observáveis no código.
- ARCHITECTURE.md: componentes efetivamente existentes.
- ENGINEERING_MODELS.md: diagramas revisados e modelo do banco.
- IMPLEMENTATION_NOTES.md: evidências, escopo e verificações.
- DECISIONS.md: histórico de decisões; D-045 estabelece IDs inteiros e a migração para v11; D-044 registra a tradução anterior.

A validação científica, a comparação manual de inventário completo, os testes com usuários e a escrita final do artigo permanecem trabalhos acadêmicos pendentes. Um APK gerado e testes automatizados aprovados não substituem essas etapas.

## Identificadores — schema v11

As 14 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a PK composta (especie_id, modelo_matematico_id), ambas inteiras. Espécies e modelos têm codigo textual único e opcional: os padrões conservam seus códigos estáveis; cadastros personalizados não precisam gerar códigos nem UUID. As regras de escolha de modelos usam codigo, sem alterar expressões ou coeficientes. registros_atividade usa entidade_id inteiro opcional, sem FK polimórfica; referencia_legada conserva apenas referências antigas sem entidade correspondente. São 15 tabelas e 115 colunas.
