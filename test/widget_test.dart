import 'package:flug_tag/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    var _artist = 'antimatter15';
    var _title = 'Uh, something';
    var _comment = 'this is the most awesomeest thing EVAH';

    expect(find.text('Artist: $_artist\nTitle: $_title\nComment: $_comment\n'), findsNothing);

    // Tap on the Fab
    await tester.tap(find.byIcon(Icons.cached));
    await tester.pump();

    expect(find.text('Artist: $_artist\nTitle: $_title\nComment: $_comment\n'), findsOneWidget);
  });
}
