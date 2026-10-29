import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ChangeEmailScreen extends StatefulWidget {
  final String currentEmail;

  const ChangeEmailScreen({
    super.key,
    this.currentEmail = 'olivia@email.com',
  });

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _newEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _newEmailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid new email address.'),
          backgroundColor: Color(0xFFE5484D),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Verification Sent', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: Text(
          'A verification link has been dispatched to $email. Please confirm the link to finalize your new email address.',
          style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
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
          'Change Email Address',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // ENVELOPE ICON
            const Icon(Icons.mail_outline, color: _offWhite, size: 36),
            const SizedBox(height: 20),
            // TITLE & SUBTITLE
            const Text(
              'Update Your Email Address',
              style: TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "We'll send a verification email to your new address before making any changes to your account.",
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            // INPUT CARD
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
                  const Text(
                    'CURRENT EMAIL',
                    style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.currentEmail,
                        style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.lock_outline, color: _stoneGrey, size: 18),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: _cardBorder),
                  const SizedBox(height: 16),
                  const Text(
                    'NEW EMAIL ADDRESS',
                    style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                  TextField(
                    controller: _newEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: _offWhite, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Enter your new email address',
                      hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5), fontSize: 14),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                      'Your current email will remain active until your new email has been verified.',
                      style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // CONTINUE BUTTON
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
                    : const Text('Continue', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
