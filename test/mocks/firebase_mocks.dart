import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

class FirebaseMockHelper {
  static MockFirebaseAuth createMockAuth({
    MockUser? signedInUser,
    bool isSignedIn = false,
  }) {
    return MockFirebaseAuth(
      signedIn: isSignedIn,
      mockUser: signedInUser,
    );
  }

  static MockUser createMockUser({
    String uid = 'test-uid',
    String email = 'test@example.com',
    String displayName = 'Test User',
    bool isEmailVerified = false,
  }) {
    return MockUser(
      uid: uid,
      email: email,
      displayName: displayName,
      isEmailVerified: isEmailVerified,
    );
  }

  static Future<UserCredential> simulateSuccessfulLogin(
    MockFirebaseAuth mockAuth, {
    String email = 'test@example.com',
    String password = 'password123',
  }) async {
    final result = await mockAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result;
  }

  static Future<UserCredential> simulateSuccessfulRegister(
    MockFirebaseAuth mockAuth, {
    String email = 'newuser@example.com',
    String password = 'password123',
  }) async {
    final result = await mockAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result;
  }

  static FirebaseAuthException createAuthException({
    String code = 'invalid-email',
    String message = 'The email address is badly formatted.',
  }) {
    return FirebaseAuthException(
      code: code,
      message: message,
    );
  }
}
