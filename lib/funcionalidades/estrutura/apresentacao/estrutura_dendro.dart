import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inicio/apresentacao/tela_inicio.dart';
import '../../levantamentos/apresentacao/tela_levantamentos.dart';
import '../../propriedades/apresentacao/tela_propriedades.dart';
import '../../resultados/dados/repositorio_resultados.dart';
import '../../resultados/apresentacao/tela_resultados.dart';
import '../../ajustes/apresentacao/tela_ajustes.dart';
import 'navegacao_estrutura_dendro.dart';

class EstruturaDendro extends ConsumerStatefulWidget {
  const EstruturaDendro({super.key});

  @override
  ConsumerState<EstruturaDendro> createState() => _DendroEstruturaEstado();
}

class _DendroEstruturaEstado extends ConsumerState<EstruturaDendro> {
  static const _resultadosAbaIndex = 3;

  int _selecionadoIndex = 0;
  bool _compactoNavegacao = false;

  static const _paginas = [
    TelaInicio(),
    TelaLevantamentos(),
    TelaPropriedades(),
    TelaResultados(),
    TelaAjustes(),
  ];

  late final List<GlobalKey<NavigatorState>> _navegadorKeys;
  late final List<_AbaNavegadorObservador> _navegadorObservadores;

  @override
  void initState() {
    super.initState();
    _navegadorKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());
    _navegadorObservadores = List.generate(
      5,
      (_) => _AbaNavegadorObservador(_atualizarNavegacaoModo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navegacaoRotulos = _navegacaoRotulosParaLargura(
      MediaQuery.sizeOf(context).width,
    );

    return NavegacaoEstruturaDendro(
      abrirResultados: _abrirResultadosAba,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didDesempilhar, resultado) {
          _tratarSistemaVoltar(didDesempilhar);
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selecionadoIndex,
            children: [
              for (var indice = 0; indice < _paginas.length; indice++)
                _AbaNavegador(
                  navegadorChave: _navegadorKeys[indice],
                  observador: _navegadorObservadores[indice],
                  filho: _paginas[indice],
                ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            height: _compactoNavegacao ? 62 : null,
            labelBehavior: _compactoNavegacao
                ? NavigationDestinationLabelBehavior.alwaysHide
                : NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: _selecionadoIndex,
            onDestinationSelected: _selecionarAba,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: navegacaoRotulos[0],
              ),
              NavigationDestination(
                icon: const Icon(Icons.assignment_outlined),
                selectedIcon: const Icon(Icons.assignment),
                label: navegacaoRotulos[1],
              ),
              NavigationDestination(
                icon: const Icon(Icons.map_outlined),
                selectedIcon: const Icon(Icons.map),
                label: navegacaoRotulos[2],
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: navegacaoRotulos[3],
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: navegacaoRotulos[4],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirResultadosAba({
    int? propriedadeId,
    Set<int>? talhaoIds,
    int? especieId,
  }) {
    ref.read(provedorResultadosPropriedadeFiltro.notifier).state =
        propriedadeId;
    ref.read(provedorResultadosTalhaoFiltro.notifier).state = {...?talhaoIds};
    ref.read(provedorResultadosEspecieFiltro.notifier).state = especieId;

    final resultadosNavegador =
        _navegadorKeys[_resultadosAbaIndex].currentState;
    if (resultadosNavegador != null && resultadosNavegador.canPop()) {
      resultadosNavegador.popUntil((rota) => rota.isFirst);
    }

    if (_selecionadoIndex != _resultadosAbaIndex) {
      setState(() => _selecionadoIndex = _resultadosAbaIndex);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _atualizarNavegacaoModo();
    });
  }

  void _selecionarAba(int indice) {
    if (indice == _selecionadoIndex) {
      final navegador = _navegadorKeys[indice].currentState;
      if (navegador != null && navegador.canPop()) {
        navegador.popUntil((rota) => rota.isFirst);
      }
      return;
    }

    setState(() => _selecionadoIndex = indice);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _atualizarNavegacaoModo();
    });
  }

  void _tratarSistemaVoltar(bool didDesempilhar) {
    if (didDesempilhar) return;

    final navegador = _navegadorKeys[_selecionadoIndex].currentState;
    if (navegador != null && navegador.canPop()) {
      navegador.pop();
      return;
    }

    if (_selecionadoIndex != 0) {
      _selecionarAba(0);
      return;
    }

    SystemNavigator.pop();
  }

  void _atualizarNavegacaoModo() {
    final navegador = _navegadorKeys[_selecionadoIndex].currentState;
    final compactoNavegacao = navegador?.canPop() ?? false;
    if (!mounted || compactoNavegacao == _compactoNavegacao) return;
    setState(() => _compactoNavegacao = compactoNavegacao);
  }
}

List<String> _navegacaoRotulosParaLargura(double largura) {
  if (largura >= 600) {
    return const [
      'Início',
      'Levantamentos',
      'Propriedades',
      'Resultados',
      'Ajustes',
    ];
  }

  return const ['Início', 'Levant.', 'Propr.', 'Result.', 'Ajustes'];
}

class _AbaNavegador extends StatelessWidget {
  const _AbaNavegador({
    required this.navegadorChave,
    required this.observador,
    required this.filho,
  });

  final GlobalKey<NavigatorState> navegadorChave;
  final NavigatorObserver observador;
  final Widget filho;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navegadorChave,
      observers: [observador],
      onGenerateRoute: (ajustes) => MaterialPageRoute<void>(
        settings: ajustes,
        builder: (context) => filho,
      ),
    );
  }
}

class _AbaNavegadorObservador extends NavigatorObserver {
  _AbaNavegadorObservador(this.aoRotaAlterado);

  final VoidCallback aoRotaAlterado;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _notificar();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _notificar();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _notificar();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notificar();
  }

  void _notificar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      aoRotaAlterado();
    });
  }
}
