import 'package:flutter/material.dart';

enum SnackbarType { error, success, warning, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final entry = _SnackbarOverlayEntry(
      message: message,
      title: title,
      type: type,
      duration: duration,
    );
    overlay.insert(entry.overlayEntry);
  }
}

class _SnackbarOverlayEntry {
  final String message;
  final String? title;
  final SnackbarType type;
  final Duration duration;
  late final OverlayEntry overlayEntry;

  _SnackbarOverlayEntry({
    required this.message,
    required this.title,
    required this.type,
    required this.duration,
  }) {
    overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarWidget(
        message: message,
        title: title,
        type: type,
        duration: duration,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final String? title;
  final SnackbarType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _SnackbarWidget({
    required this.message,
    required this.title,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Drop down from top 
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.type) {
      case SnackbarType.error:   return const Color(0xFFC72C41);
      case SnackbarType.success: return const Color(0xFF2D6A4F);
      case SnackbarType.warning: return const Color(0xFFFCA652);
      case SnackbarType.info:    return const Color(0xFF3282B8);
    }
  }

  Color get _darkColor {
    switch (widget.type) {
      case SnackbarType.error:   return const Color(0xFF801336);
      case SnackbarType.success: return const Color(0xFF1B4332);
      case SnackbarType.warning: return const Color(0xFFCC7A00);
      case SnackbarType.info:    return const Color(0xFF0F4C75);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case SnackbarType.error:   return Icons.error_outline_rounded;
      case SnackbarType.success: return Icons.check_rounded;
      case SnackbarType.warning: return Icons.warning_amber_rounded;
      case SnackbarType.info:    return Icons.question_mark_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;

    return Positioned(
      top: safePadding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: _bgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Background Blob 1
                          Positioned(
                            bottom: -20,
                            left: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _darkColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Background Blob 2
                          Positioned(
                            bottom: 40,
                            left: 20,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _darkColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Background Blob 3
                          Positioned(
                            bottom: 10,
                            left: 70,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _darkColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          
                          // Content
                          Padding(
                            padding: const EdgeInsets.fromLTRB(68, 16, 40, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.title != null) ...[
                                  Text(
                                    widget.title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                ],
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Close Icon
                          Positioned(
                            top: 16,
                            right: 16,
                            child: GestureDetector(
                              onTap: _dismiss,
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white.withOpacity(0.6),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Floating Chat Bubble Icon
                  Positioned(
                    top: 0,
                    left: 20,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Bubble tail (rotated square)
                        Positioned(
                          bottom: -4,
                          left: 10,
                          child: Transform.rotate(
                            angle: 0.785, // roughly 45 degrees
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _darkColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        // Bubble body
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _darkColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _icon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
