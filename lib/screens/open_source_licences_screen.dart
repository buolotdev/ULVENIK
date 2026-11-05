import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _LicencePackage {
  final String name;
  final String version;
  final String licenceType;
  final String copyright;
  final String repository;
  final String description;
  final IconData icon;

  const _LicencePackage({
    required this.name,
    required this.version,
    required this.licenceType,
    required this.copyright,
    required this.repository,
    required this.description,
    required this.icon,
  });
}

class OpenSourceLicencesScreen extends StatefulWidget {
  const OpenSourceLicencesScreen({super.key});

  @override
  State<OpenSourceLicencesScreen> createState() =>
      _OpenSourceLicencesScreenState();
}

class _OpenSourceLicencesScreenState extends State<OpenSourceLicencesScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _badgeBg = Color(0xFF323533);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedLicenceFilter = 'All';

  static const List<String> _licenceFilters = [
    'All',
    'BSD 3-CLAUSE',
    'APACHE 2.0',
    'MIT',
  ];

  static const List<_LicencePackage> _packages = [
    _LicencePackage(
      name: 'Flutter',
      version: 'Version 3.24.0',
      licenceType: 'BSD 3-CLAUSE',
      copyright: 'Copyright 2014 The Flutter Authors. All rights reserved.',
      repository: 'github.com/flutter/flutter',
      description:
          'Google UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
      icon: Icons.data_object_rounded,
    ),
    _LicencePackage(
      name: 'Firebase',
      version: 'Version 10.x.x',
      licenceType: 'APACHE 2.0',
      copyright: 'Copyright 2024 Google LLC',
      repository: 'github.com/firebase/flutterfire',
      description:
          'Official FlutterFire plugins providing cloud sync, authentication, and secure storage services.',
      icon: Icons.storage_outlined,
    ),
    _LicencePackage(
      name: 'provider',
      version: 'Version 6.1.2',
      licenceType: 'MIT',
      copyright: 'Copyright (c) 2019 Remi Rousselet',
      repository: 'github.com/rrousselGit/provider',
      description:
          'A wrapper around InheritedWidget to make state management and dependency injection predictable and composable.',
      icon: Icons.swap_horiz_rounded,
    ),
    _LicencePackage(
      name: 'go_router',
      version: 'Version 13.x.x',
      licenceType: 'BSD 3-CLAUSE',
      copyright: 'Copyright 2013 The Flutter Authors. All rights reserved.',
      repository: 'github.com/flutter/packages/tree/main/packages/go_router',
      description:
          'Declarative routing package for Flutter using the Router API for deep linking and nested navigation.',
      icon: Icons.alt_route_rounded,
    ),
    _LicencePackage(
      name: 'image_picker',
      version: 'Version 1.x.x',
      licenceType: 'APACHE 2.0',
      copyright: 'Copyright 2013 The Flutter Authors. All rights reserved.',
      repository: 'github.com/flutter/packages/tree/main/packages/image_picker',
      description:
          'Cross-platform media selection plugin for capturing training photos, videos, and profile avatars.',
      icon: Icons.collections_outlined,
    ),
    _LicencePackage(
      name: 'shared_preferences',
      version: 'Version 2.x.x',
      licenceType: 'BSD 3-CLAUSE',
      copyright: 'Copyright 2013 The Flutter Authors. All rights reserved.',
      repository:
          'github.com/flutter/packages/tree/main/packages/shared_preferences',
      description:
          'Persistent key-value storage wrapper for local app preferences and offline state.',
      icon: Icons.tune_rounded,
    ),
    _LicencePackage(
      name: 'fl_chart',
      version: 'Version 0.68.x',
      licenceType: 'MIT',
      copyright: 'Copyright (c) 2020 Iman Khoshabi',
      repository: 'github.com/imaNNeo/fl_chart',
      description:
          'Customizable charting engine used for training analytics, weight trends, and session statistics.',
      icon: Icons.show_chart_rounded,
    ),
    _LicencePackage(
      name: 'intl',
      version: 'Version 0.19.x',
      licenceType: 'BSD 3-CLAUSE',
      copyright: 'Copyright 2013, the Dart project authors.',
      repository: 'github.com/dart-lang/i18n/tree/main/pkgs/intl',
      description:
          'Internationalization and localization utilities including date/time formatting, plurals, and measurement formatting.',
      icon: Icons.language_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_LicencePackage> get _filteredPackages {
    final q = _searchQuery.trim().toLowerCase();
    return _packages.where((pkg) {
      if (_selectedLicenceFilter != 'All' &&
          pkg.licenceType != _selectedLicenceFilter) {
        return false;
      }
      if (q.isEmpty) return true;
      return pkg.name.toLowerCase().contains(q) ||
          pkg.version.toLowerCase().contains(q) ||
          pkg.licenceType.toLowerCase().contains(q) ||
          pkg.description.toLowerCase().contains(q);
    }).toList();
  }

  String _fullLicenceTextFor(_LicencePackage pkg) {
    switch (pkg.licenceType) {
      case 'MIT':
        return '''MIT License

${pkg.copyright}

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.''';

      case 'APACHE 2.0':
        return '''Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

${pkg.copyright}

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.''';

      case 'BSD 3-CLAUSE':
      default:
        return '''BSD 3-Clause License

${pkg.copyright}

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE.''';
    }
  }

  void _openLicenceViewer(_LicencePackage pkg) {
    final fullText = _fullLicenceTextFor(pkg);

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetCtx).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTextStoneGrey
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: UlvenikIcon.fromMaterial(
                          pkg.icon,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    pkg.name,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildLicenceBadge(pkg.licenceType),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${pkg.version} • ${pkg.repository}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        icon: const Icon(Icons.close_rounded,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pkg.description,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13.5,
                            height: 1.48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'FULL LICENCE TEXT',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundObsidian,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: SelectableText(
                            fullText,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 12,
                              height: 1.52,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: fullText),
                                  );
                                  Navigator.of(sheetCtx).pop();
                                  AppSnackbar.show(
                                    context,
                                    title: 'Licence Copied',
                                    message:
                                        'Copied ${pkg.name} (${pkg.licenceType}) licence text.',
                                    type: SnackbarType.success,
                                  );
                                },
                                icon: const Icon(Icons.copy_rounded,
                                  size: 16,
                                  color: _mint,
                                ),
                                label: const Text(
                                  'Copy Licence Text',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: _mint,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.primaryForestGreen
                                      .withValues(alpha: 0.2),
                                  side: BorderSide(
                                    color: AppColors.primaryForestGreen
                                        .withValues(alpha: 0.5),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLicenceBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filteredPackages;
    final isFiltered =
        _searchQuery.trim().isNotEmpty || _selectedLicenceFilter != 'All';

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const UlvenikIcon(UlvenikIcons.back,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 26,
                      ),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 2),
                    const Expanded(
                      child: Text(
                        'Open Source Licences',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OPEN SOURCE',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.code_rounded,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 20,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Open Source Software',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ulvenik is built using a number of trusted open-source libraries and frameworks. We gratefully acknowledge the developers and communities who maintain these projects.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const UlvenikIcon(UlvenikIcons.search,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                      ),
                      cursorColor: _mint,
                      decoration: const InputDecoration(
                        hintText: 'Search Libraries',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.close_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _licenceFilters.map((filter) {
                  final selected = _selectedLicenceFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLicenceFilter = filter;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryForestGreen
                                  .withValues(alpha: 0.24)
                              : AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? _mint.withValues(alpha: 0.5)
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          filter == 'All' ? 'All Licences' : filter,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: selected
                                ? _mint
                                : AppColors.secondaryTextStoneGrey,
                            fontSize: 11.5,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LIBRARIES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  isFiltered
                      ? '${visible.length} of ${_packages.length}'
                      : '${_packages.length} Total',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (visible.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No libraries match your filter',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                          _selectedLicenceFilter = 'All';
                        });
                      },
                      child: const Text(
                        'Show all libraries',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _mint,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < visible.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, color: AppColors.cardBorder),
                      _buildLibraryRow(visible[i]),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 28),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      UlvenikIcon(UlvenikIcons.completed,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 15,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'ULVENIK CORE ENGINE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Version 2.4.1 (Build 4092)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildLibraryRow(_LicencePackage pkg) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openLicenceViewer(pkg),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: UlvenikIcon.fromMaterial(
                  pkg.icon,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 19,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pkg.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      pkg.version,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildLicenceBadge(pkg.licenceType),
              const SizedBox(width: 8),
              const UlvenikIcon(UlvenikIcons.details,
                color: AppColors.secondaryTextStoneGrey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
