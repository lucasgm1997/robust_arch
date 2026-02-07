import 'package:flutter_test/flutter_test.dart';
import 'package:robust_arch/core/failure.dart';
import 'package:robust_arch/core/result.dart';
import 'package:robust_arch/domain/entities/auth_credentials.dart';
import 'package:robust_arch/domain/entities/session.dart';
import 'package:robust_arch/domain/entities/user_entity.dart';
import 'package:robust_arch/domain/repositories/auth_repository.dart';
import 'package:robust_arch/domain/usecases/auth_usecase.dart';
import 'package:robust_arch/services/session_manager.dart';

// Simple fake repository for testing
class FakeAuthRepository implements AuthRepository {
  Result<Session>? loginResult;
  Result<void> logoutResult = const Result.ok(null);
  Result<Session?> restoreResult = const Result.ok(null);
  Result<List<Session>> restoreAllResult = const Result.ok([]);
  Result<void> saveResult = const Result.ok(null);
  Result<void> removeResult = const Result.ok(null);

  @override
  Future<Result<Session>> login(AuthCredentials credentials) async {
    return loginResult!;
  }

  @override
  Future<Result<void>> logout() async => logoutResult;

  @override
  Future<Result<Session?>> restoreSession() async => restoreResult;

  @override
  Future<Result<List<Session>>> restoreAllSessions() async => restoreAllResult;

  @override
  Future<Result<void>> saveSession(Session session) async => saveResult;

  @override
  Future<Result<void>> removeSession(String userId) async => removeResult;
}

void main() {
  late FakeAuthRepository fakeRepo;
  late SessionManager sessionManager;
  late AuthUseCase authUseCase;

  setUp(() {
    fakeRepo = FakeAuthRepository();
    sessionManager = SessionManager.instance;
    authUseCase = AuthUseCase(
      repository: fakeRepo,
      sessionManager: sessionManager,
    );
  });

  tearDown(() {
    sessionManager.clearSession();
  });

  final testSession = Session(
    user: const UserEntity(id: '1', name: 'Test', email: 'test@test.com'),
    token: 'token_123',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  group('AuthUseCase', () {
    test('login sets session on success', () async {
      fakeRepo.loginResult = Result.ok(testSession);

      final result = await authUseCase.login(
        const EmailCredentials(email: 'test@test.com', password: 'pass'),
      );

      expect(result, isA<Ok<Session>>());
      expect(sessionManager.currentSession, isNotNull);
      expect(sessionManager.currentSession!.user.email, 'test@test.com');
    });

    test('login does not set session on failure', () async {
      fakeRepo.loginResult = const Result.error(InvalidCredentialsFailure());

      final result = await authUseCase.login(
        const EmailCredentials(email: 'test@test.com', password: 'wrong'),
      );

      expect(result, isA<Error<Session>>());
      expect(sessionManager.currentSession, isNull);
    });

    test('logout clears session', () async {
      // First set a session
      sessionManager.setSession(testSession);
      expect(sessionManager.currentSession, isNotNull);

      await authUseCase.logout();

      expect(sessionManager.currentSession, isNull);
    });

    test('addAccount tracks multiple sessions', () async {
      fakeRepo.loginResult = Result.ok(testSession);
      await authUseCase.login(
        const EmailCredentials(email: 'test@test.com', password: 'pass'),
      );

      final secondSession = Session(
        user: const UserEntity(id: '2', name: 'Other', email: 'other@test.com'),
        token: 'token_456',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      fakeRepo.loginResult = Result.ok(secondSession);
      await authUseCase.addAccount(
        const EmailCredentials(email: 'other@test.com', password: 'pass'),
      );

      expect(authUseCase.activeSessions.length, 2);
      expect(sessionManager.currentSession!.user.id, '2');

      // Switch back to first
      authUseCase.switchSession(testSession);
      expect(sessionManager.currentSession!.user.id, '1');
    });
  });

  group('Result pattern', () {
    test('Ok holds value', () {
      const result = Result.ok(42);
      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).value, 42);
    });

    test('Error holds exception', () {
      const result = Result<int>.error(AuthFailure('nope'));
      expect(result, isA<Error<int>>());
      expect((result as Error<int>).error, isA<AuthFailure>());
    });

    test('switch exhaustiveness', () {
      const Result<int> result = Result.ok(10);
      final value = switch (result) {
        Ok(:final value) => value,
        Error(:final error) => throw error,
      };
      expect(value, 10);
    });
  });
}
