# Verificação do aplicativo e material para o manual

Data: 15/09/2026.

## Entrega

- Aplicativo compilado, instalado e executado no emulador **Dendro_API_36**, Android API 36.
- **38 screenshots do fluxo**, em PNG, 1080 × 1920, orientação vertical; mais **1 screenshot de diagnóstico** anterior à correção, separado do fluxo.
- Todas as 25 telas principais da solicitação estão representadas. Algumas são painéis ou partes de outras telas, conforme explicado no roteiro.
- Inventário fictício realizado: Fazenda Modelo, Talhao 01, Pinus, duas parcelas de 0,04 ha, seis árvores; parcelas e levantamento concluídos.
- Relatório PDF salvo pelo seletor nativo do Android, copiado sem alteração para esta pasta e conferido em suas duas páginas.

## Problema de inicialização e correção autorizada

A estrutura atual usa nomes em português e IDs inteiros, mas `schemaVersion` havia sido reduzido para **1** e a estratégia de atualização removida. O emulador ainda possuía um banco **versão 7**, com nomes legados em inglês e IDs textuais. A abertura não convertia esse banco para o esquema esperado e permanecia em **Tentar novamente**.

A correção eleva a versão para **12** e restabelece a migração de nomenclatura e identificadores. Ela copia os registros em ordem de dependência, remapeia as referências e verifica contagens e integridade referencial dentro de transação. Bancos que já possuem os IDs inteiros são reconhecidos para evitar conversão duplicada. Referências de atividades a entidades já excluídas ficam preservadas em um metadado legado.

Não foi necessário limpar os dados nem desinstalar o aplicativo. Uma cópia do banco anterior foi mantida fora do repositório, em `C:\Users\Hernandes\AppData\Local\Temp\dendro_manual_diagnostico\banco_original.sqlite`. Não foram alterados interface, cálculos ou coeficientes para produzir as imagens. A alteração de persistência se limita à correção de inicialização solicitada posteriormente pelo usuário.

### Arquivos de código e teste

- `lib/nucleo/banco/banco_dendro.dart`: versão e ligação da migração.
- `lib/nucleo/banco/migracao_nomenclatura.dart`: tradução de tabelas, colunas e valores legados.
- `lib/nucleo/banco/migracao_ids_inteiros.dart`: conversão e preservação das relações.
- `test/nucleo/banco/migracao_inicializacao_test.dart`: regressão da atualização/reabertura.
- `test/nucleo/banco/fixtures/esquema_v7.sql`: estrutura antiga, sem dados pessoais.

### Evidências de validação

- `flutter test`: **39 testes aprovados** na suíte completa.
- `flutter analyze`: **nenhum problema encontrado**.
- Teste adicional com `DENDRO_BANCO_DIAGNOSTICO`: abertura de uma cópia do banco real anterior e verificação das chaves estrangeiras, aprovado.
- Testes de banco: migração de esquema v7 com registros fictícios e preservação de medidas/relações/histórico; abertura do esquema inteiro marcado como versões 1 e 11; reabertura após migração.
- Execução real: cadastro → coleta → conclusão → resultados → exportação PDF; encerramento do processo e nova abertura com os dados preservados.

Essas verificações cobrem os cenários descritos, não todos os possíveis bancos de versões históricas nem todos os dispositivos Android.

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

## Limitações e cuidados para escrever o manual

1. **GPS:** interface e falha capturadas; sucesso pendente. Ver `SCREENSHOTS_PENDENTES.md`. Não há mapa independente nessa etapa.
2. **Modelos:** o catálogo legado preservado contém Spurr e Schumacher-Hall. A instalação nova inclui também Fator de Forma. Não foram acrescentados modelos ao banco legado para obter imagens.
3. **Expressões personalizadas:** o cadastro existe, mas não há avaliador genérico. Fórmulas desconhecidas podem seguir a rotina de Spurr; não descrever esse cadastro como garantia de cálculo arbitrário.
4. **Resultados:** exigem propriedade ou espécie como filtro base e podem agregar medições de mais de um levantamento. Para exportar um levantamento específico, entrar pelo seu detalhe.
5. **Área:** a lista de parcelas pode somar áreas planejadas; Resultados considera parcelas não pendentes. Preencher e conferir as áreas antes de interpretar extrapolações.
6. **Conclusão:** encerrar o levantamento não substitui a conferência e conclusão individual das parcelas. A interface permite confirmar mesmo quando há parcelas abertas.
7. **Exportações:** PDF foi salvo e conferido. As opções CSV, XLSX/Excel e KML foram identificadas na interface/código, mas seus arquivos não foram validados nesta execução. Nenhum arquivo foi enviado a terceiros.
8. **Cadastros opcionais e exclusões:** telas/menus foram inspecionados; não se afirma teste completo de todas as combinações de edição/exclusão. Os formulários de espécie e fórmula foram fechados sem criar registros extras.
9. **PDF:** preservado exatamente como gerado. Sem ano de plantio, idade e IMA ficam ausentes. O relatório tem duas páginas legíveis; a primeira linha de algumas tabelas de identificação usa estilo diferente das demais, comportamento do exportador atual.
10. **Navegação:** as abas preservam sua posição interna. Para voltar de uma tela de detalhe, usar a seta da própria interface. O botão Voltar do Android pode sair do aplicativo em situações observadas.
11. **Escopo:** estimativa econômica, KMZ, backend e autenticação online não fazem parte da implementação documentada.

## Arquivos do material

- `FLUXO_MANUAL.md`: roteiro em 32 etapas, dados fictícios, cuidados e fluxo resumido.
- `INDICE_CAPTURAS.md`: lista completa e links das 38 imagens, com seus estados.
- `SCREENSHOTS_PENDENTES.md`: instruções exatas para complementar o GPS.
- `RELATORIO_VERIFICACAO.md`: este relatório.
- `screenshots/*.png`: capturas reais do aplicativo e do seletor de salvamento.
- `diagnostico/01_abertura_erro.png`: falha anterior à correção.
- `exportacoes/relatorio_fazenda_modelo.pdf`: arquivo de exemplo gerado pelo aplicativo.

A documentação geral do TCC não foi alterada. Este material é a base visual e operacional solicitada para elaboração posterior do manual acadêmico.
