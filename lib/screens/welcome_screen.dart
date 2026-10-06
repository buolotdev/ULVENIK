import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../widgets/custom_snackbar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Stack(
        children: [
          // Faint Background Mountain Watermark
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.03, // Very faint
                child: Image.asset(
                  'assets/images/white_mountain_only.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo at the top
                  Center(
                    child: Image.asset(
                      'assets/images/white_mountain_only.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 64),
                  
                  // Headings
                  const Center(
                    child: Text(
                      'THE JOURNEY BUILDS THE WOLF.',
                      style: TextStyle(
                        color: AppColors.primaryForestGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Ulvenik',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose how you\'d like to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 15,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Main Buttons
                  _buildPrimaryButton(
                    context: context,
                    label: 'Create Account',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const RegisterScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSecondaryButton(
                    context: context,
                    label: 'Log In',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.05))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.05))),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Social Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onTap: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSocialButton(
                          // Using a generic 'G' or colorized icon for Google. We'll just use text 'G' as placeholder icon for now since standard material icons don't have a multi-colored Google logo.
                          isGoogle: true,
                          label: 'Google',
                          onTap: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardsCarbon,
        foregroundColor: AppColors.primaryTextOffWhite,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    bool isGoogle = false,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.backgroundObsidian,
        foregroundColor: AppColors.primaryTextOffWhite,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isGoogle)
            Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png', width: 20, height: 20)
          else if (icon != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 24),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
