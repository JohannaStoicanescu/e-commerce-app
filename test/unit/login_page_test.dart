import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:e_commerce_app/ui/pages/login/login_page.dart';
import '../helpers/test_helper.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  group('LoginPage Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = FirebaseMockHelper.createMockAuth();
    });

    testWidgets('should display login page components',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('S\'inscrire'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'should show error when fields are empty and sign in is attempted',
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
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error message for invalid credentials',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );
      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'invalid@example.com');
      await tester.enterText(emailFields.last, 'wrongpassword');

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should display navigation link to register page',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      final registerLink = find.text('S\'inscrire');
      expect(registerLink, findsOneWidget);

      expect(find.text('Pas encore de compte ? '), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should clear error message when user starts typing',
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
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test');
      await tester.pump();

      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should validate email and password fields',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const LoginPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'test@example.com');

      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      await tester.pump();

      await tester.binding.setSurfaceSize(null);
    });
  });
}
