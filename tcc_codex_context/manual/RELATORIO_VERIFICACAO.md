# Verificação do aplicativo e material para o manual

Verificação original: 15/09/2026. Atualização visual complementar: 12/11/2026.

## Entrega

- Aplicativo compilado, instalado e executado no emulador **Dendro_API_36**, Android API 36.
- **46 screenshots do fluxo**, em PNG, 1080 × 1920, orientação vertical; mais **1 screenshot de diagnóstico** anterior à correção, separado do fluxo.
- Todas as 25 telas principais da solicitação estão representadas. Algumas são painéis ou partes de outras telas, conforme explicado no roteiro.
- Inventário fictício realizado: Fazenda Modelo, Talhao 01, Pinus, duas parcelas de 0,04 ha, seis árvores; parcelas e levantamento concluídos.
- Relatório PDF salvo pelo seletor nativo do Android, copiado sem alteração para esta pasta e conferido em suas duas páginas.

## Inicialização e decisão vigente do banco

A versão vigente é **schema 1**, com IDs inteiros, 14 tabelas declaradas no Drift e criação por `onCreate`. Não há migração de bancos das versões experimentais anteriores.

A falha inicial ocorreu porque o emulador mantinha um banco antigo, versão 7, incompatível com essa estrutura. Durante a produção das imagens foi introduzido indevidamente um schema 12 com migrações. Essa alteração foi revertida para respeitar a decisão anterior do projeto. Os arquivos de migração, seus testes e a fixture antiga foram removidos.

Para verificar a instalação atual, o banco de demonstração foi preservado fora do repositório, em uma pasta local de backup, com integridade SQLite conferida e seis árvores. Também permanece separado no armazenamento interno do aplicativo. O aplicativo cria um banco novo no caminho normal, sem converter ou sobrescrever esse backup. Não se deve reapresentar o schema 12 como versão vigente no TCC.

### Validação após restaurar o combinado

- `flutter test`: **44 testes aprovados** na verificação mais recente.
- `flutter analyze`: **nenhum problema encontrado**.
- Compilação e abertura no emulador com um banco novo: conferidas após a restauração do schema 1.
- A suíte existente verifica criação/integridade do banco, cálculos, exportação e fluxos de interface.

### Proveniência do material visual

As 38 capturas e o PDF abaixo foram produzidos antes desta reversão, usando os dados fictícios do banco de demonstração. Foram preservados como material do fluxo observado; não são evidência de uma nova execução completa no schema 1. A interface e os cálculos não foram alterados nesta reversão.

O catálogo dessas imagens contém somente Spurr e Schumacher-Hall; uma instalação nova do schema 1 também inclui Fator de Forma. Essa diferença deve ser considerada ao montar o manual. O emulador passa a abrir com banco novo; os dados anteriores estão nos backups, não no banco ativo.

## Resultado observado

| Indicador | Resultado |
|---|---:|
| Área da propriedade | 50 ha |
| Área do talhão | 10 ha |
| Área amostrada | 0,08 ha |
| Parcelas coletadas | 2/2 |
| Árvores | 6 |
| DAP médio | 27,17 cm no PDF |
| Altura média | 21,17 m no PDF |
| Volume amostrado | 3,2408 m³ |
| Volume por hectare | 40,51 m³/ha |
| Volume estimado no talhão | 405,10 m³ |
| Pontos GPS | 0 |

Os números reproduzem os dados fictícios e os coeficientes já cadastrados; não constituem validação agronômica dos modelos. A interface arredonda alguns indicadores com menos casas decimais que o PDF.

## Telas e funções complementares encontradas

- Expansão da espécie para vincular modelos, definir o padrão pela estrela e conferir coeficientes.
- Formulários de espécie e fórmula, com símbolos de coeficientes e variáveis.
- Menus de edição/exclusão de árvores e talhões.
- Confirmações separadas para encerrar parcela e levantamento.
- Painel de detalhes da parcela após a conclusão.
- Distribuição diamétrica nos resultados.
- Atalho Novo Levantamento no Início, que abre a mesma tela de criação da aba Levant.
- Seleção dos talhões exportados e ações Salvar no aparelho / Compartilhar arquivo.
- Configuração do erro amostral, avaliação de suficiência no encerramento e cartão correspondente nos resultados.
- Criação, compartilhamento e confirmação de restauração de backup completo.

## Limitações e cuidados para escrever o manual

1. **GPS:** interface e falha capturadas; sucesso pendente. Ver `SCREENSHOTS_PENDENTES.md`. Não há mapa independente nessa etapa.
2. **Modelos:** o catálogo legado preservado contém Spurr e Schumacher-Hall. A instalação nova inclui também Fator de Forma. Não foram acrescentados modelos ao banco legado para obter imagens.
3. **Expressões personalizadas:** o cadastro existe, mas não há avaliador genérico. Fórmulas desconhecidas podem seguir a rotina de Spurr; não descrever esse cadastro como garantia de cálculo arbitrário.
4. **Resultados:** exigem propriedade ou espécie como filtro base e podem agregar medições de mais de um levantamento. Para exportar um levantamento específico, entrar pelo seu detalhe.
5. **Área:** a lista de parcelas pode somar áreas planejadas; Resultados considera parcelas não pendentes. Preencher e conferir as áreas antes de interpretar extrapolações.
6. **Conclusão:** encerrar o levantamento não substitui a conferência e conclusão individual das parcelas. Parcelas abertas são avisadas e excluídas dos cálculos; a suficiência é sempre apresentada antes da decisão final.
7. **Exportações:** PDF foi salvo e conferido. As opções CSV, XLSX/Excel e KML foram identificadas na interface/código, mas seus arquivos não foram validados nesta execução. Nenhum arquivo foi enviado a terceiros.
8. **Cadastros opcionais e exclusões:** telas/menus foram inspecionados; não se afirma teste completo de todas as combinações de edição/exclusão. Os formulários de espécie e fórmula foram fechados sem criar registros extras.
9. **PDF:** preservado exatamente como gerado. Sem ano de plantio, idade e IMA ficam ausentes. O relatório tem duas páginas legíveis; a primeira linha de algumas tabelas de identificação usa estilo diferente das demais, comportamento do exportador atual.
10. **Navegação:** as abas preservam sua posição interna. Para voltar de uma tela de detalhe, usar a seta da própria interface. O botão Voltar do Android pode sair do aplicativo em situações observadas.
11. **Escopo:** estimativa econômica, KMZ, backend e autenticação online não fazem parte da implementação documentada.

## Arquivos do material

- `FLUXO_MANUAL.md`: roteiro em 39 etapas, dados fictícios, cuidados e fluxo resumido.
- `INDICE_CAPTURAS.md`: lista completa e links das 46 imagens, com seus estados.
- `SCREENSHOTS_PENDENTES.md`: instruções exatas para complementar o GPS.
- `RELATORIO_VERIFICACAO.md`: este relatório.
- `screenshots/*.png`: capturas reais do aplicativo e do seletor de salvamento.
- `diagnostico/01_abertura_erro.png`: falha anterior à correção.
- `exportacoes/relatorio_fazenda_modelo.pdf`: arquivo de exemplo gerado pelo aplicativo.

A documentação geral do TCC não foi alterada. Este material é a base visual e operacional solicitada para elaboração posterior do manual acadêmico.

## Atualização das imagens do catálogo

As capturas `09_modelos_matematicos.png` e `08b_modelos_especie.png` foram substituídas por novas imagens reais do schema 1, em 1080 × 1920. Agora mostram Fator de Forma, Modelo de Spurr e Schumacher-Hall. No cadastro de Pinus, os três aparecem vinculados e Spurr permanece como padrão. Nenhuma configuração ou código foi alterado para a captura. As observações anteriores sobre catálogo incompleto aplicam-se às imagens históricas ainda não substituídas, especialmente a imagem 12 da seleção no levantamento.

## Complemento: Início com levantamento aberto

Adicionada `screenshots/02b_inicio_levantamento_aberto.png`, captura real no schema 1 em 1080 × 1920. Foram cadastrados pela interface Fazenda Modelo (50 ha), Talhao 01 (Pinus, 10 ha, parcelas de referência 20 × 20 m) e um levantamento em andamento, sem árvores medidas. A imagem mostra Novo Levantamento e Continuar Coleta. A imagem 02 anterior, sem coleta aberta, foi mantida para comparação. Não houve alteração de código ou do esquema do banco.

## Complemento de 12/11/2026: suficiência e backup

Foram adicionadas as imagens 33 a 39, todas reais e em 1080 × 1920. As telas 33 a 35 usam temporariamente um conjunto validado de Pinus com 11 parcelas finalizadas, 405 árvores, erro atual de 5,9% e limite desejado de 3,0%. As telas 36 a 39 documentam Ajustes, Backup e Restauração, confirmação da criação e aviso anterior à restauração. A restauração não foi confirmada. O backup criado apenas para a captura foi removido e o banco do emulador foi devolvido ao estado anterior, com igualdade SHA-256 entre a cópia anterior e o banco restaurado.
