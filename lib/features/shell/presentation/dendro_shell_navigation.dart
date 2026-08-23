import 'package:flutter/material.dart';

typedef OpenResultsTab =
    void Function({
      String? propertyId,
      Set<String>? standIds,
      String? speciesId,
    });

class DendroShellNavigation extends InheritedWidget {
  const DendroShellNavigation({
    required this.openResults,
    required super.child,
    super.key,
  });

  final OpenResultsTab openResults;

  static DendroShellNavigation of(BuildContext context) {
    final navigation = context
        .dependOnInheritedWidgetOfExactType<DendroShellNavigation>();
    assert(navigation != null, 'DendroShellNavigation nao encontrado.');
    return navigation!;
  }

  @override
  bool updateShouldNotify(DendroShellNavigation oldWidget) {
    return openResults != oldWidget.openResults;
  }
}
