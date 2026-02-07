import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../models/session_model.dart';

abstract interface class AuthLocalDataSource {
  Future<Result<void>> saveSession(SessionModel session);
  Future<Result<SessionModel?>> getSession();
  Future<Result<void>> deleteSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _sessionKey = 'auth_session';

  @override
  Future<Result<void>> saveSession(SessionModel session) async {
    try {
      final json = jsonEncode(session.toJson());
      await _storage.write(key: _sessionKey, value: json);
      return const Result.ok(null);
    } on Exception {
      return const Result.error(CacheFailure('Failed to save session'));
    }
  }

  @override
  Future<Result<SessionModel?>> getSession() async {
    try {
      final json = await _storage.read(key: _sessionKey);
      if (json == null) return const Result.ok(null);
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Result.ok(SessionModel.fromJson(map));
    } on Exception {
      return const Result.error(CacheFailure('Failed to read session'));
    }
  }

  @override
  Future<Result<void>> deleteSession() async {
    try {
      await _storage.delete(key: _sessionKey);
      return const Result.ok(null);
    } on Exception {
      return const Result.error(CacheFailure('Failed to delete session'));
    }
  }
}
