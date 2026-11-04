import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulvenik/screens/splash_screen.dart';
import 'package:ulvenik/screens/onboarding_screen.dart';
import 'package:ulvenik/screens/login_screen.dart';

Widget testHarness(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: child,
  );
}

void main() {
  group('BATCH 1 — Auth & Onboarding', () {
    testWidgets('1.1 Splash Screen renders', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('1.2 Onboarding Screen renders', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('1.3 Login Screen renders', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      await tester.pumpWidget(testHarness(const LoginScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
