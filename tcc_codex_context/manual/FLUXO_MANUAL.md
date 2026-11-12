# Roteiro do manual — DENDRO Mobile

Verificação original: 15/09/2026. Atualização visual complementar: 12/11/2026. Base: código atual de `lib/`. Material para elaboração posterior do manual acadêmico.

## Situação da validação

O aplicativo foi compilado e executado no emulador Android Dendro_API_36, em orientação vertical, com capturas PNG de 1080 × 1920. Na sessão original de capturas foram cadastrados propriedade, talhão, levantamento, duas parcelas e seis árvores. As parcelas e o levantamento foram concluídos; resultados e salvamento de PDF foram conferidos. O aplicativo também foi reaberto com os dados preservados.

As imagens são capturas reais, sem montagem ou alteração da interface. A numeração identifica as telas; a ordem didática é a das etapas abaixo. Telas extensas têm capturas complementares após rolagem. O índice completo está em [INDICE_CAPTURAS.md](INDICE_CAPTURAS.md). A falha anterior foi separada em `diagnostico/01_abertura_erro.png`.

As imagens 33 a 40 complementam a sessão original e registram as funcionalidades posteriores de suficiência amostral e backup/restauração. Para tornar o cálculo visível, foi carregado temporariamente no emulador um conjunto validado de Pinus com 11 parcelas finalizadas e 405 árvores. O banco e a resolução do tablet foram restaurados exatamente ao estado anterior depois das capturas. Essas oito imagens não devem ser interpretadas como continuação do exemplo fictício de seis árvores descrito abaixo.

GPS: a interface foi capturada, mas a obtenção de coordenada não teve sucesso no emulador utilizado. Ver [SCREENSHOTS_PENDENTES.md](SCREENSHOTS_PENDENTES.md). Formulários opcionais de espécie/fórmula e menus de edição/exclusão foram inspecionados; isso não representa teste de todas as operações disponíveis.

## Versão vigente e origem das capturas

O projeto utiliza **schema 1, sem migrações legadas**. A alteração temporária para schema 12 foi revertida conforme o combinado. As imagens e o PDF foram preservados da sessão anterior; a interface e os cálculos permanecem iguais, mas uma instalação nova inclui também Fator de Forma no catálogo. O banco de demonstração está em backup e o emulador foi preparado com banco novo. Ver [RELATORIO_VERIFICACAO.md](RELATORIO_VERIFICACAO.md).

## Dados fictícios utilizados

Fazenda Modelo — Frederico Westphalen/RS — 50 ha; **Talhao 01** — Pinus — 10 ha; referência de parcelas de 20 × 20 m. A área foi preenchida explicitamente como **0,04 ha** em cada parcela. Nomes gerados pelo aplicativo: **P01** e **P02**; três árvores em cada uma.

| Parcela | Árvore 1: DAP/altura | Árvore 2: DAP/altura | Árvore 3: DAP/altura |
|---|---|---|---|
| P01 | 25 cm / 20 m | 28 cm / 22 m | 30 cm / 23 m |
| P02 | 24 cm / 19 m | 27 cm / 21 m | 29 cm / 22 m |

Modelo utilizado: Spurr, com os coeficientes já existentes no catálogo migrado: `a = 0,0175858265880592` e `b = 0,0000329326161133665`. Esses valores servem apenas para reproduzir esta demonstração. Ano de plantio não informado; nenhum ponto GPS salvo.

As imagens registram momentos diferentes da mesma demonstração: parcelas pendentes, coleta parcial e conclusão. A imagem 02 mostra o Início **após a conclusão**, sem coleta aberta; seus indicadores zerados não significam que os dados do levantamento foram apagados. A imagem 04 foi refeita preenchendo o formulário e cancelando, para não duplicar a propriedade já cadastrada.

## 1. Abrir o aplicativo

- **Objetivo:** Abrir o aplicativo.
- **Tela:** Abertura.
- **Screenshot:** `screenshots/01_abertura.png`.
- **Ações:** Abrir DENDRO Mobile e aguardar a inicialização.
- **Resultado esperado:** Exibir Início após preparar o banco e os recursos.

## 2. Conhecer a navegação

- **Objetivo:** Conhecer a navegação.
- **Tela:** Início.
- **Screenshots:** `screenshots/02_inicio.png` (sem levantamento aberto) e `screenshots/02b_inicio_levantamento_aberto.png` (com levantamento em andamento).
- **Estados do Início:** sem coleta aberta, iniciar em Novo Levantamento; com levantamento aberto, usar Continuar Coleta para retomar. Novo Levantamento continua disponível nos dois estados. A imagem 02b foi capturada no schema 1, com um levantamento recém-iniciado e ainda sem árvores medidas.
- **Ações:** Usar as abas Início, Levant., Propr., Result. e Ajustes. Para retomar, usar Continuar Coleta.
- **Resultado esperado:** Retomar o levantamento ativo sugerido ou navegar entre os módulos.

## 3. Ajustar aparência

- **Objetivo:** Ajustar aparência.
- **Tela:** Ajustes.
- **Screenshot:** `screenshots/25_ajustes.png`.
- **Ações:** Abrir Ajustes e consultar Preferências de tema e atalhos de Cadastros.
- **Resultado esperado:** Escolher preferência de aparência.

## 4. Conferir espécies

- **Objetivo:** Conferir espécies.
- **Tela:** Cadastro de espécies.
- **Screenshot:** `screenshots/08_especies.png`.
- **Ações:** Abrir Ajustes → Cadastro de espécies. Conferir Pinus e seus vínculos de fórmulas. Tocar no cartão de Pinus para expandir os vínculos; expandir Spurr para conferir coeficientes e a estrela de modelo padrão (imagem 08b).
- **Resultado esperado:** Identificar a configuração usada como padrão para a espécie.

## 5. Conferir modelos

- **Objetivo:** Conferir modelos.
- **Tela:** Modelos matemáticos.
- **Screenshot:** `screenshots/09_modelos_matematicos.png`.
- **Ações:** Abrir Ajustes → Modelos matemáticos. Consultar fórmulas, variáveis e símbolos.
- **Resultado esperado:** Conhecer os modelos cadastrados. Cadastro de expressão não garante que ela seja calculada genericamente.

## 6. Consultar propriedades

- **Objetivo:** Consultar propriedades.
- **Tela:** Propriedades.
- **Screenshot:** `screenshots/03_propriedades.png`.
- **Ações:** Abrir Propr. Usar busca e Filtros quando necessário.
- **Resultado esperado:** Localizar Fazenda Modelo.

## 7. Cadastrar propriedade

- **Objetivo:** Cadastrar propriedade.
- **Tela:** Nova propriedade (painel).
- **Screenshot:** `screenshots/04_nova_propriedade.png`.
- **Ações:** Em Propr., tocar em Nova propriedade (+). Informar Fazenda Modelo, Frederico Westphalen, RS e 50 ha; confirmar o cadastro.
- **Resultado esperado:** Propriedade aparece na lista.

## 8. Consultar a propriedade

- **Objetivo:** Consultar a propriedade.
- **Tela:** Detalhe da propriedade.
- **Screenshot:** `screenshots/05_detalhe_propriedade.png`.
- **Ações:** Abrir Fazenda Modelo na lista.
- **Resultado esperado:** Consultar os dados da propriedade e seus talhões.

## 9. Cadastrar talhão

- **Objetivo:** Cadastrar talhão.
- **Tela:** Novo talhão (painel).
- **Screenshot:** `screenshots/06_novo_talhao.png`.
- **Ações:** Na propriedade, tocar em Novo talhão. Informar Talhao 01, Pinus e 10 ha. Preencher dimensões de parcela de 20 × 20 m e salvar. Ano, espaçamento, manejo e observação são opcionais.
- **Resultado esperado:** Talhão cadastrado na propriedade; dimensões servem de referência para parcelas.

## 10. Consultar e editar talhões

- **Objetivo:** Consultar e editar talhões.
- **Tela:** Detalhe da propriedade / ações do talhão.
- **Screenshot:** `screenshots/07_talhoes.png`.
- **Ações:** Consultar o cartão de Talhao 01. Usar Ações para editar seu cadastro; abrir o talhão para consultar parcelas.
- **Resultado esperado:** Cadastro permanente consultável; edição disponível em painel.

## 11. Consultar levantamentos

- **Objetivo:** Consultar levantamentos.
- **Tela:** Levantamentos.
- **Screenshot:** `screenshots/10_levantamentos.png`.
- **Ações:** Abrir Levant. e consultar os cartões; tocar no levantamento desejado.
- **Resultado esperado:** Abrir o detalhe do evento selecionado.

## 12. Iniciar levantamento

- **Objetivo:** Iniciar levantamento.
- **Tela:** Novo levantamento.
- **Screenshot:** `screenshots/11_novo_levantamento.png`.
- **Ações:** Em Levant., tocar em Novo levantamento (+). Localizar Fazenda Modelo e Talhao 01; conferir a configuração antes de iniciar.
- **Resultado esperado:** Selecionar o talhão que será medido.

## 13. Selecionar modelo e coeficientes

- **Objetivo:** Selecionar modelo e coeficientes.
- **Tela:** Ajustar modelo matemático (painel).
- **Screenshot:** `screenshots/12_configuracao_modelo.png`.
- **Ações:** No talhão da tela Novo levantamento, tocar em Ajustar modelo matemático. Selecionar um modelo vinculado à espécie, conferir coeficientes e tocar em Usar este modelo. Então iniciar o talhão.
- **Resultado esperado:** Salvar a seleção no contexto do talhão do levantamento. Sem ajuste, usar o padrão da espécie. Rolar o painel se necessário para conferir todos os coeficientes.

## 14. Consultar e associar talhões

- **Objetivo:** Consultar e associar talhões.
- **Tela:** Levantamento.
- **Screenshot:** `screenshots/13_detalhe_levantamento.png`.
- **Ações:** Abrir o evento em Levant. Para incluir outro talhão da mesma propriedade, iniciá-lo em Novo levantamento; o repositório reutiliza o levantamento em andamento mais recente dessa propriedade.
- **Resultado esperado:** Visualizar talhões vinculados. Talhão já ativo direciona ao evento existente.

## 15. Consultar parcelas

- **Objetivo:** Consultar parcelas.
- **Tela:** Parcelas.
- **Screenshot:** `screenshots/14_parcelas.png`.
- **Ações:** No detalhe do levantamento em andamento, rolar até Talhao 01 e tocar em Abrir parcelas (imagem 13b).
- **Resultado esperado:** Listar parcelas do talhão naquele evento.

## 16. Cadastrar ou editar parcela

- **Objetivo:** Cadastrar ou editar parcela.
- **Tela:** Cadastrar parcela / Editar área (painel).
- **Screenshot:** `screenshots/15_nova_parcela.png`.
- **Ações:** Em Parcelas, tocar em Nova parcela (+). Conferir identificação automática e preencher a área de 0,04 ha; cadastrar. Repetir para a segunda parcela. Para corrigir, usar Ações → Editar área.
- **Resultado esperado:** Duas parcelas de 400 m²; identificação não é editável no formulário.

## 17. Abrir coleta

- **Objetivo:** Abrir coleta.
- **Tela:** Coleta da parcela.
- **Screenshot:** `screenshots/16_coleta_arvores.png`.
- **Ações:** Abrir uma parcela pelo levantamento em andamento. Tocar em Nova árvore quando o formulário estiver recolhido.
- **Resultado esperado:** Disponibilizar DAP e altura para uma árvore.

## 18. Registrar árvores

- **Objetivo:** Registrar árvores.
- **Tela:** Coleta da parcela.
- **Screenshot:** `screenshots/17_arvore_registrada.png`.
- **Ações:** Informar DAP 25 cm e altura 20 m; Salvar. Usar Próxima para salvar e continuar a sequência. Acrescentar 28 cm/22 m e 30 cm/23 m. Na segunda parcela, usar 24 cm/19 m, 27 cm/21 m e 29 cm/22 m.
- **Resultado esperado:** Árvores numeradas automaticamente dentro de cada parcela e medidas exibidas na lista.

## 19. Capturar coordenada opcional

- **Objetivo:** Capturar coordenada opcional.
- **Tela:** Seleção do ponto de referência GPS (painel na coleta).
- **Screenshot:** `screenshots/18_gps.png`.
- **Ações:** No formulário da árvore, tocar em Capturar coordenada; escolher ponto de referência e Capturar. Conceder localização se solicitado; salvar a árvore com a coordenada.
- **Resultado esperado:** Quando a localização estiver disponível, registrar coordenada e referência; ponto já ocupado permite confirmação de substituição. Nesta execução, a captura falhou (imagem 18b), portanto o sucesso permanece pendente.

## 20. Editar ou excluir árvore

- **Objetivo:** Editar ou excluir árvore.
- **Tela:** Coleta da parcela / Ações.
- **Screenshot:** `screenshots/28_acoes_arvore.png`.
- **Ações:** Durante o levantamento ativo, abrir Ações na árvore → Editar, ajustar medidas e Salvar. Para exclusão, usar Excluir e ler a confirmação.
- **Resultado esperado:** Atualizar ou remover o registro selecionado.

## 21. Encerrar parcela

- **Objetivo:** Encerrar parcela.
- **Tela:** Coleta da parcela / Parcelas.
- **Screenshot:** `screenshots/19_parcela_coletada.png`.
- **Ações:** Conferir árvores, tocar em Encerrar parcela e confirmar Encerrar. Repetir na outra parcela.
- **Resultado esperado:** Marcar parcela como coletada, atualizar contadores e retornar automaticamente à lista de parcelas. A confirmação aparece na imagem 19a; a imagem 19 mostra as duas parcelas coletadas após concluir também o levantamento.

## 22. Concluir levantamento

- **Objetivo:** Concluir levantamento.
- **Tela:** Encerrar levantamento (diálogo).
- **Screenshots:** `screenshots/29_encerrar_levantamento.png` (registro histórico) e `screenshots/34_suficiencia_encerramento.png` (fluxo atual).
- **Ações:** Após encerrar as parcelas, abrir o detalhe do levantamento e acionar encerramento; conferir erro atual, erro máximo desejado, parcelas estimadas, recomendação adicional e situação. Confirmar somente após avaliar esses dados.
- **Resultado esperado:** Sempre apresentar a suficiência amostral antes da decisão final. Parcelas abertas são avisadas e desconsideradas dos cálculos; ainda é possível finalizar mediante confirmação.

## 23. Consultar parcela concluída

- **Objetivo:** Consultar parcela concluída.
- **Tela:** Detalhes da parcela (painel).
- **Screenshot:** `screenshots/30_detalhes_parcela.png`.
- **Ações:** Após concluir o evento, abrir seu talhão e a parcela.
- **Resultado esperado:** Consultar o resumo e, após rolagem, as árvores e os pontos GPS (imagem 30b).

## 24. Consultar resultados

- **Objetivo:** Consultar resultados.
- **Tela:** Resultados.
- **Screenshot:** `screenshots/20_resultados.png`.
- **Ações:** Abrir Result. e selecionar Fazenda Modelo ou Pinus como filtro base; selecionar Talhao 01.
- **Resultado esperado:** Exibir indicadores e classes de diâmetro (imagem 20b). Nesta demonstração: 6 árvores, 0,08 ha medidos, DAP médio 27,2 cm, altura média 21,2 m e volume estimado de 405,10 m³ para o talhão de 10 ha.

## 25. Filtrar resultados

- **Objetivo:** Filtrar resultados.
- **Tela:** Resultados / filtros.
- **Screenshot:** `screenshots/21_filtros_resultados.png`.
- **Ações:** Alterar Propriedade, Espécie e seleção de Talhões. Conferir os filtros antes de interpretar os números.
- **Resultado esperado:** Atualizar o recorte. Sem propriedade nem espécie, o painel não carrega medições.

## 26. Preparar exportação

- **Objetivo:** Preparar exportação.
- **Tela:** Exportar.
- **Screenshot:** `screenshots/22_exportacao.png`.
- **Ações:** Para exportar um evento específico, abrir Levant. → evento → exportação. Escolher formato e marcar ao menos um talhão.
- **Resultado esperado:** Preparar seleção de dados do levantamento escolhido.

## 27. Salvar arquivo

- **Objetivo:** Salvar arquivo.
- **Tela:** Exportar / seletor de destino do Android.
- **Screenshot:** `screenshots/23_salvar_exportacao.png`.
- **Ações:** Rolar até as ações; usar Salvar no aparelho e escolher destino. Conferir mensagem de sucesso e abrir o arquivo salvo.
- **Resultado esperado:** Arquivo gerado no destino; cancelamento é informado separadamente.

## 28. Consultar atividades

- **Objetivo:** Consultar atividades.
- **Tela:** Historico de atividades.
- **Screenshot:** `screenshots/24_historico.png`.
- **Ações:** Abrir Início → Atividades recentes → Ver todas.
- **Resultado esperado:** Consultar registros das operações efetuadas.

## 29. Cadastrar ou editar espécie

- **Objetivo:** Cadastrar ou editar espécie.
- **Tela:** Nova espécie / edição (painel).
- **Screenshot:** `screenshots/26_cadastro_especie.png`.
- **Ações:** Em Cadastro de espécies, usar Nova espécie ou Ações → Editar. Informar nome, nome científico opcional e observação; salvar quando necessário.
- **Resultado esperado:** Manter cadastro de espécie consultável.

## 30. Consultar cadastro de fórmula

- **Objetivo:** Consultar cadastro de fórmula.
- **Tela:** Nova fórmula / edição (painel).
- **Screenshot:** `screenshots/27_cadastro_formula.png`.
- **Ações:** Em Modelos matemáticos, abrir Nova fórmula ou a edição de um modelo; consultar nome, fórmula, símbolos e descrição.
- **Resultado esperado:** Conhecer os campos de cadastro, sem pressupor execução de expressão arbitrária.

## 31. Usar atalho inicial

- **Objetivo:** Usar atalho inicial.
- **Tela:** Novo levantamento (acesso pelo Início).
- **Screenshot:** `screenshots/31_atalho_inicio.png`.
- **Ações:** Em Início, tocar em Novo Levantamento; escolher propriedade e talhão. Conferir ajuste de modelo antes de iniciar.
- **Resultado esperado:** Abrir a mesma tela Novo levantamento utilizada pela aba Levant.; o atalho não cria um levantamento automaticamente.

## 32. Conferir opções adicionais de exportação

- **Objetivo:** Conferir opções adicionais de exportação.
- **Tela:** Exportar (parte inferior).
- **Screenshot:** `screenshots/32_opcoes_exportacao.png`.
- **Ações:** Rolar a tela Exportar para consultar formatos, seleção de talhões e ações. Compartilhar arquivo abre o compartilhamento do sistema.
- **Resultado esperado:** Disponibilizar arquivo ao seletor de compartilhamento; selecionar destinatário é uma ação posterior do usuário.

## 33. Conferir o erro amostral configurado

- **Objetivo:** Identificar o limite usado na avaliação da amostragem.
- **Telas:** Cadastro do talhão e detalhe do levantamento.
- **Screenshots:** `screenshots/40_erro_amostral_cadastro_talhao.png` e `screenshots/33_erro_amostral_configuracao.png`.
- **Ações:** Em Novo levantamento, tocar em Novo talhão e conferir o campo Erro amostral máximo (%). Depois, abrir o levantamento em andamento e localizar o cartão do talhão.
- **Resultado esperado:** Preencher inicialmente 3,0% no cadastro e exibir o mesmo limite no cartão do talhão após a configuração.

## 34. Avaliar a suficiência antes de encerrar

- **Objetivo:** Conferir se a quantidade de parcelas atende ao erro desejado.
- **Tela:** Suficiência amostral (diálogo).
- **Screenshot:** `screenshots/34_suficiencia_encerramento.png`.
- **Ações:** No detalhe do levantamento, tocar em Encerrar levantamento. Ler todos os indicadores antes de cancelar ou finalizar.
- **Resultado esperado:** Exibir parcelas registradas e utilizadas, erro atual, erro máximo, confiança de 95%, parcelas estimadas, adicionais e situação.

## 35. Consultar a suficiência nos resultados

- **Objetivo:** Acompanhar a avaliação sem encerrar o levantamento.
- **Tela:** Resultados, após selecionar propriedade ou espécie e o talhão.
- **Screenshot:** `screenshots/35_suficiencia_resultados.png`.
- **Ações:** Abrir Result., selecionar Pinus e rolar até Suficiência amostral.
- **Resultado esperado:** Repetir os indicadores calculados apenas com parcelas finalizadas e informar se a amostragem é suficiente.

## 36. Abrir Backup e Restauração

- **Objetivo:** Acessar as ferramentas locais de proteção dos dados.
- **Tela:** Ajustes.
- **Screenshot:** `screenshots/36_ajustes_backup.png`.
- **Ações:** Abrir Ajustes e tocar em Backup e Restauração.
- **Resultado esperado:** Acessar criação, compartilhamento e restauração de cópias completas do banco.

## 37. Consultar backups locais

- **Objetivo:** Conferir as cópias existentes no dispositivo.
- **Tela:** Backup e Restauração.
- **Screenshot:** `screenshots/37_backup_restauracao.png`.
- **Ações:** Ler o aviso sobre desinstalação e consultar a lista de backups salvos.
- **Resultado esperado:** Mostrar data, tamanho e nome de cada arquivo `.dendrobackup`, além das ações de criar e restaurar.

## 38. Criar e compartilhar um backup

- **Objetivo:** Produzir uma cópia transportável dos dados.
- **Tela:** Confirmação de backup criado.
- **Screenshot:** `screenshots/38_backup_criado.png`.
- **Ações:** Tocar em Criar novo backup; depois escolher Agora não ou Compartilhar.
- **Resultado esperado:** Salvar a cópia no armazenamento do aplicativo e oferecer compartilhamento para mantê-la fora do app.

## 39. Confirmar uma restauração

- **Objetivo:** Entender o efeito da restauração antes de executá-la.
- **Tela:** Confirmação de restauração.
- **Screenshot:** `screenshots/39_confirmacao_restauracao.png`.
- **Ações:** Selecionar Restaurar de um arquivo e ler a confirmação. No roteiro de captura, a operação foi cancelada.
- **Resultado esperado:** Avisar que os dados atuais serão substituídos e que o aplicativo criará uma cópia preventiva antes da restauração.

## Relação entre telas e fluxo real

A lista de talhões está incorporada ao detalhe da propriedade e ao detalhe do levantamento. Cadastro/edição de propriedade, talhão, parcela, espécie e fórmula usam painéis. A edição de parcela altera a área, com identificação somente leitura. GPS usa painel na coleta, sem mapa independente identificado. Confirmações de encerramento e exclusão são diálogos; salvar e compartilhar utilizam também interfaces do Android.

## Cuidados da implementação atual

- O início por outro talhão da mesma propriedade reutiliza o levantamento em andamento mais recente; não equivale necessariamente a criar um evento independente. Talhão já ativo retorna ao evento existente.
- É possível planejar parcelas pelo cadastro do talhão antes de iniciar o levantamento; o início aproveita planejamento com parcelas. Para coletar, entrar pelo levantamento em andamento.
- Encerrar levantamento altera seu estado, mas não encerra automaticamente cada parcela no repositório. A interface permite confirmar encerramento mesmo com parcelas abertas ou sem parcelas. Conferir as parcelas antes de concluir.
- Resultados exigem propriedade ou espécie como filtro base. A consulta não filtra por um único levantamento nem somente por eventos concluídos; pode somar medições históricas. Para exportar um evento específico, partir do detalhe desse levantamento.
- O resumo inicial representa o levantamento ativo sugerido. Na lista de parcelas, a área exibida pode incluir parcelas ainda pendentes; na tela Resultados, a área medida considera parcelas não pendentes.
- Área amostrada é necessária para extrapolação por hectare/talhão. Parcelas não pendentes entram na área medida; não interpretar dados de demonstração como validação técnica.
- Spurr, Schumacher-Hall e Fator de Forma têm rotinas implementadas. Existe cadastro de expressões, mas não um avaliador genérico; expressões não reconhecidas podem seguir o caminho de Spurr. Não ensinar fórmulas arbitrárias como funcionalidade calculável validada.
- Há valores padrão no calculador para Spurr/Schumacher-Hall e estimativa de altura; a coleta exige medidas válidas. Os padrões existentes não comprovam adequação à espécie/região. Não foram alterados coeficientes nem fórmulas.
- A expressão implementada de Fator de Forma é `(pi / 4) * (D / 100)^2 * H * ff`, usando a área basal circular calculada a partir do DAP. O fator `ff` deve ser tecnicamente definido para o contexto do levantamento.
- Exportações disponíveis: Relatório PDF; Dados e resultados (CSV); Dados brutos (CSV); Dados brutos (XLSX); Planilha (Excel); Coordenadas (Google Earth/KML). KMZ e estimativa econômica não estão implementados.
- O catálogo das capturas anteriores contém Spurr e Schumacher-Hall. A instalação nova do schema 1 inclui também Fator de Forma. Não usar essas imagens como lista completa do catálogo inicial atual.
- GPS depende de serviço de localização e permissão; pontos são documentação geográfica, não medição topográfica validada. A substituição de referência ocupada exige confirmação.
- Menus permitem exclusões com confirmação. Excluir parcela remove árvores/coordenadas vinculadas; remover talhão do levantamento remove seus dados naquele evento, preservando o cadastro do talhão na propriedade.

## Fluxo resumido

Abertura → Início → conferir espécies/modelos em Ajustes → Propriedade → Talhão → Novo levantamento → ajustar modelo/coeficientes e erro máximo → iniciar e vincular talhão → Parcelas → Coleta de árvores (+ GPS opcional) → conferir/editar registros → encerrar parcelas → avaliar suficiência → encerrar levantamento → consultar Resultados com filtros → Exportar → Backup e Restauração → consultar Histórico.

Alternativa: Propriedade → Talhão → planejar parcelas → iniciar levantamento e aproveitar planejamento. O atalho Novo Levantamento do Início também permite selecionar propriedade/talhão.

## Atualização das imagens do catálogo

As capturas `09_modelos_matematicos.png` e `08b_modelos_especie.png` foram substituídas por novas imagens reais do schema 1, em 1080 × 1920. Agora mostram Fator de Forma, Modelo de Spurr e Schumacher-Hall. No cadastro de Pinus, os três aparecem vinculados e Spurr permanece como padrão. Nenhuma configuração ou código foi alterado para a captura. As observações anteriores sobre catálogo incompleto aplicam-se às imagens históricas ainda não substituídas, especialmente a imagem 12 da seleção no levantamento.
