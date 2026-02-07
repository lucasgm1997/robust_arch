import 'package:flutter/material.dart';

import '../../../domain/entities/auth_credentials.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: widget.viewModel.loginWithEmail,
              builder: (context, _) {
                final cmd = widget.viewModel.loginWithEmail;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (cmd.error)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${cmd.result}',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    FilledButton(
                      onPressed: cmd.running ? null : _onEmailLogin,
                      child: cmd.running
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign in with Email'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            _SocialButton(
              command: widget.viewModel.loginWithGoogle,
              label: 'Sign in with Google',
              icon: Icons.g_mobiledata,
              onPressed: () => widget.viewModel.loginWithGoogle.execute(),
            ),
            const SizedBox(height: 12),
            _SocialButton(
              command: widget.viewModel.loginWithApple,
              label: 'Sign in with Apple',
              icon: Icons.apple,
              onPressed: () => widget.viewModel.loginWithApple.execute(),
            ),
          ],
        ),
      ),
    );
  }

  void _onEmailLogin() {
    final creds = EmailCredentials(
      email: _emailController.text,
      password: _passwordController.text,
    );
    widget.viewModel.loginWithEmail.execute(creds);
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.command,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Listenable command;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: command,
      builder: (context, _) {
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        );
      },
    );
  }
}
