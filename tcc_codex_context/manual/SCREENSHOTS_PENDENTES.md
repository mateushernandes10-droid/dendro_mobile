# Captura complementar pendente — GPS

As 25 telas principais solicitadas foram capturadas. A interface de GPS está em `screenshots/18_gps.png`; falta demonstrar uma **captura bem-sucedida de coordenada**.

## Coordenada registrada

- **Tela:** Coleta da parcela, formulário da árvore e resumo de pontos GPS.
- **Caminho:** Levant. → levantamento em andamento → talhão → Abrir parcelas → parcela → Nova árvore ou Ações da árvore → Editar → ícone de localização → selecionar P1 → Capturar.
- **Dados:** usar uma propriedade fictícia, talhão Pinus, parcela de 0,04 ha e árvore com DAP 25 cm e altura 20 m. A demonstração entregue já está concluída; para esta captura, usar um novo levantamento de teste. Identificá-lo claramente para não confundir seus resultados com o exemplo entregue.
- **Pré-condição:** serviço de localização ativo e permissão concedida ao aplicativo. Em emulador, disponibilizar localização simulada e verificar se o serviço a entrega; em aparelho, usar local de teste apropriado. Não inserir coordenadas diretamente no banco para simular sucesso.
- **Estado esperado:** coordenada capturada, árvore salva com referência P1 e contador de pontos GPS atualizado. Evitar capturar a localização de residência ou outro endereço pessoal.
- **Arquivo recomendado:** `screenshots/18c_gps_registrado.png`.
- **Verificação complementar:** reabrir a parcela e conferir a referência/coordenada persistida. Exportar Coordenadas (Google Earth) somente depois de haver pontos e verificar o KML em ferramenta compatível.

## O que ocorreu nesta execução

No Android API 36, a localização simulada foi enviada ao emulador e a permissão de localização foi concedida. A oferta opcional de Google Location Accuracy não foi ativada. O aplicativo exibiu **“Não foi possível capturar a localização agora.”**, registrada em `screenshots/18b_gps_indisponivel.png`.

A coleta prosseguiu sem coordenadas, como permitido pela interface. Isso não comprova falha de GPS em aparelhos físicos. Captura bem-sucedida, substituição de P1–P4 e conteúdo geográfico exportado permanecem sem validação operacional nesta tarefa.
