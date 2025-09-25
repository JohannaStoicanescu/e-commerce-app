import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_app/ui/pages/login/widgets/login_error_message.dart';
import '../helpers/test_helper.dart';

void main() {
  group('ErrorMessage Widget Tests', () {
    testWidgets('should display error message when message is provided',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Ceci est un message d\'erreur de test';

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const ErrorMessage(message: errorMessage),
          includeProviders: false,
        ),
      );

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('should not display anything when message is empty',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = '';

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const ErrorMessage(message: errorMessage),
          includeProviders: false,
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text(errorMessage), findsNothing);
      expect(find.byIcon(Icons.error_outline_rounded), findsNothing);
    });

    testWidgets('should have correct styling for error message',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Message d\'erreur avec style';

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const ErrorMessage(message: errorMessage),
          includeProviders: false,
        ),
      );

      // Assert
      final containerFinder = find.byType(Container).first;
      expect(containerFinder, findsOneWidget);

      final textFinder = find.text(errorMessage);
      expect(textFinder, findsOneWidget);

      // Vérifier que l'icône d'erreur est présente
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('should handle long error messages',
        (WidgetTester tester) async {
      // Arrange
      const longErrorMessage =
          'Ceci est un très long message d\'erreur qui devrait être affiché correctement même s\'il dépasse la largeur normale de l\'écran. Le widget devrait gérer cela élégamment.';

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const ErrorMessage(message: longErrorMessage),
          includeProviders: false,
        ),
      );

      // Assert
      expect(find.text(longErrorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);

      // Vérifier qu'il n'y a pas d'overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display multiple error messages correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage1 = 'Premier message d\'erreur';
      const errorMessage2 = 'Deuxième message d\'erreur';

      // Act
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: const Column(
            children: [
              ErrorMessage(message: errorMessage1),
              SizedBox(height: 10),
              ErrorMessage(message: errorMessage2),
            ],
          ),
          includeProviders: false,
        ),
      );

      // Assert
      expect(find.text(errorMessage1), findsOneWidget);
      expect(find.text(errorMessage2), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsNWidgets(2));
    });
  });
}
