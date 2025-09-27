import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '../mocks/firebase_mocks.dart';

class TestKeys {
  static const Key emailField = Key('email_field');
  static const Key passwordField = Key('password_field');
  static const Key confirmPasswordField = Key('confirm_password_field');
  static const Key loginButton = Key('login_button');
  static const Key registerButton = Key('register_button');
  static const Key errorMessage = Key('error_message');
  static const Key loadingIndicator = Key('loading_indicator');
}

class TestHelper {
  static Widget createTestableWidget({
    required Widget child,
    MockFirebaseAuth? mockAuth,
    MockFirebaseAuth? firebaseAuth,
    bool includeProviders = true,
  }) {
    final auth =
        firebaseAuth ?? mockAuth ?? FirebaseMockHelper.createMockAuth();

    if (!includeProviders) {
      return MaterialApp(
        home: Material(
          child: child,
        ),
      );
    }

    return MaterialApp(
      home: Material(
        child: MultiProvider(
          providers: [
            Provider<FirebaseAuth>.value(
              value: auth,
            ),
          ],
          child: child,
        ),
      ),
    );
  }

  static Future<void> enterText(
    WidgetTester tester,
    String text,
    Key key,
  ) async {
    await tester.enterText(find.byKey(key), text);
    await tester.pump();
  }

  static Future<void> tapButton(
    WidgetTester tester,
    Key key,
  ) async {
    await tester.tap(find.byKey(key));
    await tester.pump();
  }

  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  static void expectErrorMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  static void expectNoErrorMessage() {
    expect(find.byType(Container), findsWidgets);
  }
}
