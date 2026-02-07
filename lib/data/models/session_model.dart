import '../../domain/entities/session.dart';
import 'user_model.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.user,
    required super.token,
    required super.expiresAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final userModel = user is UserModel
        ? (user as UserModel)
        : UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
          );
    return {
      'user': userModel.toJson(),
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
