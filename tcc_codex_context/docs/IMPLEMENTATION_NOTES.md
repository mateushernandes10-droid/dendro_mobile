# IMPLEMENTATION_NOTES.md

Notas objetivas das decisoes feitas durante a implementacao.

## Terminologia

- Usar `levantamento` para o registro/servico como um todo.
- Usar `coleta` para a operacao de campo dentro de um levantamento.
- Evitar `contagem` na interface, nos avisos e nos documentos de regra.

## Novo levantamento

- O fluxo de novo levantamento deve abrir uma tela dedicada, nao um bottom sheet pequeno.
- A tela deve permitir busca digitada por nome da propriedade.
- A tela deve permitir filtros por municipio e especie.
- O mesmo fluxo deve poder ser aberto pela tela Inicio e pela aba Levantamentos.
- Talhoes com levantamento em andamento devem aparecer como `Em coleta`.
- Para talhoes em coleta, a acao deve ser `Continuar coleta`, evitando criar outro levantamento para o mesmo talhao.
- A tela deve permitir cadastrar rapidamente um novo talhao para uma propriedade e, depois do cadastro, iniciar o levantamento desse talhao.

## Coordenadas da parcela

- A escolha do ponto de referencia (`P1`, `P2`, `P3`, `P4`) deve aparecer somente quando o usuario aciona a captura de localizacao.
- Pontos ja capturados devem ter destaque visual diferente.
- Se o usuario tentar capturar novamente um ponto ja usado, o app deve pedir confirmacao antes de substituir.
- Ao substituir um ponto, o vinculo anterior deve ser removido para manter apenas um ponto ativo por referencia dentro da parcela.

## Levantamentos e resultados reais

- A aba Levantamentos deve listar dados reais de `InventoryRun`, incluindo levantamentos em andamento, concluidos e planejados.
- Cada card de levantamento deve abrir o detalhe real do levantamento e exibir propriedade, talhoes, status, arvores medidas, area medida e fracao de parcelas coletadas.
- A aba Resultados deve usar dados reais de parcelas e arvores salvas no banco.
- Os filtros de Resultados devem permitir propriedade, especie e um ou mais talhoes, de forma opcional e independente.
- Indicadores ja calculados com dados reais: arvores amostradas, area medida, DAP medio, altura media, parcelas coletadas/medidas, distribuicao diametrica e resumo por talhao.
- Volume estimado total permanece como `A calcular` ate a implementacao do motor de formulas, coeficientes e regra de extrapolacao validados.
