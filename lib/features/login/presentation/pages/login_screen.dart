import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';

import '../../../../core/navigation/app_routes.dart';
import '../blocs/bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final availableHeight = screenHeight - keyboardHeight;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    height: availableHeight * 0.3,
                    child: Center(
                      child: Image.asset('lib/core/assets/images/app_logo.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocListener<LoginBloc, LoginState>(
                    bloc: context.read<LoginBloc>(),
                    listenWhen: (prevState, state) => prevState is! LogoutError,
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        loggy.debug(
                            'Navigated successfully out of login screen');
                        context.goNamed(AppRoutes.selection);
                      }
                    },
                    child: const LoginForm(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
