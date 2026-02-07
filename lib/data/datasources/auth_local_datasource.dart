import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/failure.dart';
import '../../core/result.dart';
import '../models/session_model.dart';

abstract interface class AuthLocalDataSource {
  Future<Result<void>> saveSession(SessionModel session);
  Future<Result<SessionModel?>> getSession();
  Future<Result<void>> deleteSession();
  Future<Result<List<SessionModel>>> getAllSessions();
  Future<Result<void>> deleteSessionById(String userId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _sessionsKey = 'auth_sessions';
  static const _activeKey = 'auth_active_user';

  Future<Map<String, dynamic>> _readAll() async {
    final raw = await _storage.read(key: _sessionsKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _writeAll(Map<String, dynamic> sessions) async {
    await _storage.write(key: _sessionsKey, value: jsonEncode(sessions));
  }

  @override
  Future<Result<void>> saveSession(SessionModel session) async {
    try {
      final all = await _readAll();
      all[session.user.id] = session.toJson();
      await _writeAll(all);
      await _storage.write(key: _activeKey, value: session.user.id);
      return const Result.ok(null);
    } on Exception {
      return const Result.error(CacheFailure('Failed to save session'));
    }
  }

  @override
  Future<Result<SessionModel?>> getSession() async {
    try {
      final activeId = await _storage.read(key: _activeKey);
      if (activeId == null) return const Result.ok(null);
      final all = await _readAll();
      final data = all[activeId];
      if (data == null) return const Result.ok(null);
      return Result.ok(
        SessionModel.fromJson(data as Map<String, dynamic>),
      );
    } on Exception {
      return const Result.error(CacheFailure('Failed to read session'));
    }
  }

  @override
  Future<Result<List<SessionModel>>> getAllSessions() async {
    try {
      final all = await _readAll();
      final sessions = all.values
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.ok(sessions);
    } on Exception {
      return const Result.error(CacheFailure('Failed to read sessions'));
    }
  }

  @override
  Future<Result<void>> deleteSession() async {
    try {
      await _storage.delete(key: _sessionsKey);
      await _storage.delete(key: _activeKey);
      return const Result.ok(null);
    } on Exception {
      return const Result.error(CacheFailure('Failed to delete sessions'));
    }
  }

  @override
  Future<Result<void>> deleteSessionById(String userId) async {
    try {
      final all = await _readAll();
      all.remove(userId);
      await _writeAll(all);
      final activeId = await _storage.read(key: _activeKey);
      if (activeId == userId) {
        final newActive = all.keys.firstOrNull;
        if (newActive != null) {
          await _storage.write(key: _activeKey, value: newActive);
        } else {
          await _storage.delete(key: _activeKey);
        }
      }
      return const Result.ok(null);
    } on Exception {
      return const Result.error(CacheFailure('Failed to delete session'));
    }
  }
}
