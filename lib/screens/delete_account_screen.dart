import 'package:flutter/material.dart';
import 'subscription_details_screen.dart';
import 'welcome_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _crimson = Color(0xFFE5484D);

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acknowledged = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Account Deletion', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you absolutely sure? All canine profiles, telemetry, logs, and media will be permanently destroyed.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _crimson,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Permanently Delete', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _acknowledged;

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
          'Delete Account',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // RED WARNING BANNER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: const BorderSide(color: _crimson, width: 4),
                top: BorderSide(color: _cardBorder.withValues(alpha: 0.1)),
                right: BorderSide(color: _cardBorder.withValues(alpha: 0.1)),
                bottom: BorderSide(color: _cardBorder.withValues(alpha: 0.1)),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: _crimson, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Delete Your Ulvenik Account',
                      style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Deleting your account is permanent. Once completed, your account and all associated data cannot be recovered.',
                  style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // WHAT WILL BE PERMANENTLY DELETED
          const Text(
            'WHAT WILL BE PERMANENTLY DELETED',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildDeletedRow('Account & Profile', 'Photos & Videos'),
                const SizedBox(height: 10),
                _buildDeletedRow('Dog Profiles', 'Documents & Notes'),
                const SizedBox(height: 10),
                _buildDeletedRow('Training Sessions', 'Custom Skills'),
                const SizedBox(height: 10),
                _buildDeletedRow('S&C Records', 'Custom Exercises'),
                const SizedBox(height: 10),
                _buildDeletedRow('Goals', 'Trainer Pack Data'),
                const SizedBox(height: 10),
                _buildDeletedRow('Statistics', 'Sport Pack Data'),
                const SizedBox(height: 10),
                _buildDeletedRow('Timeline', 'Cloud Backups'),
                const SizedBox(height: 10),
                _buildDeletedRow('Health Records', 'Saved Preferences'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // WHAT MAY BE RETAINED
          const Text(
            'WHAT MAY BE RETAINED',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRetainedItem('Purchase Records'),
                const SizedBox(height: 8),
                _buildRetainedItem('Subscription Invoices'),
                const SizedBox(height: 8),
                _buildRetainedItem('Payment History'),
                const SizedBox(height: 8),
                _buildRetainedItem('Security Logs'),
                const SizedBox(height: 8),
                _buildRetainedItem('Legal Compliance Records'),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 8),
                const Text(
                  'These records are retained only where required by law and are not used as part of your Ulvenik account after deletion.',
                  style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // BEFORE YOU DELETE
          const Text(
            'BEFORE YOU DELETE',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consider these options first',
                  style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'If you only want to stop using Ulvenik, consider cancelling your subscription or signing out instead.',
                  style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionDetailsScreen()));
                    },
                    child: const Text('Manage Subscription', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Sign Out Instead', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // VERIFY YOUR IDENTITY
          const Text(
            'VERIFY YOUR IDENTITY',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Biometric authentication prompt simulated.'), backgroundColor: _forest),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, color: _stoneGrey, size: 20),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm with Face ID / Touch ID',
                              style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text('Or enter your password below', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text(
                  'PASSWORD',
                  style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5), fontSize: 13),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _stoneGrey, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ACKNOWLEDGMENT CHECKBOX
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acknowledged,
                activeColor: _crimson,
                checkColor: _offWhite,
                side: const BorderSide(color: _stoneGrey),
                onChanged: (val) => setState(() => _acknowledged = val ?? false),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'I understand that deleting my account is permanent and cannot be undone.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ACTION BUTTONS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canDelete ? _crimson : const Color(0xFF2C1E20),
                foregroundColor: canDelete ? _offWhite : _crimson.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: canDelete ? _showDeleteConfirmation : null,
              child: const Text('Delete My Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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

  Widget _buildDeletedRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _crimson, width: 1.2),
                ),
                child: const Center(
                  child: Icon(Icons.close, color: _crimson, size: 9),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(left, style: const TextStyle(color: _offWhite, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _crimson, width: 1.2),
                ),
                child: const Center(
                  child: Icon(Icons.close, color: _crimson, size: 9),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(right, style: const TextStyle(color: _offWhite, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRetainedItem(String text) {
    return Row(
      children: [
        const Icon(Icons.info_outline, color: _stoneGrey, size: 14),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: _offWhite, fontSize: 13)),
      ],
    );
  }
}
