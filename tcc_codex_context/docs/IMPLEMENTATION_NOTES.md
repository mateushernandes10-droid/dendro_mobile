# IMPLEMENTATION_NOTES.md

Notas objetivas das decisoes feitas durante a implementacao.

## Exportação de medições brutas (2026-09-10)

- Opções próprias `Dados brutos (XLSX)` e `Dados brutos (CSV)` na tela Exportar.
- XLSX: uma aba por talhão, com propriedade e talhão no topo. Parcelas lado a lado em A6, E6, I6 etc.; árvores a partir da linha 7 em três colunas (identificação, DAP em cm, altura em m), com uma coluna vazia entre parcelas. Parcelas vazias mantêm seu título.
- CSV: uma linha por árvore de todos os talhões selecionados, inclusive parcelas ainda em andamento. Colunas iniciais: propriedade, talhão, parcela, número da árvore, DAP em cm e altura em m.
- CSV inclui também identificação do levantamento/árvore, espécie, status/área da parcela, tronco torto, GPS e datas da árvore.
- Valores originais do banco, sem cálculo de volume, estimativa de altura ou arredondamento adicional. XLSX mantém números como células numéricas; CSV usa UTF-8 com BOM, ponto e vírgula e vírgula decimal.
- Exportação aberta pelo levantamento fica restrita a ele; a seleção de talhões existente é respeitada.

## Modelo Fator de Forma

- Modelo `Fator de Forma`: `pi * (D / 100)^2 * H * ff`.
- DAP registrado em cm, convertido para m no cálculo; altura em m, sem divisão por 4 (D-042).
- `ff` é um coeficiente informado na espécie ou na coleta, sem valor padrão.
- O cadastro de fórmulas oferece a opção `Fator de forma (ff)`.
- Selecionar esse modelo exige `ff` positivo e finito; não usar Spurr como alternativa quando faltar o fator.
- Migração do banco v7 para v8 inclui o modelo e vínculos com espécies base, preservando configurações anteriores.
- Migração para v9 atualiza nome, expressão e rótulos, preservando valores de ff e medições.
- Resultados e exportações usam o mesmo cálculo em `ForestVolumeCalculator`.

## Terminologia

- Usar `levantamento` para o registro/servico como um todo.
- Usar `coleta` para a operacao de campo dentro de um levantamento.
- Evitar `contagem` na interface, nos avisos e nos documentos de regra.

## Novo levantamento

- A tela Novo levantamento oferece o mesmo botão flutuante `Nova propriedade` e formulário da tela Propriedades. Após salvar, limpa os filtros e atualiza a lista para permitir cadastrar talhões e iniciar a coleta sem sair do fluxo. Cancelar preserva os filtros.

- O fluxo de novo levantamento deve abrir uma tela dedicada, nao um bottom sheet pequeno.
- A tela deve permitir busca digitada por nome da propriedade.
- A tela deve permitir filtros por municipio e especie.
- O mesmo fluxo deve poder ser aberto pela tela Inicio e pela aba Levantamentos.
- Talhoes com levantamento em andamento devem aparecer como `Em coleta`.
- Para talhoes em coleta, a acao deve ser `Continuar coleta`, evitando criar outro levantamento para o mesmo talhao.
- Ao iniciar um levantamento para um talhao, o usuario pode ajustar o modelo matematico e os coeficientes para aquela coleta especifica.
- O modelo e os coeficientes escolhidos devem ficar salvos no vinculo `talhaolevantamento`, sem alterar o cadastro global do modelo matematico.
- Ao iniciar a coleta de outro talhao da mesma propriedade, o app deve anexar esse talhao ao levantamento em andamento da propriedade, em vez de criar um levantamento separado.
- A aba Levantamentos deve mostrar primeiro a propriedade/levantamento e, dentro do card, os talhoes vinculados a esse levantamento.
- Dados antigos que tenham ficado com mais de um levantamento em andamento para a mesma propriedade devem ser normalizados na leitura, reunindo os talhoes no levantamento ativo mais recente.
- A tela deve permitir cadastrar rapidamente um novo talhao para uma propriedade e, depois do cadastro, iniciar o levantamento desse talhao.
- Na tela Inicio, o card `Continuar Coleta` deve mostrar o talhao em foco; o resumo abaixo deve somar arvores e area medida de todos os talhoes do levantamento desse card.
- Na tela Inicio, tocar em `Continuar Coleta` deve abrir diretamente as parcelas do talhao em foco, sem passar pela tela geral do levantamento.
- A tela de detalhe do levantamento deve permitir excluir o levantamento como desistencia. Antes de excluir, deve exibir confirmacao clara informando que talhoes vinculados, parcelas, arvores e coordenadas daquele levantamento serao apagados permanentemente.
- Na lista de talhoes dentro do levantamento, cada talhao deve ter menu de tres pontos com `Editar` e `Excluir`. `Excluir` remove o talhao apenas daquele levantamento, apagando parcelas/arvores/coordenadas desse vinculo e preservando o cadastro permanente do talhao na propriedade.
- Na opcao `Editar` do talhao dentro do levantamento, o usuario tambem pode trocar o modelo matematico e os coeficientes usados naquele talhao do levantamento.

## Coordenadas da parcela

- A escolha do ponto de referencia (`P1`, `P2`, `P3`, `P4`) deve aparecer somente quando o usuario aciona a captura de localizacao.
- Pontos ja capturados devem ter destaque visual diferente.
- Se o usuario tentar capturar novamente um ponto ja usado, o app deve pedir confirmacao antes de substituir.
- Ao substituir um ponto, o vinculo anterior deve ser removido para manter apenas um ponto ativo por referencia dentro da parcela.

## Ajustes e catalogos

- A aba Ajustes deve permitir habilitar/desabilitar o modo escuro. A preferencia e local do app e deve permanecer salva ao fechar e abrir novamente.
- A aba Ajustes deve funcionar como uma listagem de opcoes de configuracao. Cadastros maiores devem abrir telas internas proprias, mantendo a aba principal limpa para novas opcoes futuras.
- A aba Ajustes deve manter cadastros reais de especies e formulas/modelos matematicos, usando os catalogos persistidos no banco local.
- O cadastro de especie deve permitir nome, nome cientifico opcional, observacao opcional e status ativo/inativo.
- A especie deve permitir vincular uma ou mais formulas e marcar uma delas como formula padrao com estrela. Se a formula marcada ainda nao estiver vinculada, o sistema deve vincular e definir como padrao.
- O cadastro de formula deve permitir nome unico, expressao, descricao opcional, status ativo/inativo, variaveis usadas e simbolos dos coeficientes.
- Os coeficientes devem poder ser editados diretamente no card expandido do modelo, preservando valores quando o simbolo do coeficiente continua existindo apos uma edicao.
- Exclusao de especie ou formula deve pedir confirmacao e falhar com aviso claro quando o item estiver em uso por talhoes ou levantamentos.

## Levantamentos e resultados reais

- A aba Levantamentos deve listar dados reais de `InventoryRun`, incluindo levantamentos em andamento, concluidos e planejados.
- Cada card de levantamento deve abrir o detalhe real do levantamento e exibir propriedade, talhoes, status, arvores medidas, area medida e fracao de parcelas coletadas.
- A aba Resultados deve usar dados reais de parcelas e arvores salvas no banco.
- Os filtros de Resultados devem permitir propriedade, especie e um ou mais talhoes, de forma opcional e independente.
- Indicadores ja calculados com dados reais: arvores amostradas, area medida, DAP medio, altura media, parcelas coletadas/medidas, distribuicao diametrica e resumo por talhao.
- Volume estimado total permanece como `A calcular` ate a implementacao do motor de formulas, coeficientes e regra de extrapolacao validados.
