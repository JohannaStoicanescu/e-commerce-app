import 'package:flutter_test/flutter_test.dart';

import 'unit/firebase_setup_test.dart' as firebase_setup_tests;
import 'unit/login_page_test.dart' as login_page_tests;
import 'unit/auth_integration_test.dart' as auth_integration_tests;
import 'widgets/error_message_test.dart' as error_message_tests;
import 'widgets/login_form_test.dart' as login_form_tests;

void main() {
  group('🧪 E-Commerce Flutter App - Suite de Tests Complète', () {
    group('🔧 Tests de Configuration Firebase', () {
      firebase_setup_tests.main();
    });

    group('🎨 Tests des Widgets', () {
      group('📝 Composant ErrorMessage', () {
        error_message_tests.main();
      });

      group('📋 Formulaire de Login', () {
        login_form_tests.main();
      });
    });

    group('📱 Tests des Pages', () {
      group('🔐 Page de Connexion', () {
        login_page_tests.main();
      });
    });

    group('🔄 Tests d\'Intégration', () {
      group('🔐 Flux d\'Authentification Complet', () {
        auth_integration_tests.main();
      });
    });
  });
}
