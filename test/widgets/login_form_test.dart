import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_app/ui/pages/login/widgets/login_form.dart';
import '../helpers/test_helper.dart';

void main() {
  group('LoginForm Widget Tests', () {
    late TextEditingController emailController;
    late TextEditingController passwordController;
    bool signInCalled = false;

    setUp(() {
      emailController = TextEditingController();
      passwordController = TextEditingController();
      signInCalled = false;
    });

    tearDown(() {
      emailController.dispose();
      passwordController.dispose();
    });

    testWidgets('should display email and password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      // Vérifier qu'on a 2 TextField (email + password)
      expect(find.byType(TextField), findsNWidgets(2));

      // Vérifier les hints
      expect(find.text('Entrez votre email'), findsOneWidget);
      expect(find.text('Entrez votre mot de passe'), findsOneWidget);
    });

    testWidgets('should allow text input in email field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      // Trouver et taper dans le champ email
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(emailController.text, equals('test@example.com'));
    });

    testWidgets('should allow text input in password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      // Trouver et taper dans le champ password (dernier TextField)
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      expect(passwordController.text, equals('password123'));
    });

    testWidgets('should hide password text by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      // Le champ password devrait être obscurci
      final passwordFields = find.byType(TextField);
      expect(passwordFields, findsNWidgets(2));

      // Vérifier que le password field a obscureText = true
      final passwordField = tester.widget<TextField>(passwordFields.last);
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('should disable fields when loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: true, // Mode loading
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Vérifier que les champs sont désactivés
      final emailField = tester.widget<TextField>(textFields.first);
      final passwordField = tester.widget<TextField>(textFields.last);

      expect(emailField.enabled, isFalse);
      expect(passwordField.enabled, isFalse);
    });

    testWidgets('should call onSignIn when Enter is pressed on password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      // Trouver le champ password et simuler l'appui sur Entrée
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(signInCalled, isTrue);
    });

    testWidgets('should have correct keyboard types',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Vérifier les types de clavier
      final emailField = tester.widget<TextField>(textFields.first);
      final passwordField = tester.widget<TextField>(textFields.last);

      expect(emailField.keyboardType, equals(TextInputType.emailAddress));
      // Le mot de passe utilise le type par défaut (text)
      expect(passwordField.keyboardType, equals(TextInputType.text));
    });

    testWidgets('should display hint texts', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelper.createTestableWidget(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => signInCalled = true,
          ),
        ),
      );

      expect(find.text('Entrez votre email'), findsOneWidget);
      expect(find.text('Entrez votre mot de passe'), findsOneWidget);
    });
  });
}
