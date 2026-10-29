import 'package:flutter/material.dart';

/// Screen / Modal: Change Profile Photo (Node / frame change_photo.png)
/// Displays handler active photo preview with options to capture,
/// select from library, or remove the current canine/handler photo.
class ChangePhotoScreen extends StatefulWidget {
  final String handlerName;
  final String handlerRole;

  const ChangePhotoScreen({
    super.key,
    this.handlerName = 'Lars Viken',
    this.handlerRole = 'K9 Tracking Specialist • Level 4',
  });

  @override
  State<ChangePhotoScreen> createState() => _ChangePhotoScreenState();
}

class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);
  static const Color _errorRed = Color(0xFFE5484D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Handler Profile',
          style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.more_horiz, color: _stoneGrey),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Background Profile View
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF263033),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Icon(Icons.person, color: _mint, size: 54),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.handlerName,
                    style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.handlerRole,
                    style: const TextStyle(color: _stoneGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Overlay Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag bar indicator
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Profile Photo',
                    style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Avatar with active green dot
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _mint, width: 2),
                          color: const Color(0xFF1E262B),
                        ),
                        child: const Icon(Icons.person, color: _mint, size: 48),
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _forest,
                          shape: BoxShape.circle,
                          border: Border.all(color: _obsidian, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'CURRENT ACTIVE',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 20),

                  // Option 1: Take Photo
                  _buildOptionTile(
                    icon: Icons.camera_alt_outlined,
                    label: 'Take Photo',
                    color: _offWhite,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera opened'), backgroundColor: _forest),
                      );
                    },
                  ),
                  const Divider(color: _cardBorder, height: 1),

                  // Option 2: Choose from Photo Library
                  _buildOptionTile(
                    icon: Icons.photo_library_outlined,
                    label: 'Choose from Photo Library',
                    color: _offWhite,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Photo library opened'), backgroundColor: _forest),
                      );
                    },
                  ),
                  const Divider(color: _cardBorder, height: 1),

                  // Option 3: Remove Current Photo
                  _buildOptionTile(
                    icon: Icons.delete_outline,
                    label: 'Remove Current Photo',
                    color: _errorRed,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile photo reset'), backgroundColor: _forest),
                      );
                    },
                  ),
                  const Divider(color: _cardBorder, height: 1),

                  // Option 4: Cancel
                  _buildOptionTile(
                    icon: Icons.close,
                    label: 'Cancel',
                    color: _stoneGrey,
                    onTap: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

