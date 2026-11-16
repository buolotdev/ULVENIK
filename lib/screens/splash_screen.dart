import 'package:flutter/material.dart';
import '../widgets/ulvenik_logo.dart';
import '../theme/app_colors.dart';
import 'onboarding_screen.dart';

/// Launch screen (client review 13 Nov 2026).
///
/// Shows the approved logo with "Train. Record. Progress." and an honest,
/// indeterminate loading state. It moves on as soon as start-up work is
/// finished (no artificial delay) and offers Try Again if that work fails.
///
/// Note: first-run vs returning signed-in routing needs saved session state,
/// which the app does not have yet, so every launch currently continues to
/// the introduction.
class SplashScreen extends StatefulWidget {
  /// Start-up work to run before leaving the splash. Defaults to preloading
  /// the brand and introduction images so the next screen appears complete.
  final Future<void> Function(BuildContext context)? loader;

  const SplashScreen({super.key, this.loader});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _failed = false;
  bool _started = false;

  static const _startupImages = [
    'assets/images/logo_full.png',
    'assets/bg-images/onboarding_1.png',
    'assets/bg-images/onboarding_2.png',
    'assets/bg-images/onboarding_3.png',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _load();
    }
  }

  Future<void> _defaultLoader(BuildContext context) async {
    await Future.wait(_startupImages.map(
      (path) => precacheImage(AssetImage(path), context, onError: (e, _) => throw e),
    ));
  }

  Future<void> _load() async {
    setState(() => _failed = false);
    try {
      await (widget.loader ?? _defaultLoader)(context);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UlvenikLogo.full(width: 240),
                const SizedBox(height: 20),
                const Text(
                  'Train. Record. Progress.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 15,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 48),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _failed ? _buildError() : _buildLoading(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Semantics(
      key: const ValueKey('loading'),
      liveRegion: true,
      label: 'Loading Ulvenik',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: AppColors.primaryForestGreen,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Loading Ulvenik...',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Column(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Couldn't load Ulvenik",
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Check your connection and try again.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _load,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryForestGreen,
            foregroundColor: AppColors.primaryTextOffWhite,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text('Try Again'),
        ),
      ],
    );
  }
}
