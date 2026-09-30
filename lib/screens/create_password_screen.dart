import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/password_strength_indicator.dart';
import 'password_updated_screen.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  
  // Track strength
  PasswordStrength _currentStrength = PasswordStrength.empty;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _confirmController.addListener(() => setState(() {}));
  }

  void _onPasswordChanged() {
    setState(() {
      _currentStrength = PasswordStrengthIndicator.evaluate(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled {
    final bool strongEnough = _currentStrength == PasswordStrength.good || _currentStrength == PasswordStrength.strong;
    final bool passwordsMatch = _passwordController.text == _confirmController.text;
    final bool isNotEmpty = _passwordController.text.isNotEmpty;
    
    // Check checklist requirements explicitly just in case
    final p = _passwordController.text;
    final bool hasLength = p.length >= 8;
    final bool hasUpper = RegExp(r'[A-Z]').hasMatch(p);
    final bool hasLower = RegExp(r'[a-z]').hasMatch(p);
    final bool hasNumber = RegExp(r'[0-9]').hasMatch(p);
    final bool hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(p);
    
    final bool allReqsMet = hasLength && hasUpper && hasLower && hasNumber && hasSpecial;
    
    return isNotEmpty && allReqsMet && passwordsMatch;
  }

  void _handleUpdatePassword() {
    // Navigate to password updated success screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const PasswordUpdatedScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/brand.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 80),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headings
              Text(
                'Create a New Password',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryTextOffWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose a strong password to keep your Ulvenik account secure.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),

              // Main Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New Password Section
                    const Text(
                      'New Password',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your new password',
                        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryForestGreen),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.secondaryTextStoneGrey, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Strength Indicator & Checklist
                    PasswordStrengthIndicator(
                      password: _passwordController.text,
                      isVisible: true,
                    ),
                    
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 24),
                    
                    // Confirm Password Section
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Confirm your new password',
                        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryForestGreen),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.secondaryTextStoneGrey, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Update Button
                    ElevatedButton(
                      onPressed: _isButtonEnabled ? _handleUpdatePassword : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        disabledBackgroundColor: AppColors.primaryForestGreen.withOpacity(0.3),
                        disabledForegroundColor: AppColors.primaryTextOffWhite.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 52),
                      ),
                      child: const Text(
                        'Update Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Back to Login
              Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
