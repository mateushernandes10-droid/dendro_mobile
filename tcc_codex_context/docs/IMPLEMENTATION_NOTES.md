# Estado da implementação e evidências

Revisão em 14/09/2026: schema v11, com IDs inteiros autoincrementados e FKs inteiras. A migração preserva dados e relacionamentos. Consultar REFATORACAO_IDS_INTEIROS.md para os arquivos e verificações desta etapa; REFATORACAO_NOMENCLATURA.md é o relatório histórico da v10.

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
| Banco v11, 15 tabelas, carga inicial | lib/nucleo/banco/banco_dendro.dart |
| Fórmulas e conversões | lib/nucleo/floresta/calculadora_volume_florestal.dart |
| Painel e filtros | lib/funcionalidades/resultados/dados/repositorio_resultados.dart |
| Formatos, conteúdo e escopo de exportação | lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart |
| Coleta e GPS | lib/funcionalidades/coleta_arvores/ |
| Planejamento, parcelas e áreas | lib/funcionalidades/parcelas/ |
| Coeficientes e catálogos | lib/funcionalidades/ajustes/, lib/funcionalidades/levantamentos/ |
| Tema | lib/nucleo/preferencias/controlador_tema.dart |

## Testes e build

Antes da refatoração, os 36 testes existentes passaram. Além de mantê-los, foram acrescentados testes de migração com estrutura SQL legada, comparação de dados, chaves estrangeiras e índices, tradução dos enums e reversão de alterações em caso de falha. Os resultados finais estão em REFATORACAO_NOMENCLATURA.md. Isso é verificação de software, não validação florestal com usuários.

Na conclusão da refatoração, flutter analyze não apresentou apontamentos, os 53 testes passaram e foi compilado o APK debug em build/app/outputs/flutter-apk/app-debug.apk. Ele não foi instalado automaticamente. A existência desse build não garante que todos os aparelhos estejam com a mesma versão instalada. Não há serviço de distribuição do APK integrado ao app.

Configuração e uso de emulador são atividades de desenvolvimento. Testes com usuários, comparação manual independente de um inventário e validação técnica continuam pendentes para o artigo.

## Documentos para gerar diagramas

ENGINEERING_MODELS.md reúne as figuras atualizadas. O diretório diagrams/ guarda fontes Mermaid editáveis. ARCHITECTURE.md descreve componentes reais e REQUIREMENTS.md classifica o atendimento de cada requisito. BUSINESS_RULES.md registra inclusive os comportamentos alternativos e limitações do cálculo.

DECISIONS.md preserva decisões históricas: ler primeiro D-045. BRANDING.md e UI_REFERENCE.md são referências de identidade/projeto visual; seus exemplos não demonstram que uma função foi implementada.

## Identificadores — schema v11

As 14 tabelas que possuem coluna id usam INTEGER PRIMARY KEY AUTOINCREMENT. especies_modelos mantém a PK composta (especie_id, modelo_matematico_id), ambas inteiras. Espécies e modelos têm codigo textual único e opcional: os padrões conservam seus códigos estáveis; cadastros personalizados não precisam gerar códigos nem UUID. As regras de escolha de modelos usam codigo, sem alterar expressões ou coeficientes. registros_atividade usa entidade_id inteiro opcional, sem FK polimórfica; referencia_legada conserva apenas referências antigas sem entidade correspondente. São 15 tabelas e 115 colunas.

## Revisão de legibilidade dos nomes

Em 14/09/2026, foram revisados nomes próprios com ordem de palavras pouco natural ou termos misturados com inglês. O schema continua 11 e não houve alterações funcionais. Consultar REVISAO_NOMES.md e D-046 para os nomes adotados e a verificação desta etapa.
