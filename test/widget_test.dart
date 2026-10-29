import 'package:flutter_test/flutter_test.dart';
import 'package:ulvenik/main.dart';
import 'package:ulvenik/screens/splash_screen.dart';

void main() {
  testWidgets('App root smoke test renders MyApp and initial SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
