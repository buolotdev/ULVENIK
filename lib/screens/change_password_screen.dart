import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController(text: 'VardøNord2024!');
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = false;
  bool _obscureConfirm = true;
  bool _signOutOthers = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasUppercase => _newPasswordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _newPasswordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _newPasswordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newPasswordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  int get _score {
    int count = 0;
    if (_hasMinLength) count++;
    if (_hasUppercase) count++;
    if (_hasLowercase) count++;
    if (_hasNumber) count++;
    if (_hasSpecial) count++;
    return count;
  }

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Password Updated', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your account password has been updated successfully. Please use your new credentials on your next login.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _score;
    String strengthLabel = 'Weak';
    if (score >= 4) {
      strengthLabel = 'Strong';
    } else if (score >= 2) {
      strengthLabel = 'Medium';
    }

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          const SizedBox(height: 12),
          // SHIELD ICON
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF1B2321),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, color: _mint, size: 26),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Keep Your Account Secure',
            style: TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            "Choose a strong password that you don't\nuse anywhere else.",
            style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // SECTION CHANGE PASSWORD
          const Text(
            'CHANGE PASSWORD',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Password
                const Text('Current Password', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrent,
                  style: const TextStyle(color: _offWhite, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5), fontSize: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _stoneGrey, size: 20),
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
                const SizedBox(height: 20),

                // New Password
                const Text('New Password', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  style: const TextStyle(color: _offWhite, fontSize: 15),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _stoneGrey, size: 20),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
                const SizedBox(height: 14),

                // Strength bar (5 segments)
                Row(
                  children: List.generate(5, (index) {
                    final filled = index < score;
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: filled ? _forest : const Color(0xFF2C3236),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    strengthLabel,
                    style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 14),

                // Checklist
                _buildCheckItem('Minimum 8 characters', _hasMinLength),
                const SizedBox(height: 8),
                _buildCheckItem('At least one uppercase letter', _hasUppercase),
                const SizedBox(height: 8),
                _buildCheckItem('At least one lowercase letter', _hasLowercase),
                const SizedBox(height: 8),
                _buildCheckItem('At least one number', _hasNumber),
                const SizedBox(height: 8),
                _buildCheckItem('At least one special character', _hasSpecial),
                const SizedBox(height: 20),

                // Confirm Password
                const Text('Confirm New Password', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: const TextStyle(color: _offWhite, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your new password',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5), fontSize: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _stoneGrey, size: 20),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),

                // Sign out of all other devices
                Row(
                  children: [
                    const Icon(Icons.phone_iphone, color: _stoneGrey, size: 20),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sign out of all other devices', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text("You'll need to sign in again on your other devices.", style: TextStyle(color: _stoneGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _signOutOthers,
                      activeThumbColor: _mint,
                      activeTrackColor: _forest,
                      onChanged: (v) => setState(() => _signOutOthers = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // INFO CALLOUT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: _stoneGrey, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Changing your password does not affect your dogs, training records or subscriptions.',
                    style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // BUTTONS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _offWhite, strokeWidth: 2))
                  : const Text('Update Password', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: _offWhite, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool satisfied) {
    return Row(
      children: [
        Icon(
          satisfied ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: satisfied ? _mint : _stoneGrey,
          size: 16,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: satisfied ? _mint : _stoneGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
