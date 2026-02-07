import 'user_entity.dart';

class Session {
  const Session({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  final UserEntity user;
  final String token;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  String toString() => 'Session(user: ${user.name}, expired: $isExpired)';
}
