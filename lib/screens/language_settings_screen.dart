import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class LanguageSettingsScreen extends StatefulWidget {
  final String currentLanguage;

  const LanguageSettingsScreen({
    super.key,
    this.currentLanguage = 'English (United Kingdom)',
  });

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedLanguage;
  bool _useDeviceLanguage = false;

  final List<Map<String, String>> _languages = [
    {'title': 'English (United Kingdom)', 'subtitle': 'English • United Kingdom'},
    {'title': 'English (United States)', 'subtitle': 'English • United States'},
    {'title': 'Deutsch', 'subtitle': 'German'},
    {'title': 'Español', 'subtitle': 'Spanish'},
    {'title': 'Français', 'subtitle': 'French'},
    {'title': 'Svenska', 'subtitle': 'Swedish'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, _selectedLanguage);
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
          'Language',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Apply', style: TextStyle(color: _forest, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            children: [
              // CURRENT LANGUAGE
              const Text(
                'CURRENT LANGUAGE',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: _offWhite, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedLanguage,
                            style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text('Interface language • English', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242A2E),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Text('CURRENT', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // USE DEVICE LANGUAGE TOGGLE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_iphone, color: _stoneGrey, size: 20),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use Device Language',
                            style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ulvenik follows your device language setting',
                            style: TextStyle(color: _stoneGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _useDeviceLanguage,
                      activeThumbColor: _mint,
                      activeTrackColor: _forest,
                      onChanged: (v) => setState(() => _useDeviceLanguage = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // SEARCH LANGUAGES INPUT
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: _stoneGrey, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: _offWhite, fontSize: 14),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search languages',
                          hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SUPPORTED LANGUAGES
              const Text(
                'SUPPORTED LANGUAGES',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _languages.length; i++) ...[
                      InkWell(
                        onTap: () => setState(() => _selectedLanguage = _languages[i]['title']!),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _languages[i]['title']!,
                                      style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(_languages[i]['subtitle']!, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              if (_selectedLanguage == _languages[i]['title'])
                                const Icon(Icons.check, color: _mint, size: 20),
                            ],
                          ),
                        ),
                      ),
                      if (i < _languages.length - 1)
                        const Divider(color: _cardBorder, height: 1),
                    ],
                    const Divider(color: _cardBorder, height: 1),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'More languages coming soon',
                          style: TextStyle(color: _stoneGrey, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // BOTTOM APPLY BUTTON & FOOTER
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _save,
                    child: const Text('Apply Language', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'User-created content will not be translated.',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
