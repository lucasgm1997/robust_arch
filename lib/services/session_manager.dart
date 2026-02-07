import 'dart:async';

import '../domain/entities/session.dart';

/// Singleton that exposes the current user session as a Stream.
/// Supports multi-user session switching.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  final _controller = StreamController<Session?>.broadcast();
  Session? _currentSession;

  Stream<Session?> get sessionStream => _controller.stream;
  Session? get currentSession => _currentSession;

  void setSession(Session session) {
    _currentSession = session;
    _controller.add(session);
  }

  void clearSession() {
    _currentSession = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
