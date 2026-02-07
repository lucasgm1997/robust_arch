import 'package:flutter/material.dart';

import '../../../domain/entities/auth_credentials.dart';
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
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Switch account',
            onPressed: () => _showAccountSwitcher(context),
          ),
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

  void _showAccountSwitcher(BuildContext context) {
    final sessions = viewModel.allSessions;

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Accounts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final s in sessions)
                ListTile(
                  leading: CircleAvatar(
                    child: Text(s.user.name[0].toUpperCase()),
                  ),
                  title: Text(s.user.name),
                  subtitle: Text(s.user.email),
                  trailing: s.user.id == session.user.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    if (s.user.id != session.user.id) {
                      viewModel.switchAccount(s);
                    }
                  },
                ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.add)),
                title: const Text('Add another account'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddAccountDialog(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Add Google account'),
                onPressed: () {
                  Navigator.pop(context);
                  viewModel.addAccountWithGoogle.execute();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                viewModel.addAccountWithEmail.execute(
                  EmailCredentials(
                    email: emailCtrl.text,
                    password: passCtrl.text,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
