
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuispilgan_pm2/main.dart';
import 'package:kuispilgan_pm2/providers/auth_provider.dart';
import 'package:kuispilgan_pm2/providers/quiz_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('QuizApp dapat ditampilkan', (tester) async {
    final auth = AuthProvider();
    await auth.load();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: auth,
          ),
          ChangeNotifierProvider<QuizProvider>(
            create: (_) => QuizProvider(),
          ),
        ],
        child: const QuizApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
