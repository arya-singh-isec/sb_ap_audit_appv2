import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/presentation/blocs/bloc.dart';
import '../config/constants.dart';
import '../utils/common_utils.dart';
import 'app_bar.dart';
import 'app_drawer.dart';

class BaseScreen extends StatelessWidget {
  final ValueNotifier<String> titleNotifier;
  final Widget child;

  const BaseScreen(
      {super.key, required this.child, required this.titleNotifier});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          titleNotifier: titleNotifier,
        ),
        drawer: const MyDrawer(),
        backgroundColor: Colors.white,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LogoutError) {
              showSnackbar(context, state.message);
            } else if (state is LoginError) {
              showSnackbar(context, state.message);
            } else if (state is LogoutSuccess) {
              context.goNamed(AppRoutes.login);
            }
          },
          child: child,
        ),
      ),
    );
  }
}
