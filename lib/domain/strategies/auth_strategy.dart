import '../../core/result.dart';
import '../entities/auth_credentials.dart';
import '../entities/session.dart';

/// Strategy pattern interface for authentication methods.
/// Each login method (email, google, apple, phone) implements this.
abstract interface class AuthStrategy {
  Future<Result<Session>> authenticate(AuthCredentials credentials);
}
