import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '../mocks/firebase_mocks.dart';

void main() {
  group('Firebase Initialization Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('FirebaseMockHelper should create MockFirebaseAuth correctly', () {
      // Act
      final mockAuth = FirebaseMockHelper.createMockAuth();

      // Assert
      expect(mockAuth, isA<MockFirebaseAuth>());
      expect(mockAuth.currentUser, isNull);
    });

    test('FirebaseMockHelper should create MockUser with correct properties',
        () {
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

    test('FirebaseMockHelper should create MockUser with default properties',
        () {
      // Act
      final mockUser = FirebaseMockHelper.createMockUser();

      // Assert
      expect(mockUser.uid, equals('test-uid'));
      expect(mockUser.email, equals('test@example.com'));
      expect(mockUser.displayName, equals('Test User'));
      expect(mockUser.emailVerified, isFalse);
    });

    test(
        'FirebaseMockHelper should create MockFirebaseAuth with signed in user',
        () {
      // Arrange
      final mockUser = FirebaseMockHelper.createMockUser();

      // Act
      final mockAuth = FirebaseMockHelper.createMockAuth(
        signedInUser: mockUser,
        isSignedIn: true,
      );

      // Assert
      expect(mockAuth.currentUser, isNotNull);
      expect(mockAuth.currentUser?.email, equals('test@example.com'));
    });

    test('FirebaseMockHelper should simulate successful login', () async {
      // Arrange
      final mockUser =
          FirebaseMockHelper.createMockUser(email: 'login@example.com');
      final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

      // Act
      final result = await FirebaseMockHelper.simulateSuccessfulLogin(
        mockAuth,
        email: 'login@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isNotNull);
      expect(result.user, isNotNull);
      expect(result.user?.email, equals('login@example.com'));
    });

    test('FirebaseMockHelper should simulate successful registration',
        () async {
      // Arrange
      final mockAuth = FirebaseMockHelper.createMockAuth();

      // Act
      final result = await FirebaseMockHelper.simulateSuccessfulRegister(
        mockAuth,
        email: 'newuser@example.com',
        password: 'securepassword123',
      );

      // Assert
      expect(result, isNotNull);
      expect(result.user, isNotNull);
      expect(result.user?.email, equals('newuser@example.com'));
    });

    test(
        'FirebaseMockHelper should create FirebaseAuthException with correct properties',
        () {
      // Act
      final exception = FirebaseMockHelper.createAuthException(
        code: 'user-not-found',
        message: 'There is no user record corresponding to this identifier.',
      );

      // Assert
      expect(exception.code, equals('user-not-found'));
      expect(exception.message,
          equals('There is no user record corresponding to this identifier.'));
    });

    test('FirebaseMockHelper should create default FirebaseAuthException', () {
      // Act
      final exception = FirebaseMockHelper.createAuthException();

      // Assert
      expect(exception.code, equals('invalid-email'));
      expect(
          exception.message, equals('The email address is badly formatted.'));
    });

    test('MockFirebaseAuth should handle multiple operations', () async {
      // Arrange
      final mockAuth = FirebaseMockHelper.createMockAuth();

      // Act & Assert - First registration
      final registerResult = await mockAuth.createUserWithEmailAndPassword(
        email: 'user1@example.com',
        password: 'password123',
      );
      expect(registerResult.user?.email, equals('user1@example.com'));

      // Act & Assert - Sign out
      await mockAuth.signOut();
      expect(mockAuth.currentUser, isNull);

      // Act & Assert - Sign in
      final signInResult = await mockAuth.signInWithEmailAndPassword(
        email: 'user1@example.com',
        password: 'password123',
      );
      expect(signInResult.user?.email, equals('user1@example.com'));
    });

    test('MockFirebaseAuth should maintain user state correctly', () async {
      // Arrange
      final mockUser =
          FirebaseMockHelper.createMockUser(email: 'persistent@example.com');
      final mockAuth = FirebaseMockHelper.createMockAuth(
        signedInUser: mockUser,
        isSignedIn: true,
      );

      // Assert - Initial state
      expect(mockAuth.currentUser, isNotNull);
      expect(mockAuth.currentUser?.email, equals('persistent@example.com'));

      // Act - Sign out
      await mockAuth.signOut();

      // Assert - After sign out
      expect(mockAuth.currentUser, isNull);
    });
  });
}
