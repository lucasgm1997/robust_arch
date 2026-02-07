import '../../core/result.dart';
import '../entities/auth_credentials.dart';
import '../entities/session.dart';

/// Repository interface — the domain layer only knows this contract.
abstract interface class AuthRepository {
  Future<Result<Session>> login(AuthCredentials credentials);
  Future<Result<void>> logout();
  Future<Result<Session?>> restoreSession();
  Future<Result<List<Session>>> restoreAllSessions();
  Future<Result<void>> saveSession(Session session);
  Future<Result<void>> removeSession(String userId);
}
