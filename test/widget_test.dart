import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zindasic/data/songs_data.dart';
import 'package:zindasic/models/app_state.dart';
import 'package:zindasic/main.dart';
import 'package:zindasic/screens/music_player_screen.dart';

void main() {
  Future<void> openWelcomeFlow(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    appState.logout();
    await tester.pumpWidget(const ZindasicApp());
    await tester.pumpAndSettle(); // Settle the 1.5s fade-in animation
    await tester.pump(const Duration(seconds: 1)); // Advance for the 1s hold timer to fire
    await tester.pumpAndSettle(); // Settle the 600ms screen transition
  }

  testWidgets('shows the Zinda-sic welcome flow', (WidgetTester tester) async {
    await openWelcomeFlow(tester);

    expect(find.text('Welcome'), findsOneWidget);
    expect(
      find.text("The songs are ready, now tell us who's listening"),
      findsOneWidget,
    );
    expect(find.text('begin listening'), findsOneWidget);
  });

  testWidgets('enters the main music archive after login', (
    WidgetTester tester,
  ) async {
    await openWelcomeFlow(tester);

    await tester.enterText(find.byType(EditableText), 'Aadit');
    await tester.pump();
    await tester.tap(find.text('begin listening'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('TOP PICKS FOR YOU'), findsOneWidget);
    expect(find.text("Favourites' Favourites"), findsOneWidget);
  });

  testWidgets('opens the player without layout overflow', (
    WidgetTester tester,
  ) async {
    appState.playSong(allSongs[0]);
    await tester.pumpWidget(
      const MaterialApp(home: MusicPlayerScreen()),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('"${allSongs[0].quote}"'), findsOneWidget);
    expect(find.text(allSongs[0].title), findsOneWidget);
  });
}
