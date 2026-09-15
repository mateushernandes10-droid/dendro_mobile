# Revisão dos nomes próprios — DENDRO Mobile

14/09/2026. Revisão limitada ao item 1 autorizado pelo usuário: melhorar a clareza de nomes em português. Foram ajustados **126 identificadores em 30 arquivos Dart**. A arquitetura e a organização dos arquivos foram mantidas.

## Critério

Métodos usam verbos que descrevem a ação; classes auxiliares e provedores indicam sua responsabilidade com uma ordem de palavras natural. Campos de validação próprios passaram de larguraValidator/comprimentoValidator para validadorLargura/validadorComprimento. O parâmetro validator do Flutter permanece intacto, assim como outros nomes externos.

Não foram alterados nomes físicos do banco, enums persistidos, códigos de catálogo, expressões, coeficientes, textos da interface ou formatos de exportação. O banco permanece no **schema 11**, sem migração nova. Não é necessário resetar dados.

## Validação

- Comparação de tokens em 51 fontes Dart: apenas as substituições do mapa abaixo e formatação; arquivos do banco idênticos à versão anterior desta etapa.
- dart format lib test: concluído.
- flutter analyze --no-pub: sem apontamentos.
- flutter test --no-pub: 53 testes aprovados.
- flutter build apk --debug --no-pub: concluído; APK atualizado em build/app/outputs/flutter-apk/app-debug.apk.
- git diff --check: sem erros.
- Não foram adicionados testes que apenas repetem as renomeações; a suíte existente continua verificando comportamentos e migrações.

## Mapa de nomes

| Nome anterior | Nome atual |
|---|---|
| criarPlanejadoParcela | criarParcelaPlanejada |
| atualizarParcelaArea | atualizarAreaParcela |
| proximoParcelaIdentificacao | proximaIdentificacaoParcela |
| _proximoParcelaIdentificacaoParaTalhao | _proximaIdentificacaoParcelaDoTalhao |
| geograficoPontosParaParcela | pontosGeograficosDaParcela |
| atualizarDeParcela | atualizarLevantamentoDaParcela |
| _aplicarModeloMatematicoSelecao | _aplicarSelecaoModeloMatematico |
| _excluirLevantamentoIfVazio | _excluirLevantamentoSeVazio |
| _quantidadeGeograficoPontos | _quantidadePontosGeograficos |
| _primeiroGeograficoPonto | _primeiroPontoGeografico |
| _registroLevantamentoIniciar | _registrarInicioLevantamento |
| _padraoModeloMatematicoId | _obterIdModeloPadrao |
| _substituirTalhaoModeloMatematicoCoeficientes | _substituirCoeficientesModeloDoTalhao |
| _especieModeloMatematicoCoeficienteValores | _valoresCoeficientesModeloDaEspecie |
| atualizarTalhaoInLevantamento | atualizarTalhaoNoLevantamento |
| observarMaisRecenteAtivo | observarLevantamentoAtivoMaisRecente |
| observarAtivo | observarLevantamentosAtivos |
| _normalizarAtivoLevantamentosPorPropriedade | _normalizarLevantamentosAtivosPorPropriedade |
| _possuiTalhaoColisao | _possuiTalhaoDuplicado |
| _excluirTalhaoLevantamentoDados | _excluirDadosTalhoesDoLevantamento |
| _quantidadeColetadaParcelas | _quantidadeParcelasColetadas |
| _somaMedidaArea | _somarAreaMedida |
| _situacaoPriority | _prioridadeSituacao |
| _excluirModeloMatematicoCoeficienteCopias | _excluirCopiasCoeficientesModelo |
| _talhaoResumos | _resumosTalhoes |
| marcaParcelaColetada | marcarParcelaColetada |
| proximoArvoreNumero | proximoNumeroArvore |
| _lerColetaContexto | _lerContextoColeta |
| _ColetaContexto | _ContextoColeta |
| _limparReferenciaPosicaoDeArvores | _limparPosicaoReferenciaDasArvores |
| carregarEscuroModo | carregarModoEscuro |
| salvarEscuroModo | salvarModoEscuro |
| definirEscuroModo | definirModoEscuro |
| _preferenciasArquivo | _arquivoPreferencias |
| ArmazenamentoModoTema | ArmazenamentoPreferenciaTema |
| ArmazenamentoTemaArquivo | ArmazenamentoTemaEmArquivo |
| provedorAtivoEspecie | provedorEspeciesAtivas |
| observarAtivoEspecie | observarEspeciesAtivas |
| provedorPropriedadeTalhoes | provedorTalhoesDaPropriedade |
| provedorLevantamentoIniciarOpcoes | provedorOpcoesNovoLevantamento |
| LevantamentoIniciarPropriedadeOpcao | OpcaoPropriedadeNovoLevantamento |
| _LevantamentoIniciarPropriedadeAcumulador | _AcumuladorPropriedadeNovoLevantamento |
| _possuiAtivoLevantamento | _possuiLevantamentoAtivo |
| _quantidadeTalhaoLevantamentos | _quantidadeLevantamentosDoTalhao |
| provedorAtivoLevantamento | provedorLevantamentoAtivo |
| provedorAtivoLevantamentos | provedorLevantamentosAtivos |
| provedorPropriedadeBuscaConsulta | provedorConsultaBuscaPropriedades |
| provedorPropriedadeAvancadoFiltros | provedorFiltrosAvancadosPropriedades |
| provedorPropriedadeResumos | provedorResumosPropriedades |
| PropriedadeAvancadoFiltros | FiltrosAvancadosPropriedades |
| buscaPorNome | buscarPorNome |
| provedorResultadosPropriedadeFiltro | provedorFiltroPropriedadeResultados |
| provedorResultadosTalhaoFiltro | provedorFiltroTalhoesResultados |
| provedorResultadosEspecieFiltro | provedorFiltroEspecieResultados |
| provedorResultadosFiltroOpcoes | provedorOpcoesFiltrosResultados |
| observarFiltroOpcoes | observarOpcoesFiltros |
| visivelTalhoes | talhoesVisiveis |
| _dashboardDeLinhas | _montarPainelDasLinhas |
| DiametroClasseResumo | ResumoClasseDiametro |
| provedorAjustesEspecie | provedorEspeciesAjustes |
| provedorAjustesEspecieModelosMatematicos | provedorVinculosEspecieModelo |
| provedorAjustesEspecieModeloMatematicoCoeficientes | provedorCoeficientesModeloPorEspecie |
| observarEspecie | observarEspecies |
| observarEspecieModelosMatematicos | observarVinculosEspecieModelo |
| ModeloMatematicoVariavelRascunho | RascunhoVariavelModelo |
| atualizarCoeficienteValores | atualizarValoresCoeficientes |
| atualizarEspecieModeloMatematicoCoeficienteValores | atualizarCoeficientesModeloDaEspecie |
| definirEspecieModeloMatematicoVinculado | definirVinculoEspecieModelo |
| definirPadraoModeloMatematicoParaEspecie | definirModeloPadraoDaEspecie |
| _substituirCoeficienteDefinicoes | _substituirDefinicoesCoeficientes |
| _especiePossuiPadraoModeloMatematico | _especiePossuiModeloPadrao |
| _garantirEspecieModeloMatematicoVinculado | _garantirVinculoEspecieModelo |
| _garantirEspecieModeloMatematicoCoeficienteLinhas | _garantirCoeficientesModeloDaEspecie |
| _garantirEspeciePossuiPadraoModeloMatematico | _garantirModeloPadraoDaEspecie |
| LevantamentoModeloMatematicoSelecao | SelecaoModeloLevantamento |
| LevantamentoModeloMatematicoCoeficienteValor | ValorCoeficienteModeloLevantamento |
| TalhaoParcelasEstado | EstadoParcelasTalhao |
| AtivoLevantamentoParaTalhaoExcecao | ExcecaoLevantamentoAtivoNoTalhao |
| ExportacaoDadosSolicitacao | SolicitacaoExportacaoDados |
| ExportacaoDadosTalhaoOpcao | OpcaoTalhaoExportacao |
| GeradoExportacaoDadosArquivo | ArquivoExportacaoGerado |
| ExportacaoDadosConjuntoDados | DadosExportacao |
| ExportacaoDadosTalhaoConjuntoDados | DadosTalhaoExportacao |
| ExportacaoDadosParcelaConjuntoDados | DadosParcelaExportacao |
| ExportacaoDadosCoeficiente | CoeficienteExportacao |
| registroExportacao | registrarExportacao |
| _especieCoeficienteValores | _valoresCoeficientesDaEspecie |
| _globalCoeficienteValores | _valoresCoeficientesGlobais |
| _efetivoCoeficienteValor | _valorEfetivoCoeficiente |
| _talhaoOpcoesParaLevantamento | _opcoesTalhaoDoLevantamento |
| _geograficoPontosParaParcela | _pontosGeograficosDaParcela |
| _arquivoNome | _nomeArquivo |
| _seguroArquivoParte | _sanitizarParteNomeArquivo |
| _coordinateValor | _valorCoordenada |
| _opcionalCoordinate | _coordenadaOpcional |
| _unicoModeloMatematicoUtiliza | _combinacoesDistintasDeModelo |
| _tecnicoObservacoes | _observacoesTecnicas |
| _juntarLegivelLista | _juntarListaLegivel |
| ParcelaDimensoesEntrada | EntradaDimensoesParcela |
| SecaoTitulo | TituloSecao |
| SituacaoIndicador | IndicadorSituacao |
| IndicadorBloco | BlocoIndicador |
| larguraValidator | validadorLargura |
| comprimentoValidator | validadorComprimento |
| _obrigatorioValidator | _validarCampoObrigatorio |
| _plantioAnoValidator | _validarAnoPlantio |
| _parcelaDimensaoValidator | _validarDimensaoParcela |
| _prepararCoeficienteControllers | _prepararControladoresCoeficientes |
| _sincronizarControllers | _sincronizarControladores |
| _RapidoTalhaoCriacao | _ResultadoCadastroRapidoTalhao |
| _RapidoTalhaoFormularioPainel | _PainelCadastroRapidoTalhao |
| _RapidoTalhaoFormularioPainelEstado | _EstadoPainelCadastroRapidoTalhao |
| _ArvoreLerSomenteItem | _ItemConsultaArvore |
| _GeograficoPontoLerSomenteItem | _ItemConsultaPontoGeografico |
| _CapturadoLocalizacaoCartao | _CartaoLocalizacaoCapturada |
| _ParcelCabecalho | _CabecalhoParcela |
| _CarregarErroCartao | _CartaoErroCarregamento |
| _CarregarErro | _ErroCarregamento |
| _AtivoColetaItem | _ItemColetaAtiva |
| _AtivoColetasPaginador | _PaginadorColetasAtivas |
| _AtivoColetaPontos | _IndicadorPaginasColetasAtivas |
| _AtivoColetaCartao | _CartaoColetaAtiva |
| _AtivoColetaCarregandoCartao | _CartaoCarregamentoColetasAtivas |
| _AtivoColetaErroCartao | _CartaoErroColetasAtivas |
| _EmLinhaInformacao | _InformacaoEmLinha |
| _EmLinhaIndicador | _IndicadorEmLinha |

## Arquivos Dart alterados

Caminhos relativos à raiz do projeto. A documentação foi conferida e o histórico desta decisão consta em DECISIONS.md e IMPLEMENTATION_NOTES.md.

- lib/compartilhado/componentes/componentes_dendro.dart
- lib/funcionalidades/ajustes/apresentacao/tela_ajustes.dart
- lib/funcionalidades/ajustes/dados/repositorio_ajustes.dart
- lib/funcionalidades/atividades/dados/repositorio_atividades.dart
- lib/funcionalidades/coleta_arvores/apresentacao/tela_coleta_arvores.dart
- lib/funcionalidades/coleta_arvores/dados/repositorio_arvores.dart
- lib/funcionalidades/estrutura/apresentacao/estrutura_dendro.dart
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
- lib/funcionalidades/propriedades/apresentacao/tela_propriedades.dart
- lib/funcionalidades/propriedades/dados/repositorio_propriedades.dart
- lib/funcionalidades/resultados/apresentacao/tela_resultados.dart
- lib/funcionalidades/resultados/dados/repositorio_resultados.dart
- lib/funcionalidades/talhoes/dados/repositorio_talhoes.dart
- lib/nucleo/preferencias/controlador_tema.dart
- test/funcionalidades/exportacao_dados/exportacao_bruta_test.dart
- test/funcionalidades/propriedades/tela_propriedades_test.dart
- test/interface_test.dart
- test/nucleo/banco/banco_dendro_test.dart
- test/nucleo/preferencias/controlador_tema_test.dart
