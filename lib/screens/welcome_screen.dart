import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/ulvenik_logo.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

/// Account entry after the introduction (Frontend Review v07, Screen 01).
///
/// Full logo as the focal point, "Every Session Counts." heading, matched
/// Create Account / Log In buttons, "Or continue with" Apple / Google,
/// discreet legal links and a subtle TRAIN • RECORD • PROGRESS footer.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  void _open(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => screen,
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _providerUnavailable(String provider) {
    AppSnackbar.show(
      context,
      message: '$provider sign-in isn\'t available in this build yet.',
      type: SnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 3),
                      const Center(child: UlvenikLogo.full(width: 250)),
                      const Spacer(flex: 2),
                      const SizedBox(height: 24),
                      Text(
                        'Every Session Counts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your training journey, all in one place.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 36),
                      _MainButton(
                        label: 'Create Account',
                        primary: true,
                        onTap: () => _open(const RegisterScreen()),
                      ),
                      const SizedBox(height: 12),
                      _MainButton(
                        label: 'Log In',
                        primary: false,
                        onTap: () => _open(const LoginScreen()),
                      ),
                      const SizedBox(height: 28),
                      const _OrDivider(label: 'Or continue with'),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _ProviderButton(
                              asset: 'assets/icons/apple_logo.svg',
                              label: 'Apple',
                              tintWhite: true,
                              onTap: () => _providerUnavailable('Apple'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ProviderButton(
                              asset: 'assets/icons/google_logo.svg',
                              label: 'Google',
                              onTap: () => _providerUnavailable('Google'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _LegalLinks(
                        onTerms: () => _open(const TermsConditionsScreen()),
                        onPrivacy: () => _open(const PrivacyPolicyScreen()),
                      ),
                      const Spacer(flex: 2),
                      const SizedBox(height: 20),
                      const Text(
                        'TRAIN  •  RECORD  •  PROGRESS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0x80A7B0AB),
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainButton extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const _MainButton({required this.label, required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
          foregroundColor: primary ? AppColors.onForestGreen : AppColors.primaryTextOffWhite,
          overlayColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: primary ? BorderSide.none : BorderSide(color: AppColors.cardBorder),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  final String label;
  const _OrDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08)));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
        ),
        line,
      ],
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String asset;
  final String label;
  final bool tintWhite;
  final VoidCallback onTap;

  const _ProviderButton({
    required this.asset,
    required this.label,
    required this.onTap,
    this.tintWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTextOffWhite,
          backgroundColor: AppColors.cardsCarbon,
          side: BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              width: 20,
              height: 20,
              colorFilter: tintWhite ? ColorFilter.mode(AppColors.primaryTextOffWhite, BlendMode.srcIn) : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalLinks extends StatelessWidget {
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;
  const _LegalLinks({required this.onTerms, required this.onPrivacy});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5);
    Widget link(String text, VoidCallback onTap) => Semantics(
          link: true,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                text,
                style: style.copyWith(
                  color: AppColors.primaryTextOffWhite.withValues(alpha: 0.8),
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
          ),
        );
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('By continuing you agree to our', style: style),
        link('Terms of Service', onTerms),
        Text('and', style: style),
        link('Privacy Policy', onPrivacy),
      ],
    );
  }
}
