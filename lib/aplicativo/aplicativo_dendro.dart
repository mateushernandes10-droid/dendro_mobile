import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../nucleo/preferencias/controlador_tema.dart';
import '../funcionalidades/abertura/apresentacao/tela_abertura.dart';
import 'tema/tema_dendro.dart';

class AplicativoDendro extends ConsumerWidget {
  const AplicativoDendro({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modoTema = ref.watch(provedorControladorTema);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENDRO Mobile',
      theme: TemaDendro.claro,
      darkTheme: TemaDendro.escuro,
      themeMode: modoTema,
      home: const TelaAbertura(),
    );
  }
}
