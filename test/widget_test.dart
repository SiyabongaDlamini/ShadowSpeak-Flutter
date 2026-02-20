import 'package:flutter_test/flutter_test.dart';
import 'package:shadowspeak/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShadowSpeakApp());

    // Verify that the app title is displayed
    expect(find.text('ShadowSpeak'), findsOneWidget);
  });
}
