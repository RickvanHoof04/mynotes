import 'package:flutter_test/flutter_test.dart';
import 'package:practice_app/services/auth/auth_exceptions.dart';
import 'package:practice_app/services/auth/auth_provider.dart';
import 'package:practice_app/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with', () {
      expect(provider._isInitialized, false);
    });

    test('cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider._user, null);
    });

    test(
      'should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user should delegate to logIn function', () async {
      final badEmail = provider.createUser(
        email: 'rhvanhoof@gmail.com',
        password: 'randomPassword',
      );

      expect(
        badEmail,
        throwsA(const TypeMatcher<InvalidCredentialAuthException>()),
      );

      final badPassword = provider.createUser(
        email: 'rrhvanhoof@gmail.com',
        password: 'randomPasword',
      );
      expect(
        badPassword,
        throwsA(const TypeMatcher<InvalidCredentialAuthException>()),
      );

      final user = await provider.createUser(
        email: 'rrhvanhoof@gmail.com',
        password: 'randomPassword',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test( 'login user should be able to get verified', () {
      provider.sendEmailVerification();

      final user = provider.currentUser;
      expect(user, isNotNull);

      expect(user!.isEmailVerified, true);
    });

    test('should be able to be log out and be logged in again', () async {
      await provider.logOut();
      await provider.logIn(email: ' null', password: 'null');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    await Future.delayed(const Duration(seconds: 1));

    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!_isInitialized) throw NotInitializedException();

    if (email == 'rhvanhoof@gmail.com') throw InvalidCredentialAuthException();
    if (password == 'randomPasword') throw InvalidCredentialAuthException();

    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();

    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();

    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
