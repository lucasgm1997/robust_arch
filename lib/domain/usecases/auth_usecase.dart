import '../../core/result.dart';
import '../entities/auth_credentials.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';
import '../../services/session_manager.dart';

class AuthUseCase {
  AuthUseCase({
    required AuthRepository repository,
    required SessionManager sessionManager,
  })  : _repository = repository,
        _sessionManager = sessionManager;

  final AuthRepository _repository;
  final SessionManager _sessionManager;

  Future<Result<Session>> login(AuthCredentials credentials) async {
    final result = await _repository.login(credentials);
    switch (result) {
      case Ok(:final value):
        await _repository.saveSession(value);
        _sessionManager.setSession(value);
        return result;
      case Error():
        return result;
    }
  }

  Future<Result<void>> logout() async {
    final result = await _repository.logout();
    switch (result) {
      case Ok():
        _sessionManager.clearSession();
      case Error():
        break;
    }
    return result;
  }

  Future<Result<Session?>> restoreSession() async {
    // Restore all sessions into the manager
    final allResult = await _repository.restoreAllSessions();
    if (allResult case Ok(:final value)) {
      for (final s in value) {
        if (!s.isExpired) _sessionManager.setSession(s);
      }
    }

    // Set the active one as current
    final result = await _repository.restoreSession();
    switch (result) {
      case Ok(:final value):
        if (value != null && !value.isExpired) {
          _sessionManager.switchTo(value);
        }
      case Error():
        break;
    }
    return result;
  }

  /// Add another account without leaving the current session.
  Future<Result<Session>> addAccount(AuthCredentials credentials) async {
    final result = await _repository.login(credentials);
    switch (result) {
      case Ok(:final value):
        await _repository.saveSession(value);
        _sessionManager.setSession(value);
        return result;
      case Error():
        return result;
    }
  }

  /// Switch to a different stored session (multi-user support).
  void switchSession(Session session) {
    _sessionManager.switchTo(session);
  }

  /// Remove a specific account session.
  Future<Result<void>> removeAccount(Session session) async {
    final result = await _repository.removeSession(session.user.id);
    if (result is Ok) {
      _sessionManager.removeSession(session);
    }
    return result;
  }

  List<Session> get activeSessions => _sessionManager.sessions;
}
