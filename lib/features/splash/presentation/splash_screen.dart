import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/dendro_assets.dart';
import '../../shell/presentation/dendro_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_openApp());
  }

  Future<void> _openApp() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DendroShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            DendroAssets.forestBackground,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const _FallbackForestBackground(),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF00170F).withValues(alpha: 0.34),
            ),
          ),
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                color: const Color(0xFF012D1D).withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(DendroAssets.logo),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DENDRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                    ),
                  ),
                  const Text(
                    'Mobile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFC1ECD4),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sistema para Inventário Florestal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackForestBackground extends StatelessWidget {
  const _FallbackForestBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B4332), Color(0xFF062217)],
        ),
      ),
    );
  }
}
