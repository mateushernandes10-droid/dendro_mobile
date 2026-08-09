import 'package:flutter/material.dart';

import '../features/splash/presentation/splash_screen.dart';
import 'theme/dendro_theme.dart';

class DendroApp extends StatelessWidget {
  const DendroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DENDRO Mobile',
      theme: DendroTheme.light,
      home: const SplashScreen(),
    );
  }
}
