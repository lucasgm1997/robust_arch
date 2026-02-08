import 'package:flutter/material.dart';

import '../services/session_manager.dart';
import '../ui/auth/view_model/auth_view_model.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/home/widgets/home_screen.dart';

/// Simple Navigator 2.0 router driven by the SessionManager stream.
class AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  AppRouterDelegate({required this.sessionManager, required this.viewModel}) {
    sessionManager.sessionStream.listen((_) => notifyListeners());
  }

  final SessionManager sessionManager;
  final AuthViewModel viewModel;

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final session = sessionManager.currentSession;
    return Navigator(
      key: navigatorKey,
      pages: [
        if (session == null)
          MaterialPage(child: LoginScreen(viewModel: viewModel))
        else
          MaterialPage(
            child: HomeScreen(session: session, viewModel: viewModel),
          ),
      ],
      onDidRemovePage: (_) {},
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

class AppRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return Object();
  }
}

/// Convenience widget that sets up Navigator 2.0.
class AppRouter extends StatelessWidget {
  const AppRouter({
    super.key,
    required this.sessionManager,
    required this.viewModel,
  });

  final SessionManager sessionManager;
  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: AppRouterDelegate(
        sessionManager: sessionManager,
        viewModel: viewModel,
      ),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}
