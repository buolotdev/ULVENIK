import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class CountryRegionScreen extends StatefulWidget {
  final String currentCountry;

  const CountryRegionScreen({
    super.key,
    this.currentCountry = 'United Kingdom',
  });

  @override
  State<CountryRegionScreen> createState() => _CountryRegionScreenState();
}

class _CountryRegionScreenState extends State<CountryRegionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCountry;

  final Map<String, List<Map<String, String>>> _allCountries = {
    'A': [
      {'name': 'Australia', 'code': 'AU'},
      {'name': 'Austria', 'code': 'AT'},
    ],
    'C': [
      {'name': 'Canada', 'code': 'CA'},
    ],
    'D': [
      {'name': 'Denmark', 'code': 'DK'},
    ],
    'F': [
      {'name': 'Finland', 'code': 'FI'},
      {'name': 'France', 'code': 'FR'},
    ],
    'G': [
      {'name': 'Germany', 'code': 'DE'},
    ],
    'N': [
      {'name': 'Norway', 'code': 'NO'},
    ],
    'S': [
      {'name': 'Sweden', 'code': 'SE'},
      {'name': 'Switzerland', 'code': 'CH'},
    ],
    'U': [
      {'name': 'United Kingdom', 'code': 'GB'},
      {'name': 'United States', 'code': 'US'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.currentCountry;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, _selectedCountry);
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
          'Country or Region',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Continue', style: TextStyle(color: _forest, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 36, 100),
            children: [
              // CURRENT COUNTRY
              const Text(
                'CURRENT COUNTRY',
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
                    _buildFlagBox('GB'),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('United Kingdom', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('GB • Great Britain', style: TextStyle(color: _stoneGrey, fontSize: 12)),
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

              // SEARCH INPUT
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
                          hintText: 'Search countries or regions',
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

              // SUGGESTED
              const Text(
                'SUGGESTED',
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildFlagBox('GB'),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('United Kingdom', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text('GB', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          if (_selectedCountry == 'United Kingdom') const Icon(Icons.check, color: _mint, size: 20),
                        ],
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text('🇬🇧', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          Text('Device Region detected: United Kingdom', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ALL COUNTRIES
              const Text(
                'ALL COUNTRIES',
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
                    for (final entry in _allCountries.entries) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: const Color(0xFF14191C),
                        child: Text(
                          entry.key,
                          style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (final c in entry.value) ...[
                        InkWell(
                          onTap: () => setState(() => _selectedCountry = c['name']!),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                _buildFlagBox(c['code']!),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['name']!, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Text(c['code']!, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                if (_selectedCountry == c['name']) const Icon(Icons.check, color: _mint, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: _cardBorder, height: 1),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),

          // ALPHABET RAIL ON RIGHT
          Positioned(
            right: 4,
            top: 100,
            bottom: 120,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
                    .map((letter) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.5),
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: _allCountries.containsKey(letter) ? _offWhite : _stoneGrey.withValues(alpha: 0.4),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          // BOTTOM CONTINUE BUTTON & FOOTER
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
                    child: const Text('Continue', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Changing country will not affect your language, units, or time zone.',
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

  Widget _buildFlagBox(String code) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF242A2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Center(
        child: Text(
          code,
          style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
