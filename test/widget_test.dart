import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihan_flutterd7/main.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('App landing screen smoke test', (WidgetTester tester) async {
    // Mock initial values for SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Pump our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the Splash screen title and tagline are displayed.
    expect(find.text('RUAS'), findsOneWidget);
    expect(find.text('Ruang Napas Untuk Semua'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar Akun'), findsOneWidget);
  });
}
