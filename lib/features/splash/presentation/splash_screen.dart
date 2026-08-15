import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/dendro_assets.dart';
import '../../../core/providers/database_providers.dart';
import '../../shell/presentation/dendro_shell.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _started = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_prepareAndOpenApp());
    });
  }

  Future<void> _prepareAndOpenApp() async {
    if (_hasError && mounted) {
      setState(() => _hasError = false);
    }

    try {
      await Future.wait<void>([
        _warmUpDatabase(),
        _precacheAsset(DendroAssets.logo),
        _precacheAsset(DendroAssets.forestBackground),
        Future<void>.delayed(const Duration(milliseconds: 2400)),
      ]);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
      return;
    }

    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const DendroShell(),
        transitionDuration: const Duration(milliseconds: 320),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _warmUpDatabase() async {
    final database = ref.read(dendroDatabaseProvider);
    await (database.select(database.species)..limit(1)).get();
  }

  Future<void> _precacheAsset(String assetPath) async {
    try {
      await precacheImage(AssetImage(assetPath), context);
    } catch (_) {
      // Asset precaching is only an optimization; the widgets still handle
      // image fallback if an asset cannot be decoded on a specific platform.
    }
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
              color: const Color(0xFF00170F).withValues(alpha: 0.42),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFF012D1D).withValues(alpha: 0.78),
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
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
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 168,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        color: const Color(0xFFC1ECD4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: _hasError
                        ? TextButton(
                            onPressed: () => unawaited(_prepareAndOpenApp()),
                            child: const Text(
                              'Tentar novamente',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Text(
                            'Carregando...',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
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
