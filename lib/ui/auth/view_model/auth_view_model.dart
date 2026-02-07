import 'package:flutter/foundation.dart';

import '../../../core/command.dart';
import '../../../core/result.dart';
import '../../../domain/entities/auth_credentials.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usecases/auth_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthUseCase authUseCase})
      : _authUseCase = authUseCase {
    loginWithEmail = Command1(_loginWithEmail);
    loginWithGoogle = Command0(_loginWithGoogle);
    loginWithApple = Command0(_loginWithApple);
    loginWithPhone = Command1(_loginWithPhone);
    addAccountWithEmail = Command1(_addAccountWithEmail);
    addAccountWithGoogle = Command0(_addAccountWithGoogle);
    logout = Command0(_logout);
    restoreSession = Command0(_restoreSession)..execute();
  }

  final AuthUseCase _authUseCase;

  Session? _session;
  Session? get session => _session;

  List<Session> get allSessions => _authUseCase.activeSessions;

  late final Command1<Session, EmailCredentials> loginWithEmail;
  late final Command0<Session> loginWithGoogle;
  late final Command0<Session> loginWithApple;
  late final Command1<Session, PhoneCredentials> loginWithPhone;
  late final Command1<Session, EmailCredentials> addAccountWithEmail;
  late final Command0<Session> addAccountWithGoogle;
  late final Command0<void> logout;
  late final Command0<Session?> restoreSession;

  Future<Result<Session>> _loginWithEmail(EmailCredentials creds) async {
    final result = await _authUseCase.login(creds);
    _handleLoginResult(result);
    return result;
  }

  Future<Result<Session>> _loginWithGoogle() async {
    // In a real app, this would trigger Google Sign-In SDK first
    const creds = GoogleCredentials(idToken: 'mock_google_token');
    final result = await _authUseCase.login(creds);
    _handleLoginResult(result);
    return result;
  }

  Future<Result<Session>> _loginWithApple() async {
    const creds = AppleCredentials(identityToken: 'mock_apple_token');
    final result = await _authUseCase.login(creds);
    _handleLoginResult(result);
    return result;
  }

  Future<Result<Session>> _loginWithPhone(PhoneCredentials creds) async {
    final result = await _authUseCase.login(creds);
    _handleLoginResult(result);
    return result;
  }

  Future<Result<void>> _logout() async {
    final result = await _authUseCase.logout();
    if (result is Ok) {
      _session = null;
      notifyListeners();
    }
    return result;
  }

  Future<Result<Session?>> _restoreSession() async {
    final result = await _authUseCase.restoreSession();
    if (result case Ok(:final value)) {
      _session = value;
      notifyListeners();
    }
    return result;
  }

  Future<Result<Session>> _addAccountWithEmail(
    EmailCredentials creds,
  ) async {
    final result = await _authUseCase.addAccount(creds);
    _handleLoginResult(result);
    return result;
  }

  Future<Result<Session>> _addAccountWithGoogle() async {
    const creds = GoogleCredentials(idToken: 'mock_google_token');
    final result = await _authUseCase.addAccount(creds);
    _handleLoginResult(result);
    return result;
  }

  void switchAccount(Session session) {
    _authUseCase.switchSession(session);
    _session = session;
    notifyListeners();
  }

  void _handleLoginResult(Result<Session> result) {
    switch (result) {
      case Ok(:final value):
        _session = value;
        notifyListeners();
      case Error():
        break;
    }
  }
}
