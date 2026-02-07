import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/session.dart';
import '../../domain/strategies/auth_strategy.dart';
import '../datasources/auth_remote_datasource.dart';

class AppleAuthStrategy implements AuthStrategy {
  AppleAuthStrategy({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Session>> authenticate(AuthCredentials credentials) async {
    if (credentials is! AppleCredentials) {
      return const Result.error(AuthFailure('Expected AppleCredentials'));
    }
    return _remoteDataSource.login(credentials);
  }
}
