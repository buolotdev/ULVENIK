import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulvenik/widgets/ulvenik_icon.dart';

void main() {
  testWidgets('UlvenikIcon renders all 27 official icons and fromMaterial mapper', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Wrap(
              children: [
                ...UlvenikIcons.allIcons.map((name) {
                  return UlvenikIcon(
                    name,
                    size: 24,
                    color: Colors.green,
                  );
                }),
                UlvenikIcon.fromMaterial(Icons.home, size: 24, color: Colors.blue),
                UlvenikIcon.fromMaterial(Icons.pets, size: 24, color: Colors.blue),
                UlvenikIcon.fromMaterial(Icons.fitness_center, size: 24, color: Colors.blue),
                UlvenikIcon.fromMaterial(Icons.timeline, size: 24, color: Colors.blue),
                UlvenikIcon.fromMaterial(Icons.more_horiz, size: 24, color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(UlvenikIcon), findsNWidgets(27 + 5));
  });
}
