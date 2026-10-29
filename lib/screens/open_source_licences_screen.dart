import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);

class OpenSourceLicencesScreen extends StatefulWidget {
  const OpenSourceLicencesScreen({super.key});

  @override
  State<OpenSourceLicencesScreen> createState() =>
      _OpenSourceLicencesScreenState();
}

class _OpenSourceLicencesScreenState extends State<OpenSourceLicencesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _libraries = [
    {
      'name': 'Flutter',
      'version': 'Version 3.24.0',
      'license': 'BSD 3-CLAUSE',
      'icon': Icons.code,
      'text': 'Copyright 2014 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\n1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.',
    },
    {
      'name': 'Firebase',
      'version': 'Version 10.x.x',
      'license': 'APACHE 2.0',
      'icon': Icons.storage_outlined,
      'text': 'Copyright 2020 Google LLC\n\nLicensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.',
    },
    {
      'name': 'provider',
      'version': 'Version 6.1.2',
      'license': 'MIT',
      'icon': Icons.sync_alt,
      'text': 'MIT License\n\nCopyright (c) 2019 Remi Rousselet\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction.',
    },
    {
      'name': 'go_router',
      'version': 'Version 13.x.x',
      'license': 'BSD 3-CLAUSE',
      'icon': Icons.alt_route,
      'text': 'Copyright 2013 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted.',
    },
    {
      'name': 'image_picker',
      'version': 'Version 1.x.x',
      'license': 'APACHE 2.0',
      'icon': Icons.photo_outlined,
      'text': 'Copyright 2013 The Flutter Authors. All rights reserved.\n\nLicensed under the Apache License, Version 2.0.',
    },
    {
      'name': 'shared_preferences',
      'version': 'Version 2.x.x',
      'license': 'BSD 3-CLAUSE',
      'icon': Icons.tune,
      'text': 'Copyright 2013 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted.',
    },
    {
      'name': 'fl_chart',
      'version': 'Version 0.68.x',
      'license': 'MIT',
      'icon': Icons.show_chart,
      'text': 'MIT License\n\nCopyright (c) 2019 Iman Khoshabi\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software.',
    },
    {
      'name': 'intl',
      'version': 'Version 0.19.x',
      'license': 'BSD 3-CLAUSE',
      'icon': Icons.language,
      'text': 'Copyright 2013, the Dart project authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      case 4:
        target = const MorePageScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _showLicenseModal(Map<String, dynamic> lib) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _mutedGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lib['name'] as String,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14191C),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    lib['license'] as String,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              lib['version'] as String,
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _cardBorder),
              ),
              child: Text(
                lib['text'] as String,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close', style: TextStyle(color: _offWhite)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _libraries.where((l) {
      if (_searchQuery.isEmpty) return true;
      final n = (l['name'] as String).toLowerCase();
      final lic = (l['license'] as String).toLowerCase();
      return n.contains(_searchQuery) || lic.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Open Source Licences ────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Open Source Licences',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── OPEN SOURCE Card ──────────────────────────────────
                  _buildSectionHeader('OPEN SOURCE'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.code, color: _stoneGrey, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Open Source Software',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ulvenik is built using a number of trusted open-source libraries and frameworks. We gratefully acknowledge the developers and communities who maintain these projects.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Search Bar ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: _stoneGrey, size: 20),
                        hintText: 'Search Libraries',
                        hintStyle: TextStyle(color: _mutedGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── LIBRARIES ─────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('LIBRARIES'),
                      Text(
                        '${_libraries.length} Total',
                        style: const TextStyle(
                          color: _mutedGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: filtered.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final lib = entry.value;
                        final isLast = idx == filtered.length - 1;

                        return Column(
                          children: [
                            InkWell(
                              onTap: () => _showLicenseModal(lib),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    Icon(lib['icon'] as IconData,
                                        color: _stoneGrey, size: 20),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lib['name'] as String,
                                            style: const TextStyle(
                                              color: _offWhite,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            lib['version'] as String,
                                            style: const TextStyle(
                                              color: _stoneGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF14191C),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: _cardBorder),
                                      ),
                                      child: Text(
                                        lib['license'] as String,
                                        style: const TextStyle(
                                          color: _stoneGrey,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.chevron_right,
                                        color: _stoneGrey, size: 16),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                color: Color(0x0FFFFFFF),
                                indent: 50,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Footer: ULVENIK CORE ENGINE ───────────────────────
                  const Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_outlined,
                                color: _stoneGrey, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'ULVENIK CORE ENGINE',
                              style: TextStyle(
                                color: _mutedGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 2.4.1 (Build 4092)',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}
