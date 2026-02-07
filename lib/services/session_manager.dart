import 'dart:async';

import '../domain/entities/session.dart';

/// Singleton that exposes the current user session as a Stream.
/// Tracks multiple logged-in sessions for account switching.
class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  final _controller = StreamController<Session?>.broadcast();
  Session? _currentSession;
  final List<Session> _sessions = [];

  Stream<Session?> get sessionStream => _controller.stream;
  Session? get currentSession => _currentSession;
  List<Session> get sessions => List.unmodifiable(_sessions);

  void setSession(Session session) {
    _currentSession = session;
    // Add to tracked sessions if not already present
    final index = _sessions.indexWhere((s) => s.user.id == session.user.id);
    if (index == -1) {
      _sessions.add(session);
    } else {
      _sessions[index] = session;
    }
    _controller.add(session);
  }

  void switchTo(Session session) {
    _currentSession = session;
    _controller.add(session);
  }

  void removeSession(Session session) {
    _sessions.removeWhere((s) => s.user.id == session.user.id);
    if (_currentSession?.user.id == session.user.id) {
      _currentSession = _sessions.isNotEmpty ? _sessions.first : null;
      _controller.add(_currentSession);
    }
  }

  void clearSession() {
    _currentSession = null;
    _sessions.clear();
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
