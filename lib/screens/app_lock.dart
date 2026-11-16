import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../data/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';

final _auth = LocalAuthentication();

Future<bool> deviceAuthAvailable() async {
  try {
    return await _auth.isDeviceSupported();
  } catch (_) {
    return false;
  }
}

Future<bool> _authenticate(String reason) async {
  try {
    return await _auth.authenticate(localizedReason: reason);
  } catch (_) {
    return false;
  }
}

/// Covers the app with a lock screen on a cold launch and when returning from
/// the background, whenever App Lock is on. Uses the device's own credential
/// prompt; Ulvenik has no PIN of its own.
class AppLockGate extends StatefulWidget {
  final Widget child;
  const AppLockGate({super.key, required this.child});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  bool _locked = AppSettings.instance.appLock;
  bool _prompting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && AppSettings.instance.appLock) {
      setState(() => _locked = true);
    } else if (state == AppLifecycleState.resumed && _locked) {
      _unlock();
    }
  }

  Future<void> _unlock() async {
    if (_prompting || !_locked) return;
    _prompting = true;
    final ok = await _authenticate('Unlock Ulvenik');
    _prompting = false;
    if (!mounted) return;
    if (ok) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      if (_locked && AppSettings.instance.appLock)
        Positioned.fill(
          child: Container(
            color: AppColors.backgroundObsidian,
            alignment: Alignment.center,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.lock_outline, size: 44, color: AppColors.secondarySage),
              const SizedBox(height: 14),
              const Text('Ulvenik is locked',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _unlock,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryForestGreen, foregroundColor: AppColors.primaryTextOffWhite),
                child: const Text('Unlock'),
              ),
            ]),
          ),
        ),
    ]);
  }
}

/// App Lock settings: off until set up, turned on or off only after the device
/// confirms it is you. Unavailable hardware gets a clear explanation.
class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) => HealthScaffold(
        title: 'App Lock',
        body: FutureBuilder<bool>(
          future: deviceAuthAvailable(),
          builder: (context, snap) {
            final available = snap.data ?? false;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppColors.primaryForestGreen,
                  title: const Text('App Lock', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                  subtitle: const Text('Use your device authentication to unlock Ulvenik.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  value: s.appLock,
                  onChanged: (!available && !s.appLock)
                      ? null
                      : (v) async {
                          // Changing the lock needs the device to confirm it is you.
                          final ok = await _authenticate(v ? 'Turn on App Lock' : 'Turn off App Lock');
                          if (!ok) return; // cancelled or failed: nothing changes
                          final saved = await s.setAppLock(v);
                          if (!saved && context.mounted) {
                            AppSnackbar.show(context, message: 'That change couldn’t be saved. Please try again.', type: SnackbarType.error);
                          }
                        },
                ),
                if (snap.connectionState == ConnectionState.done && !available)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'This device has no screen lock or biometrics set up. Set one up in your device settings to use App Lock.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                    ),
                  ),
                const SizedBox(height: 14),
                const Text(
                  'App Lock stays on this device. It doesn’t replace signing in to your account, and it never deletes drafts or records.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
