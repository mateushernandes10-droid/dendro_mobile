# Refatoração de IDs inteiros — DENDRO Mobile

Concluída em 14/09/2026. Schema anterior: **10**. Schema atual: **11**. Código próprio permanece em português; regras de inventário, interface, fórmulas e coeficientes foram preservados.

## Estrutura adotada

O banco mantém 15 tabelas. As 14 tabelas com PK simples passaram de texto para INTEGER PRIMARY KEY AUTOINCREMENT. No Drift, id usa integer().autoIncrement(). Todas as 17 FKs declaradas passaram para INTEGER e mantêm as ações ON DELETE anteriores. especies_modelos mantém sua PK composta: é uma associação identificada pelo par espécie/modelo, sem necessidade de criar uma identidade artificial.

| Tabela | Chave primária v11 | Chaves estrangeiras inteiras |
|---|---|---|
| propriedades | id inteiro, autoincremento | — |
| especies | id inteiro, autoincremento | — |
| modelos_matematicos | id inteiro, autoincremento | — |
| variaveis_modelo | id inteiro, autoincremento | modelo_matematico_id |
| coeficientes_modelo | id inteiro, autoincremento | modelo_matematico_id |
| especies_modelos | Composta: especie_id + modelo_matematico_id | especie_id, modelo_matematico_id |
| coeficientes_especie_modelo | id inteiro, autoincremento | especie_id, modelo_matematico_id |
| talhoes | id inteiro, autoincremento | propriedade_id, especie_id |
| levantamentos | id inteiro, autoincremento | propriedade_id |
| talhao_levantamentos | id inteiro, autoincremento | levantamento_id, talhao_id, especie_id, modelo_matematico_id |
| coeficientes_talhao_levantamento | id inteiro, autoincremento | talhao_levantamento_id |
| parcelas | id inteiro, autoincremento | talhao_levantamento_id |
| pontos_geograficos_parcela | id inteiro, autoincremento | parcela_id |
| arvores | id inteiro, autoincremento | parcela_id |
| registros_atividade | id inteiro, autoincremento | — |

São 115 colunas: as 112 anteriores, codigo em especies/modelos_matematicos e referencia_legada em registros_atividade. entidade_id tornou-se INTEGER nullable, sem FK direta porque pode representar tipos de entidade diferentes.

## Códigos e regras internas

Os campos codigo são TEXT UNIQUE nullable. Os padrões conservam species_pinus, species_eucalyptus, formula_spurr, formula_schumacher_hall e formula_form_factor. Também são preservados identificadores legados de modelos cujo conteúdo participava das regras de reconhecimento de Spurr/Schumacher-Hall. UUIDs sem significado dos cadastros personalizados não são carregados como codigo; esses registros podem ter codigo nulo.

CalculadoraVolumeFlorestal recebe modeloMatematicoCodigo para selecionar modelos e valores padrão. O exportador também usa codigo ao reconhecer Schumacher-Hall. Espécies continuam usando a identificação por nome nas conversões de volume, exatamente como antes. Nenhuma regra usa o valor numérico de uma PK para identificar um modelo padrão.

Repositórios devolvem o int retornado pela inserção no Drift/SQLite. Providers, filtros, seletores, rotas, callbacks, coleções, SQL manual e exportadores trabalham com os novos tipos. Não foram introduzidos int.parse ou id.toString para esconder incompatibilidades de tipos. CSV conserva seus campos funcionais; quando contém ID interno, o valor agora é inteiro.

## Migração e preservação

1. Ao abrir um banco v10, a migração registra a configuração de foreign_keys e a desativa fora da transação, como exige o SQLite para reconstrução de tabelas.
2. Dentro de uma única transação, as tabelas antigas recebem nomes temporários. O Drift cria a estrutura v11 e os dois CREATE TABLE manuais criam as tabelas de coeficientes por talhão e atividades.
3. Cada tabela é copiada em ordem de dependências. As inserções omitem a PK antiga; SQLite gera o ID inteiro. Mapas em memória relacionam cada ID antigo ao ID devolvido pela inserção.
4. Cada FK é substituída pelo novo ID do registro correspondente. Referências obrigatórias sem destino interrompem a migração.
5. O histórico remapeia entidade_id de acordo com tipo_entidade. Exportações apontam para a propriedade. Quando o cadastro já foi excluído, entidade_id fica nulo e a referência original é conservada em referencia_legada. Textos, tipos e datas do evento permanecem.
6. As contagens são conferidas e as restrições UNIQUE estão ativas nas tabelas novas durante a cópia. Depois da cópia, removem-se as tabelas temporárias e executa-se PRAGMA foreign_key_check antes de concluir a transação.
7. Se ocorrer erro, há rollback de esquema e dados. A configuração de foreign_keys é restaurada tanto no sucesso quanto na falha. Os mapas temporários não são persistidos.

Para instalações v1–9, a tradução de nomes e as etapas históricas são completadas antes da conversão das PKs. Bancos novos já nascem na v11. O nome do arquivo continua dendro_mobile; não é necessário resetar o banco ou reinstalar o aplicativo.

Datas, coordenadas, medições, coeficientes, expressões, situações, unicidade e cardinalidades foram preservados. Na v10 → v11, apenas IDs e referências mudam, com os campos auxiliares descritos acima. Versões anteriores continuam recebendo as atualizações históricas de catálogo que já existiam.

## UUID

Não há importação nem geração de UUID no código próprio; a dependência direta foi removida do pubspec.yaml. O pubspec.lock ainda contém uuid como dependência transitiva de share_plus_platform_interface e geolocator_android. Removê-la à força quebraria dependências externas; nenhuma delas determina as PKs do aplicativo.

Nomes textuais antigos permanecem em fixtures e no código que lê esquemas legados. No banco atual, podem permanecer códigos de negócio ou uma referência histórica a um cadastro excluído; não são chaves primárias ou estrangeiras textuais.

## Verificações finais

- dart run build_runner build --delete-conflicting-outputs: concluído. A versão instalada do build_runner informa que a opção --delete-conflicting-outputs foi removida e a ignora; a geração concluiu normalmente.
- dart format lib test: 52 arquivos formatados; passagem final sem alterações.
- flutter analyze: sem apontamentos.
- flutter test: **53 testes aprovados**.
- flutter build apk --debug: concluído com sucesso; APK em build/app/outputs/flutter-apk/app-debug.apk. Houve aviso de versões XML diferentes entre ferramentas do SDK Android, sem impedir a compilação.
- git diff --check: sem erros.

Os testes cobrem bancos novos, incremento sem reutilizar a maior chave excluída, PKs/FKs inteiras, chave composta, relações e todos os campos migrados da v10, índices UNIQUE, ações das FKs, integridade, escrita/reabertura, rollback e nova tentativa. Também cobrem migrações v1–9, catálogos v7/v8, eventos antigos e referências excluídas, reconhecimento dos modelos com IDs numéricos diferentes, cálculos, cadastros, coleta, resultados, exportação bruta, navegação e tema.

Um teste compara diretamente o diagrama completo com as 15 tabelas/115 colunas do banco aberto, seus tipos e nulabilidade, além de verificar que as oito fontes Mermaid correspondem aos blocos em ENGINEERING_MODELS.md. Não foi realizada renderização visual dos diagramas.

## Limites e testes manuais

O APK não foi instalado automaticamente e o emulador não foi iniciado. GPS real, permissões, teclado, salvamento/compartilhamento pelo Android e apresentação visual em aparelhos físicos ainda exigem teste manual. A migração foi validada em bases de teste com dados representativos, não em uma cópia dos dados privados do aparelho do usuário. Bancos previamente corrompidos ou com referências obrigatórias órfãs geram erro e permanecem na versão anterior por rollback; não há descarte automático de dados. A migração utiliza mapas em memória e não foi medida com volumes extremos de registros.

## Arquivos alterados ou adicionados nesta etapa

Caminhos relativos à raiz do projeto. Inclui código gerado, fixtures, testes, configuração e documentação.

- lib/funcionalidades/ajustes/apresentacao/tela_ajustes.dart
- lib/funcionalidades/ajustes/dados/repositorio_ajustes.dart
- lib/funcionalidades/atividades/dados/repositorio_atividades.dart
- lib/funcionalidades/coleta_arvores/apresentacao/tela_coleta_arvores.dart
- lib/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart
- lib/funcionalidades/estrutura/apresentacao/estrutura_dendro.dart
- lib/funcionalidades/estrutura/apresentacao/navegacao_estrutura_dendro.dart
- lib/funcionalidades/exportacao_dados/apresentacao/tela_exportacao_dados.dart
- lib/funcionalidades/exportacao_dados/dados/repositorio_exportacao_dados.dart
- lib/funcionalidades/inicio/apresentacao/tela_inicio.dart
- lib/funcionalidades/levantamentos/apresentacao/componentes/painel_selecao_modelo_levantamento.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_detalhe_levantamento.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_levantamentos.dart
- lib/funcionalidades/levantamentos/apresentacao/tela_novo_levantamento.dart
- lib/funcionalidades/levantamentos/dados/repositorio_levantamentos.dart
- lib/funcionalidades/levantamentos/dados/selecao_modelo_levantamento.dart
- lib/funcionalidades/parcelas/apresentacao/tela_parcelas_talhao.dart
- lib/funcionalidades/parcelas/dados/repositorio_parcelas.dart
- lib/funcionalidades/propriedades/apresentacao/tela_detalhe_propriedade.dart
- lib/funcionalidades/propriedades/dados/repositorio_propriedades.dart
- lib/funcionalidades/resultados/apresentacao/tela_resultados.dart
- lib/funcionalidades/resultados/dados/repositorio_resultados.dart
- lib/funcionalidades/talhoes/dados/repositorio_talhoes.dart
- lib/nucleo/banco/banco_dendro.dart
- lib/nucleo/banco/banco_dendro.g.dart
- lib/nucleo/banco/catalogos_iniciais.dart
- lib/nucleo/banco/migracao_ids_inteiros.dart
- lib/nucleo/floresta/calculadora_volume_florestal.dart
- pubspec.lock
- pubspec.yaml
- tcc_codex_context/AGENTS.md
- tcc_codex_context/docs/ARCHITECTURE.md
- tcc_codex_context/docs/BUSINESS_RULES.md
- tcc_codex_context/docs/DECISIONS.md
- tcc_codex_context/docs/ENGINEERING_MODELS.md
- tcc_codex_context/docs/IMPLEMENTATION_NOTES.md
- tcc_codex_context/docs/PROJECT_CONTEXT.md
- tcc_codex_context/docs/REFATORACAO_IDS_INTEIROS.md
- tcc_codex_context/docs/REFATORACAO_NOMENCLATURA.md
- tcc_codex_context/docs/REQUIREMENTS.md
- tcc_codex_context/docs/diagrams/03_banco_relacionamentos.mmd
- tcc_codex_context/docs/diagrams/04_banco_completo.mmd
- tcc_codex_context/docs/diagrams/08_classes_dados.mmd
- tcc_codex_context/docs/diagrams/README.md
- test/fixtures/banco_v10.json
- test/fixtures/preparar_legado.dart
- test/funcionalidades/exportacao_dados/exportacao_bruta_test.dart
- test/funcionalidades/propriedades/tela_propriedades_test.dart
- test/interface_test.dart
- test/nucleo/banco/banco_dendro_test.dart
- test/nucleo/banco/diagrama_banco_test.dart
- test/nucleo/banco/migracao_fator_forma_test.dart
- test/nucleo/banco/migracao_ids_inteiros_test.dart
- test/nucleo/banco/migracao_nomenclatura_test.dart
- test/nucleo/floresta/calculadora_volume_florestal_test.dart
