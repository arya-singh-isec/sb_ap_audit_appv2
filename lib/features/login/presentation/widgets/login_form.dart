import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/credentials.dart';
import '../blocs/bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Login',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Enter NT Username',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(
              maxHeight: 50,
            ),
          ),
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
        const SizedBox(height: 10),
        TextField(
          focusNode: _passwordFocusNode,
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Enter NT Password',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(
              maxHeight: 50,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) => ElevatedButton(
                  onPressed: () {
                    final credentials = Credentials(
                        username: _usernameController.text,
                        password: _passwordController.text);
                    BlocProvider.of<LoginBloc>(context).add(
                      Submitted(credentials: credentials),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: state is LoginLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign in'),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
