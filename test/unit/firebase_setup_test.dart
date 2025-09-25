import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  group('Firebase Setup Tests', () {
    setUpAll(() async {
      // Setup Firebase Mock pour tous les tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should create mock Firebase Auth instance', () {
      // Act
      final mockAuth = FirebaseMockHelper.createMockAuth();

      // Assert
      expect(mockAuth, isNotNull);
      expect(mockAuth, isA<MockFirebaseAuth>());
    });

    test('should create mock user with correct properties', () {
      // Act
      final mockUser = FirebaseMockHelper.createMockUser(
        uid: 'test-uid-123',
        email: 'testuser@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      // Assert
      expect(mockUser.uid, equals('test-uid-123'));
      expect(mockUser.email, equals('testuser@example.com'));
      expect(mockUser.displayName, equals('Test User'));
      expect(mockUser.emailVerified, isTrue);
    });

    test('should create auth exception with correct properties', () {
      // Act
      final exception = FirebaseMockHelper.createAuthException(
        code: 'user-not-found',
        message: 'No user record corresponding to this identifier.',
      );

      // Assert
      expect(exception.code, equals('user-not-found'));
      expect(exception.message,
          equals('No user record corresponding to this identifier.'));
    });

    test('should simulate successful login flow', () async {
      // Arrange
      const testEmail = 'success@example.com';
      final mockUser = FirebaseMockHelper.createMockUser(email: testEmail);
      final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

      // Act
      final result = await FirebaseMockHelper.simulateSuccessfulLogin(
        mockAuth,
        email: testEmail,
        password: 'password123',
      );

      // Assert
      expect(result, isNotNull);
      expect(result.user, isNotNull);
      expect(result.user!.email, equals(testEmail));
    });

    test('should simulate successful registration flow', () async {
      // Arrange
      final mockAuth = FirebaseMockHelper.createMockAuth();

      // Act
      final result = await FirebaseMockHelper.simulateSuccessfulRegister(
        mockAuth,
        email: 'newuser@example.com',
        password: 'newpassword123',
      );

      // Assert
      expect(result, isNotNull);
      expect(result.user, isNotNull);
      expect(result.user!.email, equals('newuser@example.com'));
    });

    test('should create mock auth with signed in user', () {
      // Arrange
      final mockUser = FirebaseMockHelper.createMockUser(
        email: 'signedin@example.com',
      );

      // Act
      final mockAuth = FirebaseMockHelper.createMockAuth(
        signedInUser: mockUser,
        isSignedIn: true,
      );

      // Assert
      expect(mockAuth.currentUser, isNotNull);
      expect(mockAuth.currentUser!.email, equals('signedin@example.com'));
    });

    test('should create mock auth without signed in user', () {
      // Act
      final mockAuth = FirebaseMockHelper.createMockAuth(
        isSignedIn: false,
      );

      // Assert
      expect(mockAuth.currentUser, isNull);
    });

    group('Firebase Auth Exception Tests', () {
      test('should create invalid-email exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );

        // Assert
        expect(exception.code, equals('invalid-email'));
        expect(exception.message, contains('formatted'));
      });

      test('should create user-disabled exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'user-disabled',
          message: 'The user account has been disabled by an administrator.',
        );

        // Assert
        expect(exception.code, equals('user-disabled'));
        expect(exception.message, contains('disabled'));
      });

      test('should create user-not-found exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'user-not-found',
          message: 'There is no user record corresponding to this identifier.',
        );

        // Assert
        expect(exception.code, equals('user-not-found'));
        expect(exception.message, contains('user record'));
      });

      test('should create wrong-password exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'wrong-password',
          message:
              'The password is invalid or the user does not have a password.',
        );

        // Assert
        expect(exception.code, equals('wrong-password'));
        expect(exception.message, contains('password'));
      });

      test('should create email-already-in-use exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'email-already-in-use',
          message: 'The email address is already in use by another account.',
        );

        // Assert
        expect(exception.code, equals('email-already-in-use'));
        expect(exception.message, contains('already in use'));
      });

      test('should create weak-password exception', () {
        // Act
        final exception = FirebaseMockHelper.createAuthException(
          code: 'weak-password',
          message: 'The password provided is too weak.',
        );

        // Assert
        expect(exception.code, equals('weak-password'));
        expect(exception.message, contains('weak'));
      });
    });
  });
}
