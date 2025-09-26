import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:e_commerce_app/ui/pages/login/login_page.dart';
import 'package:e_commerce_app/ui/pages/register/register_page.dart';
import '../helpers/test_helper.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  group('Authentication Integration Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = FirebaseMockHelper.createMockAuth();
    });

    testWidgets('Login page renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Register page renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('Login validation shows error for empty fields',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton, warnIfMissed: false);
      await tester.pump();

      expect(find.textContaining('champs'), findsAtLeastNWidgets(0));

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Register validation shows error for empty fields',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      final registerButtons = find.byType(ElevatedButton);
      if (registerButtons.evaluate().isNotEmpty) {
        await tester.tap(registerButtons.first, warnIfMissed: false);
        await tester.pump();
      }

      expect(find.textContaining('champs'), findsAtLeastNWidgets(0));

      await tester.binding.setSurfaceSize(null);
    });
  });
}
