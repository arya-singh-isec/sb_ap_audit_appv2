import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sb_ap_audit_appv2/features/login/presentation/pages/login_screen.dart';

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
    final drawerController = AppDrawerProvider.of(context);

    return child is LoginScreen
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              titleNotifier: titleNotifier,
              openDrawer: drawerController.open,
            ),
            // drawer: AppDrawer(key: _appDrawerKey),
            backgroundColor: Colors.white,
            body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LogoutError) {
                  showToastMessage(context, state.message);
                } else if (state is LoginError) {
                  showToastMessage(context, state.message);
                } else if (state is LogoutSuccess) {
                  context.goNamed(AppRoutes.login);
                }
              },
              child: child,
            ),
          )
        : AppDrawerWrapper(
            child: GestureDetector(
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                drawerController.close();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: CustomAppBar(
                  titleNotifier: titleNotifier,
                  openDrawer: drawerController.open,
                ),
                // drawer: AppDrawer(key: _appDrawerKey),
                backgroundColor: Colors.white,
                body: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LogoutError) {
                      showToastMessage(context, state.message);
                    } else if (state is LoginError) {
                      showToastMessage(context, state.message);
                    } else if (state is LogoutSuccess) {
                      context.goNamed(AppRoutes.login);
                    }
                  },
                  child: child,
                ),
              ),
            ),
          );
  }
}
