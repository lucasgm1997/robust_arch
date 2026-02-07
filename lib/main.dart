import 'package:flutter/material.dart';

import 'config/app_router.dart';
import 'config/service_locator.dart';
import 'services/session_manager.dart';
import 'ui/auth/view_model/auth_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robust Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AppRouter(
        sessionManager: sl<SessionManager>(),
        viewModel: sl<AuthViewModel>(),
      ),
    );
  }
}
