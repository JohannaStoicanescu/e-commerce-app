# 🧪 Suite de Tests - E-Commerce Flutter App

## 📁 Structure des Tests

```
test/
├── widget_test.dart              # Point d'entrée principal
├── test_runner.dart             # Organisateur de tous les tests
├── helpers/
│   └── test_helper.dart         # Utilitaires pour les tests
├── mocks/
│   └── firebase_mocks.dart      # Mocks Firebase pour les tests
├── unit/                        # Tests unitaires des pages
│   ├── firebase_setup_test.dart
│   ├── login_page_test.dart
│   ├── register_page_test.dart
│   └── authentication_integration_test.dart
└── widgets/                     # Tests des composants
    ├── error_message_test.dart
    └── login_form_test.dart
```

## 🎯 Types de Tests Inclus

### 🔧 Tests de Configuration

- **Firebase Setup Tests** : Validation des mocks Firebase
- **Helper Functions Tests** : Tests des utilitaires de test

### 🎨 Tests des Widgets

- **ErrorMessage Widget** :

  - Affichage des messages d'erreur
  - Gestion des messages vides
  - Styling et icônes
  - Messages longs
  - Messages multiples

- **LoginForm Widget** :
  - Affichage des champs email/password
  - Validation des entrées
  - États de chargement
  - Interactions clavier
  - Types de clavier appropriés

### 📱 Tests des Pages

#### 🔐 Page de Connexion (LoginPage)

- Affichage des composants
- Validation des champs vides
- Gestion des erreurs d'authentification
- Navigation vers la page d'inscription
- États de chargement
- Persistance des données lors d'erreurs

#### 📝 Page d'Inscription (RegisterPage)

- Affichage des composants (3 champs)
- Validation des champs vides
- Validation de correspondance des mots de passe
- Validation de longueur minimale du mot de passe
- Processus d'inscription réussi
- Indicateurs de chargement
- Navigation vers la page de connexion

### 🔄 Tests d'Intégration

- **Flux complet de connexion** avec toutes les validations
- **Flux complet d'inscription** avec toutes les validations
- **Affichage correct des messages d'erreur** dans les deux pages
- **Maintien de l'état des formulaires** pendant les erreurs
- **Protection contre les soumissions multiples** en état de chargement
- **Navigation entre les pages** login/register

## 🚀 Exécution des Tests

### Exécuter tous les tests :

```bash
flutter test
```

### Exécuter un groupe spécifique de tests :

```bash
# Tests des widgets seulement
flutter test test/widgets/

# Tests unitaires seulement
flutter test test/unit/

# Un fichier spécifique
flutter test test/widgets/error_message_test.dart
```

### Exécuter avec couverture :

```bash
flutter test --coverage
```

## 🛠️ Outils et Dépendances

### Dépendances de Test Ajoutées

```yaml
dev_dependencies:
  mockito: ^5.4.4
  build_runner: ^2.4.9
  firebase_auth_mocks: ^0.13.0
```

### Mocks Utilisés

- **firebase_auth_mocks** : Mock de Firebase Authentication
- **MockFirebaseAuth** : Simulation des opérations d'authentification
- **MockUser** : Simulation des utilisateurs Firebase

## 📊 Couverture des Tests

### Fonctionnalités Testées

- ✅ Validation des formulaires (champs vides, format email, longueur mot de passe)
- ✅ Gestion des erreurs (affichage, effacement, persistance)
- ✅ États de l'interface (chargement, désactivation des champs)
- ✅ Navigation entre les pages
- ✅ Interactions utilisateur (saisie, soumission, navigation)
- ✅ Composants réutilisables (ErrorMessage, LoginForm)

### Scénarios d'Erreur Testés

- Champs obligatoires vides
- Mots de passe non correspondants
- Mot de passe trop court
- Erreurs Firebase (credentials invalides, email déjà utilisé, etc.)
- Erreurs réseau simulées

## 🎨 Helpers et Utilitaires

### TestHelper

Fournit des méthodes pour :

- Créer des widgets testables avec providers
- Saisir du texte dans les champs
- Taper sur les boutons
- Attendre les animations
- Vérifier les messages d'erreur

### FirebaseMockHelper

Fournit des méthodes pour :

- Créer des instances mock de Firebase Auth
- Simuler des utilisateurs connectés
- Simuler des connexions/inscriptions réussies
- Créer des exceptions Firebase personnalisées

### TestKeys

Clés réutilisables pour identifier les widgets dans les tests

## 📈 Prochaines Étapes

Pour étendre les tests, vous pouvez ajouter :

- Tests des autres pages (ProductsPage, CartPage, etc.)
- Tests des ViewModels (ProductsViewModel, CartViewModel)
- Tests des services (AuthService avec Firebase intégré)
- Tests d'intégration bout-en-bout
- Tests de performance
- Tests d'accessibilité

## 🐛 Debugging des Tests

### Problèmes Courants

1. **Firebase non initialisé** : Utiliser les mocks fournis
2. **Widgets non trouvés** : Vérifier les clés et sélecteurs
3. **Timeouts** : Utiliser `pumpAndSettle()` pour attendre les animations
4. **État persistant** : Utiliser `setUp()` et `tearDown()` appropriés

### Logs de Debug

```dart
debugDumpApp();

print(tester.allWidgets);

expect(tester.takeException(), isNull);
```

---

✨ **Cette suite de tests offre une couverture complète des fonctionnalités d'authentification de votre application e-commerce Flutter !**
