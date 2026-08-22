import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/preferences/theme_mode_controller.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'theme/dendro_theme.dart';

class DendroApp extends ConsumerWidget {
  const DendroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENDRO Mobile',
      theme: DendroTheme.light,
      darkTheme: DendroTheme.dark,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
