import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'welcome_screen.dart';
import '../widgets/custom_snackbar.dart'; // or whatever the next destination is

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      setState(() => _currentStep++);
    } else {
      // Finish setup
      // Navigate to homepage or welcome screen
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryForestGreen),
          onPressed: () {
            if (_currentStep > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
              );
              setState(() => _currentStep--);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Two-Factor Authentication',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white.withOpacity(0.05), height: 1.0),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          _buildStepper(),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildScanStep(),
                _buildVerifyStep(),
                _buildCodesStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep(label: 'SCAN', isActive: _currentStep >= 0, isCurrent: _currentStep == 0),
          _buildLine(isActive: _currentStep >= 1),
          _buildStep(label: 'VERIFY', isActive: _currentStep >= 1, isCurrent: _currentStep == 1),
          _buildLine(isActive: _currentStep >= 2),
          _buildStep(label: 'CODES', isActive: _currentStep >= 2, isCurrent: _currentStep == 2),
        ],
      ),
    );
  }

  Widget _buildStep({required String label, required bool isActive, required bool isCurrent}) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent 
                ? AppColors.primaryForestGreen.withOpacity(0.2) 
                : (isActive ? AppColors.primaryForestGreen : Colors.transparent),
            border: Border.all(
              color: isActive ? AppColors.primaryForestGreen : Colors.white12,
              width: 2,
            ),
          ),
          child: isCurrent
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryForestGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : (isActive 
                  ? const Icon(Icons.check, size: 16, color: AppColors.primaryTextOffWhite) 
                  : null),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
        height: 2,
        color: isActive ? AppColors.primaryForestGreen : Colors.white.withOpacity(0.05),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 1: SCAN
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildScanStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SCAN WITH YOUR APP',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                // Real-looking Mock QR Code
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 196,
                        height: 196,
                        child: CustomPaint(
                          painter: _MockQRPainter(),
                        ),
                      ),
                      // Center padlock overlay
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryTextOffWhite,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Point your authenticator app camera at this code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 24),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MANUAL ENTRY KEY',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ABCD EFGH IJKL MNOP',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 16,
                              letterSpacing: 2.0,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                        icon: const Icon(
                          Icons.copy_outlined,
                          size: 18,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton(label: 'Continue', onTap: _nextStep),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 2: VERIFY
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildVerifyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ENTER VERIFICATION CODE',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                const Text(
                  'Enter the 6-digit code generated by your authenticator app to verify the connection.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // 6-digit Input visual mock
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 44,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: index == 0 ? AppColors.primaryForestGreen : Colors.white12,
                          width: index == 0 ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: index == 0
                          ? Container(width: 2, height: 24, color: AppColors.primaryForestGreen)
                          : null,
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 14,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Code refreshes every 30 seconds.',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton(label: 'Verify Code', onTap: _nextStep),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3: CODES
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCodesStep() {
    final List<String> dummyCodes = [
      '8492-1038', '5729-4810', '3910-5829', '1029-4857', '5829-1039',
      '9482-1039', '4829-5012', '5810-3948', '2948-1058', '5820-1938',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'BACKUP RECOVERY CODES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                const Text(
                  'Save these backup codes in a secure place. If you lose access to your authenticator app, you can use these to log in.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dummyCodes[index],
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontFamily: 'monospace',
                            letterSpacing: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy All Codes'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton(label: 'Finish Setup', onTap: _nextStep),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String label, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// Custom painter to draw a crisp, realistic mock QR code
class _MockQRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final double step = size.width / 21; // 21x21 grid standard

    // Draw position detection squares (top-left, top-right, bottom-left)
    _drawFinder(canvas, paint, 0, 0, step);
    _drawFinder(canvas, paint, 14 * step, 0, step);
    _drawFinder(canvas, paint, 0, 14 * step, step);

    // Random noise for the rest
    final Random random = Random(42); // Fixed seed for stable UI
    for (int i = 0; i < 21; i++) {
      for (int j = 0; j < 21; j++) {
        // Skip finder areas
        if ((i < 8 && j < 8) || (i > 13 && j < 8) || (i < 8 && j > 13)) continue;
        
        // Skip middle center for the padlock overlay
        if (i > 7 && i < 14 && j > 7 && j < 14) continue;

        if (random.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(i * step, j * step, step, step),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(Canvas canvas, Paint paint, double x, double y, double step) {
    // Outer box
    canvas.drawRect(Rect.fromLTWH(x, y, 7 * step, 7 * step), paint);
    // Inner white box
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + step, y + step, 5 * step, 5 * step), whitePaint);
    // Inner black core
    canvas.drawRect(Rect.fromLTWH(x + 2 * step, y + 2 * step, 3 * step, 3 * step), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
