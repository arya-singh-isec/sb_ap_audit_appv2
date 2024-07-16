import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';

import '../../../../core/widgets/custom_text.dart';
import '../../domain/entities/credentials.dart';
import '../blocs/bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with UiLoggy {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomText.titleLarge('Login'),
        const SizedBox(height: 20),
        TextField(
          controller: _usernameController,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Enter NT Username',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Color.fromRGBO(244, 245, 250, 1),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
        const SizedBox(height: 10),
        TextField(
          textAlignVertical: TextAlignVertical.center,
          obscureText: _isPasswordObscured,
          focusNode: _passwordFocusNode,
          controller: _passwordController,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Enter NT Password',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color.fromRGBO(244, 245, 250, 1),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            suffixIcon: IconButton(
              onPressed: _toggleObscure,
              icon: Icon(
                _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
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
                    loggy.debug('Sign in button pressed');
                    final credentials = Credentials(
                        username: _usernameController.text,
                        password: _passwordController.text);
                    BlocProvider.of<LoginBloc>(context).add(
                      Submitted(credentials: credentials),
                    );
                  },
                  style: Theme.of(context).filledButtonTheme.style!.merge(
                        FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52.0),
                        ),
                      ),
                  child: state is LoginLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : CustomText.labelMedium(
                          'Sign in',
                          textColor: TextColor.white,
                        ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
