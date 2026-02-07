import 'package:flutter/material.dart';

import '../../../domain/entities/session.dart';
import '../../auth/view_model/auth_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.session,
    required this.viewModel,
  });

  final Session session;
  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          ListenableBuilder(
            listenable: viewModel.logout,
            builder: (context, _) {
              if (viewModel.logout.running) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => viewModel.logout.execute(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${session.user.name}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text('Email: ${session.user.email}'),
            Text('Token: ${session.token.substring(0, 20)}...'),
            Text('Expires: ${session.expiresAt}'),
          ],
        ),
      ),
    );
  }
}
