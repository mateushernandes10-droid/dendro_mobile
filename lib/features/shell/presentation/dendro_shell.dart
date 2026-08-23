import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/presentation/home_screen.dart';
import '../../inventory_runs/presentation/inventory_runs_screen.dart';
import '../../properties/presentation/properties_screen.dart';
import '../../results/data/results_repository.dart';
import '../../results/presentation/results_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'dendro_shell_navigation.dart';

class DendroShell extends ConsumerStatefulWidget {
  const DendroShell({super.key});

  @override
  ConsumerState<DendroShell> createState() => _DendroShellState();
}

class _DendroShellState extends ConsumerState<DendroShell> {
  static const _resultsTabIndex = 3;

  int _selectedIndex = 0;
  bool _compactNavigation = false;

  static const _pages = [
    HomeScreen(),
    InventoryRunsScreen(),
    PropertiesScreen(),
    ResultsScreen(),
    SettingsScreen(),
  ];

  late final List<GlobalKey<NavigatorState>> _navigatorKeys;
  late final List<_TabNavigatorObserver> _navigatorObservers;

  @override
  void initState() {
    super.initState();
    _navigatorKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());
    _navigatorObservers = List.generate(
      5,
      (_) => _TabNavigatorObserver(_updateNavigationMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationLabels = _navigationLabelsForWidth(
      MediaQuery.sizeOf(context).width,
    );

    return DendroShellNavigation(
      openResults: _openResultsTab,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          _handleSystemBack(didPop);
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              for (var index = 0; index < _pages.length; index++)
                _TabNavigator(
                  navigatorKey: _navigatorKeys[index],
                  observer: _navigatorObservers[index],
                  child: _pages[index],
                ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            height: _compactNavigation ? 62 : null,
            labelBehavior: _compactNavigation
                ? NavigationDestinationLabelBehavior.alwaysHide
                : NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectTab,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: navigationLabels[0],
              ),
              NavigationDestination(
                icon: const Icon(Icons.assignment_outlined),
                selectedIcon: const Icon(Icons.assignment),
                label: navigationLabels[1],
              ),
              NavigationDestination(
                icon: const Icon(Icons.map_outlined),
                selectedIcon: const Icon(Icons.map),
                label: navigationLabels[2],
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: navigationLabels[3],
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: navigationLabels[4],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openResultsTab({
    String? propertyId,
    Set<String>? standIds,
    String? speciesId,
  }) {
    ref.read(resultsPropertyFilterProvider.notifier).state = propertyId;
    ref.read(resultsStandFilterProvider.notifier).state = {...?standIds};
    ref.read(resultsSpeciesFilterProvider.notifier).state = speciesId;

    final resultsNavigator = _navigatorKeys[_resultsTabIndex].currentState;
    if (resultsNavigator != null && resultsNavigator.canPop()) {
      resultsNavigator.popUntil((route) => route.isFirst);
    }

    if (_selectedIndex != _resultsTabIndex) {
      setState(() => _selectedIndex = _resultsTabIndex);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateNavigationMode();
    });
  }

  void _selectTab(int index) {
    if (index == _selectedIndex) {
      final navigator = _navigatorKeys[index].currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
      return;
    }

    setState(() => _selectedIndex = index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateNavigationMode();
    });
  }

  void _handleSystemBack(bool didPop) {
    if (didPop) return;

    final navigator = _navigatorKeys[_selectedIndex].currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return;
    }

    if (_selectedIndex != 0) {
      _selectTab(0);
      return;
    }

    SystemNavigator.pop();
  }

  void _updateNavigationMode() {
    final navigator = _navigatorKeys[_selectedIndex].currentState;
    final compactNavigation = navigator?.canPop() ?? false;
    if (!mounted || compactNavigation == _compactNavigation) return;
    setState(() => _compactNavigation = compactNavigation);
  }
}

List<String> _navigationLabelsForWidth(double width) {
  if (width >= 600) {
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

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.navigatorKey,
    required this.observer,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorObserver observer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [observer],
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => child,
      ),
    );
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  _TabNavigatorObserver(this.onRouteChanged);

  final VoidCallback onRouteChanged;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _notify();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _notify();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _notify();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notify();
  }

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRouteChanged();
    });
  }
}
