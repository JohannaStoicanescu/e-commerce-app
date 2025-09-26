import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:e_commerce_app/ui/pages/register/register_page.dart';
import '../helpers/test_helper.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  group('RegisterPage Tests', () {
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = FirebaseMockHelper.createMockAuth();
    });

    testWidgets('should display register page components',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

  expect(find.byType(AppBar), findsOneWidget);
  expect(find.byType(TextField), findsNWidgets(3));
  expect(find.text('Déjà un compte ?'), findsOneWidget);
  expect(find.text('Se connecter'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when fields are empty',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 1000));

      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      final registerButton = find.byType(InkWell).first;
      await tester.tap(registerButton);
      await tester.pump();

      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
