# Verificação do aplicativo e material para o manual

Atualização integral das capturas: 12/11/2026.

## Entrega

- Aplicativo compilado, instalado e executado no emulador **Dendro_Tablet_API_36**, Android API 36.
- **47 screenshots do fluxo**, em PNG, 1080 × 1920 e orientação vertical; mais **1 screenshot de diagnóstico** anterior à correção, separado do fluxo.
- Todas as imagens em `screenshots/` foram substituídas por capturas reais da compilação vigente.
- Todas as telas principais do roteiro estão representadas; telas extensas possuem capturas complementares depois da rolagem.

## Versão e banco utilizados

A versão vigente permanece no **schema 1**, com IDs inteiros, 14 tabelas declaradas no Drift e criação por `onCreate`. Não foram criadas migrações nem alterações no código para produzir as imagens.

O banco existente no emulador foi copiado antes da captura. Durante a sessão foram criados temporariamente uma parcela P13, uma árvore e um backup local para demonstrar os fluxos. Ao final, o banco original foi restaurado e o arquivo temporário de backup foi removido.

### Integridade da restauração

| Estado | SHA-256 |
|---|---|
| Banco antes das capturas | `086A5E7B1A8669D1774A5FE4AB5B317FE8D312DEF55D6FEEC0174CC3B22BE4C5` |
| Banco depois da restauração | `086A5E7B1A8669D1774A5FE4AB5B317FE8D312DEF55D6FEEC0174CC3B22BE4C5` |

A resolução física do tablet também foi restaurada para **2560 × 1600** depois de gerar as capturas padronizadas em 1080 × 1920.

## Dados visíveis nas capturas

- Propriedade: Fazenda esperana, Frederico/RS, 50 ha.
- Talhão: talhao 1, Pinus, 23,46 ha, plantio 2013 e parcela de referência 20 × 30 m.
- Levantamento concluído: 11 parcelas, 405 árvores e 0,66 ha medidos.
- Resultados exibidos: DAP médio 27,7 cm, altura média 22,3 m e volume estimado total de 9.943,82 m³.
- Suficiência nos resultados: erro atual 5,9%, limite salvo de 5,0%, 15 parcelas estimadas e 4 adicionais recomendadas.
- Coleta temporária: P13, uma árvore com DAP 25,0 cm e altura 20,0 m.
- Pontos GPS: nenhum ponto salvo.

Os números reproduzem os dados e coeficientes já cadastrados e não constituem validação agronômica dos modelos.

## Funções documentadas

- Abertura, início com e sem levantamento aberto e navegação principal.
- Propriedades e talhões, incluindo formulários e menus de ações.
- Espécies e modelos matemáticos: Fator de Forma, Modelo de Spurr e Schumacher-Hall.
- Novo levantamento, seleção de modelo e erro amostral máximo.
- Parcelas, coleta de árvores, tronco tortuoso, GPS opcional, edição e encerramento.
- Validação de suficiência amostral antes do encerramento e nos resultados.
- Resultados, distribuição diamétrica e filtros.
- Exportações PDF, CSV, XLSX/Excel e KML, além do seletor de salvamento do Android.
- Histórico, Backup e Restauração.

## Limitações e cuidados

1. **GPS:** a interface foi capturada, mas nenhuma coordenada foi salva. A mensagem atual orienta liberar a localização nas configurações do dispositivo.
2. **Expressões personalizadas:** o cadastro existe, mas não há avaliador genérico. Não descrever esse cadastro como garantia de cálculo arbitrário.
3. **Resultados:** exigem propriedade ou espécie como filtro base e podem agregar medições de mais de um levantamento.
4. **Área:** preencher e conferir as áreas das parcelas antes de interpretar extrapolações.
5. **Conclusão:** parcelas abertas são avisadas e excluídas dos cálculos; a suficiência é apresentada antes da decisão final.
6. **Exportações:** os formatos estão presentes na interface; nesta sessão foi aberto o seletor de salvamento, sem substituir arquivos já existentes.
7. **Cadastros opcionais e exclusões:** formulários e menus foram inspecionados e fechados sem criar registros permanentes.
8. **Escopo:** estimativa econômica, KMZ, backend e autenticação online não fazem parte da implementação documentada.

## Arquivos do material

- `FLUXO_MANUAL.md`: roteiro em 39 etapas, cuidados e fluxo resumido.
- `INDICE_CAPTURAS.md`: lista completa e links das 47 imagens.
- `SCREENSHOTS_PENDENTES.md`: observação específica sobre GPS.
- `RELATORIO_VERIFICACAO.md`: este relatório.
- `screenshots/*.png`: capturas reais e atualizadas do aplicativo e do seletor de salvamento.
- `diagnostico/01_abertura_erro.png`: falha anterior à correção; não usar como tela normal.
- `exportacoes/relatorio_fazenda_modelo.pdf`: exemplo anterior de relatório gerado pelo aplicativo.
