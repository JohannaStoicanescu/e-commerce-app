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
      // Arrange - Augmenter la taille pour éviter les débordements
      await tester.binding.setSurfaceSize(const Size(1400, 1000));

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField),
          findsNWidgets(3)); // Email, mot de passe, confirmation
      expect(find.text('Déjà un compte ? Se connecter'), findsOneWidget);

      // Réinitialiser la taille de l'écran
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when fields are empty',
        (WidgetTester tester) async {
      // Arrange - Augmenter la taille pour éviter les débordements
      await tester.binding.setSurfaceSize(const Size(1400, 1000));

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const RegisterPage(),
          firebaseAuth: mockFirebaseAuth,
          includeProviders: false,
        ),
      );

      // Trouver et appuyer sur le bouton d'inscription
      final registerButton = find.byType(InkWell).first;
      await tester.tap(registerButton);
      await tester.pump();

      // Assert
      expect(find.text('Veuillez remplir tous les champs'), findsOneWidget);

      // Réinitialiser la taille de l'écran
      await tester.binding.setSurfaceSize(null);
    });
  });
}
