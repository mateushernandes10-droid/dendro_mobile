# Estado da implementação e evidências

Revisão documental em 13/09/2026, versão refatorada em português (base 82f29e2). Os documentos foram alinhados à versão atual por solicitação do usuário, que encerrou o escopo de desenvolvimento. Esta revisão não altera o código do aplicativo.

## Implementação disponível

- Propriedades e talhões, com cadastro de propriedade também em Novo levantamento.
- Planejamento de parcelas, início/retomada de coletas, agrupamento de talhões no levantamento ativo da propriedade, conclusão e exclusões.
- Registro sequencial de árvores com DAP cm, altura m, tronco torto e GPS opcional com referência de parcela.
- Catálogos de espécies/modelos e coeficientes por espécie e talhão do levantamento.
- Spurr, Schumacher-Hall e Fator de Forma na calculadora.
- Resultados com dados reais, volumes e extrapolação por área; não são mais apenas indicadores “A calcular”.
- Exportação PDF, CSV, XLSX, KML e variantes brutas CSV/XLSX.
- Histórico local de atividades e modo escuro persistido.

## Mudanças finais registradas

Fator de Forma usa `pi * (D / 100)^2 * H * ff`, nome curto e ff informado, sem divisão por 4. DAP permanece em cm no banco. A migração v8 adicionou o modelo e a v9 corrigiu nome/expressão/rótulos; preservou valores e medições.

A exportação bruta CSV mantém uma linha por árvore e campos auxiliares. A planilha bruta mantém parcelas lado a lado em A6/E6/I6, com árvore/DAP/altura a partir da linha 7. Não realiza estimativa de altura nem cálculo de volume.

A tela Novo levantamento reutiliza o formulário de propriedade; salvar atualiza a lista e limpa filtros, cancelar preserva os filtros.

## Limitações que devem constar no artigo

- Estimativa econômica não implementada.
- Cadastro de expressões não tem parser; cálculo reconhece modelos específicos e pode usar Spurr para expressão desconhecida.
- Há coeficientes e conversões padrão; não comprovaram validade universal.
- Histórico conserva medições e coeficientes por coleta, mas não congela uma versão completa da fórmula.
- Painel pode reunir diversos levantamentos; exportação por propriedade escolhe um vínculo recente por talhão.
- Área ausente em parte das parcelas limita a extrapolação, pois a soma trata área nula como zero.
- Amostragem sistemática é protocolo de referência, não verificada automaticamente.
- GPS é apoio documental, não topografia.
- O texto da equação no PDF tem formatação apenas para Spurr/Schumacher-Hall, podendo divergir do cálculo do Fator de Forma. A narrativa de amostragem é fixa, não uma verificação do procedimento de campo.
- IMA é mencionado em um aviso do exportador, mas não foi identificada rotina de cálculo desse indicador.
- KMZ, sincronização, backend e autenticação não existem na versão entregue.
- Nenhuma validação formal de campo/usabilidade é estabelecida por esta revisão.

## Evidências de código

| Tema | Fonte |
|---|---|
| Banco v10, 15 tabelas, carga inicial | lib/nucleo/banco/banco_dendro.dart |
| Fórmulas e conversões | lib/nucleo/floresta/calculadora_volume_florestal.dart |
| Painel e filtros | lib/funcionalidades/resultados/dados/repositorio_resultados.dart |
| Formatos, conteúdo e escopo de exportação | lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart |
| Coleta e GPS | lib/funcionalidades/coleta_arvores/ |
| Planejamento, parcelas e áreas | lib/funcionalidades/parcelas/ |
| Coeficientes e catálogos | lib/funcionalidades/ajustes/, lib/funcionalidades/levantamentos/ |
| Tema | lib/nucleo/preferencias/controlador_tema.dart |

## Testes e build

Na última execução registrada nesta conversa: 36 testes automatizados aprovados e flutter analyze sem problemas. Há arquivos de teste para banco, migração do modelo, calculadora, exportação bruta, tema, propriedades e interface geral. Esta revisão documental não executou novamente testes do aplicativo e não deve ser citada como novo ensaio.

Foi gerado APK debug em build/app/outputs/flutter-apk/app-debug.apk durante o desenvolvimento. A existência desse build não garante que todos os aparelhos estejam com a mesma versão instalada. Não há serviço de distribuição do APK integrado ao app.

Configuração e uso de emulador são atividades de desenvolvimento. Testes com usuários, comparação manual independente de um inventário e validação técnica continuam pendentes para o artigo.

## Documentos para gerar diagramas

ENGINEERING_MODELS.md reúne as figuras atualizadas. O diretório diagrams/ guarda fontes Mermaid editáveis. ARCHITECTURE.md descreve componentes reais e REQUIREMENTS.md classifica o atendimento de cada requisito. BUSINESS_RULES.md registra inclusive os comportamentos alternativos e limitações do cálculo.

DECISIONS.md preserva decisões históricas: ler primeiro D-043. BRANDING.md e UI_REFERENCE.md são referências de identidade/projeto visual; seus exemplos não demonstram que uma função foi implementada.
