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

class OpenSourceLicencesScreen extends StatefulWidget {
  const OpenSourceLicencesScreen({super.key});

  @override
  State<OpenSourceLicencesScreen> createState() =>
      _OpenSourceLicencesScreenState();
}

class _OpenSourceLicencesScreenState extends State<OpenSourceLicencesScreen> {
  final Set<int> _expandedIndices = {};

  final List<Map<String, String>> _packages = [
    {
      'name': 'Flutter Framework',
      'license': 'BSD-3-Clause',
      'author': 'Google LLC',
      'text': 'Copyright 2014 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\n1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.',
    },
    {
      'name': 'fl_chart',
      'license': 'MIT License',
      'author': 'Iman Khoshabi',
      'text': 'Copyright (c) 2019 Iman Khoshabi\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.',
    },
    {
      'name': 'intl',
      'license': 'BSD-3-Clause',
      'author': 'Dart Project Authors',
      'text': 'Copyright 2013, the Dart project authors. All rights reserved.\n\nRedistribution and use in source and binary forms, with or without modification, are permitted provided that conditions are met.',
    },
    {
      'name': 'google_fonts',
      'license': 'Apache License 2.0',
      'author': 'Google LLC',
      'text': 'Copyright 2020 Google LLC\n\nLicensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.',
    },
    {
      'name': 'path_provider',
      'license': 'BSD-3-Clause',
      'author': 'Flutter Authors',
      'text': 'Copyright 2013 The Flutter Authors. All rights reserved.\n\nRedistribution and use in source and binary forms are permitted provided conditions are met.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Open Source Licences',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. ACKNOWLEDGMENT HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.code, color: _mint, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Open Source Acknowledgments',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Third-party software libraries powering Ulvenik',
                        style: TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. PACKAGES LIST
          ..._packages.asMap().entries.map((entry) {
            final idx = entry.key;
            final pkg = entry.value;
            final isExpanded = _expandedIndices.contains(idx);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedIndices.remove(idx);
                        } else {
                          _expandedIndices.add(idx);
                        }
                      });
                    },
                    title: Text(
                      pkg['name']!,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    subtitle: Text(
                      '${pkg['license']} • ${pkg['author']}',
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: isExpanded ? _mint : _stoneGrey,
                      size: 20,
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131718),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pkg['text']!,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 10,
                            fontFamily: 'monospace',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
