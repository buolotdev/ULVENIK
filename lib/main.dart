import 'package:flutter/material.dart';
import 'data/app_settings.dart';
import 'data/goals_store.dart';
import 'data/health_store.dart';
import 'data/item_library.dart';
import 'data/media_store.dart';
import 'data/sc_store.dart';
import 'data/sport_store.dart';
import 'data/timeline_store.dart';
import 'screens/app_lock.dart';
import 'screens/home_widgets.dart';
import 'screens/notifications_inbox_screen.dart';
import 'screens/session_templates_new.dart';
import 'screens/media_links.dart';
import 'data/trainer_store.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  await ItemLibraryStore.instance.load();
  await TrainerStore.instance.load();
  await GoalsStore.instance.load();
  await HealthStore.instance.load();
  await SCStore.instance.load();
  await SportStore.instance.load();
  await TimelineStore.instance.load();
  await HomeWidgetsStore.instance.load();
  await TemplateStore.instance.load();
  await InboxState.instance.load();
  MediaStore.linkResolver = MediaLinks.fromKey;
  await MediaStore.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) => MaterialApp(
        title: 'Ulvenik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          final s = AppSettings.instance;
          // Text size multiplies the device's own accessibility scale.
          return MediaQuery(
            data: mq.copyWith(
              textScaler: TextScaler.linear(mq.textScaler.scale(1) * s.textFactor),
              disableAnimations: mq.disableAnimations || s.reduceAnimations,
            ),
            child: AppLockGate(child: child!),
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
