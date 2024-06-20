import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final availableHeight = constraints.maxHeight - keyboardHeight;

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: availableHeight * 0.3,
                    child: Center(
                      child: Image.asset('lib/core/assets/images/app_logo.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocListener<LoginBloc, LoginState>(
                    bloc: context.read<LoginBloc>(),
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.of(context)
                            .pushReplacementNamed('/selection');
                      }
                    },
                    child: const LoginForm(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
