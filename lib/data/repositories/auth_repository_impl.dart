import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/strategies/auth_strategy.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required Map<Type, AuthStrategy> strategies,
  })  : _localDataSource = localDataSource,
        _strategies = strategies;

  final AuthLocalDataSource _localDataSource;
  final Map<Type, AuthStrategy> _strategies;

  @override
  Future<Result<Session>> login(AuthCredentials credentials) async {
    final strategy = _strategies[credentials.runtimeType];
    if (strategy == null) {
      return Result.error(
        AuthFailure('No strategy for ${credentials.runtimeType}'),
      );
    }
    return strategy.authenticate(credentials);
  }

  @override
  Future<Result<void>> logout() async {
    return _localDataSource.deleteSession();
  }

  @override
  Future<Result<Session?>> restoreSession() async {
    return _localDataSource.getSession();
  }

  @override
  Future<Result<void>> saveSession(Session session) async {
    final model = SessionModel(
      user: session.user,
      token: session.token,
      expiresAt: session.expiresAt,
    );
    return _localDataSource.saveSession(model);
  }
}
