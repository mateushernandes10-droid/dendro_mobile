import 'package:flutter/material.dart';

typedef AbrirAbaResultados =
    void Function({
      String? propriedadeId,
      Set<String>? talhaoIds,
      String? especieId,
    });

class NavegacaoEstruturaDendro extends InheritedWidget {
  const NavegacaoEstruturaDendro({
    required this.abrirResultados,
    required super.child,
    super.key,
  });

  final AbrirAbaResultados abrirResultados;

  static NavegacaoEstruturaDendro de(BuildContext context) {
    final navegacao = context
        .dependOnInheritedWidgetOfExactType<NavegacaoEstruturaDendro>();
    assert(navegacao != null, 'DendroShellNavigation nao encontrado.');
    return navegacao!;
  }

  @override
  bool updateShouldNotify(NavegacaoEstruturaDendro antigoWidget) {
    return abrirResultados != antigoWidget.abrirResultados;
  }
}
