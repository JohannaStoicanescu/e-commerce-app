import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get currentUser => _user;
  bool get isLoggedIn => _user != null;
  String? get userEmail => _user?.email;

  AuthService() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
    
    // Initialize current user
    _user = _auth.currentUser;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  String? getAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Aucun utilisateur trouvé avec cet email.';
        case 'wrong-password':
          return 'Mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Un compte existe déjà avec cet email.';
        case 'weak-password':
          return 'Le mot de passe est trop faible.';
        case 'invalid-email':
          return 'Format d\'email invalide.';
        default:
          return 'Erreur d\'authentification: ${error.message}';
      }
    }
    return 'Une erreur s\'est produite.';
  }
}
