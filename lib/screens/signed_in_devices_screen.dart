import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';

String _deviceLabel() {
  if (Platform.isAndroid) return 'Android device';
  if (Platform.isIOS) return 'iPhone or iPad';
  if (Platform.isMacOS) return 'Mac';
  if (Platform.isWindows) return 'Windows PC';
  if (Platform.isLinux) return 'Linux device';
  return 'This device';
}

/// Signed-in Devices: there is no account backend yet, so there is only one
/// real session to show — this device, right now. No other devices are
/// listed or faked.
class SignedInDevicesScreen extends StatelessWidget {
  const SignedInDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: 'Signed-in Devices',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Ulvenik doesn\'t have accounts with a server yet, so there\'s no way to see or sign out of other devices. This is the only session that exists.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 18),
          HealthCard(
            child: Row(
              children: [
                Icon(Icons.smartphone_outlined, color: AppColors.primaryForestGreen, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_deviceLabel(),
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('This device · Active now',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Current',
                      style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
