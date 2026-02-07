import '../../core/failure.dart';
import '../../core/result.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/session.dart';
import '../../domain/strategies/auth_strategy.dart';
import '../datasources/auth_remote_datasource.dart';

class EmailAuthStrategy implements AuthStrategy {
  EmailAuthStrategy({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Session>> authenticate(AuthCredentials credentials) async {
    if (credentials is! EmailCredentials) {
      return const Result.error(AuthFailure('Expected EmailCredentials'));
    }
    return _remoteDataSource.login(credentials);
  }
}
