import 'package:flutter/material.dart';

import '../../home/presentation/home_screen.dart';
import '../../inventory_runs/presentation/inventory_runs_screen.dart';
import '../../properties/presentation/properties_screen.dart';
import '../../results/presentation/results_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class DendroShell extends StatefulWidget {
  const DendroShell({super.key});

  @override
  State<DendroShell> createState() => _DendroShellState();
}

class _DendroShellState extends State<DendroShell> {
  int _selectedIndex = 0;

  static const _pages = [
    HomeScreen(),
    InventoryRunsScreen(),
    PropertiesScreen(),
    ResultsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Levant.',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Propr.',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Resultados',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
