import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/entities/auth_credentials.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<SessionModel>> login(AuthCredentials credentials);
  Future<Result<void>> logout(String token);
}

/// Mocked implementation — simulates API calls with delays.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Result<SessionModel>> login(AuthCredentials credentials) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    try {
      final (name, email) = switch (credentials) {
        EmailCredentials(:final email) => ('Email User', email),
        GoogleCredentials() => ('Google User', 'google@example.com'),
        AppleCredentials() => ('Apple User', 'apple@example.com'),
        PhoneCredentials(:final phoneNumber) => ('Phone User', phoneNumber),
      };

      // Simulate a failed login for a specific email
      if (credentials is EmailCredentials &&
          credentials.password == 'wrong') {
        return const Result.error(InvalidCredentialsFailure());
      }

      final session = SessionModel(
        user: UserModel(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
        ),
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      return Result.ok(session);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> logout(String token) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const Result.ok(null);
  }
}
