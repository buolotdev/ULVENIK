import 'package:flutter/material.dart';
import '../screens/image_editor_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _red = Color(0xFFE53E3E);

class ChangePhotoBottomSheet extends StatefulWidget {
  final bool initialEmpty;
  final String title;

  const ChangePhotoBottomSheet({
    super.key,
    this.initialEmpty = false,
    this.title = 'Change Profile Photo',
  });

  static Future<bool?> show(
    BuildContext context, {
    bool initialEmpty = false,
    String title = 'Change Profile Photo',
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangePhotoBottomSheet(
        initialEmpty: initialEmpty,
        title: title,
      ),
    );
  }

  @override
  State<ChangePhotoBottomSheet> createState() => _ChangePhotoBottomSheetState();
}

class _ChangePhotoBottomSheetState extends State<ChangePhotoBottomSheet> {
  late bool _isEmpty;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
  }

  void _openImageEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImageEditorScreen()),
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header & Empty State Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                IconButton(
                  tooltip: 'Toggle Empty / Existing Photo State',
                  icon: Icon(
                    _isEmpty ? Icons.visibility : Icons.visibility_off_outlined,
                    color: _mint,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isEmpty = !_isEmpty),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Photo Preview Strip
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF131718),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isEmpty ? _carbon : _forest,
                      border: Border.all(color: _isEmpty ? _stoneGrey : _mint, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        _isEmpty ? Icons.person_outline : Icons.pets,
                        color: _isEmpty ? _stoneGrey : _mint,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEmpty ? 'No Profile Photo Set' : 'Current Active Portrait',
                          style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isEmpty
                              ? 'Tap an option below to upload an image.'
                              : 'Recommended minimum: 800 x 800 px (1:1).',
                          style: const TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Action Options
            _buildActionOption(
              icon: Icons.camera_alt_outlined,
              title: 'Take Photo',
              subtitle: 'Capture new canine photo using camera',
              onTap: _openImageEditor,
            ),
            const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 48),
            _buildActionOption(
              icon: Icons.photo_library_outlined,
              title: 'Choose from Photo Library',
              subtitle: 'Select from device photo album',
              onTap: _openImageEditor,
            ),
            const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 48),
            _buildActionOption(
              icon: Icons.perm_media_outlined,
              title: 'Select from Canine Media Assets',
              subtitle: 'Choose from uploaded 4K drill snapshots',
              onTap: _openImageEditor,
            ),

            if (!_isEmpty) ...[
              const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 48),
              _buildActionOption(
                icon: Icons.delete_outline,
                title: 'Remove Current Photo',
                subtitle: 'Revert to initial avatar placeholder',
                isDestructive: true,
                onTap: () {
                  setState(() => _isEmpty = true);
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile photo removed.'),
                      backgroundColor: _forest,
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final color = isDestructive ? _red : _offWhite;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDestructive ? _red.withValues(alpha: 0.15) : _mint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: isDestructive ? _red : _mint, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
