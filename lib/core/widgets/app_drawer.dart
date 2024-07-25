import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/presentation/blocs/bloc.dart';
import '../config/constants.dart';
import 'custom_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 67, 70, 71),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  if (state is LoginSuccess) {
                    return CustomText.labelSmall(
                      'Login by ${(state as LoginSuccess).user!.id}',
                      textColor: TextColor.white,
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: CustomText.labelSmall('New Form'),
            onTap: () {
              Navigator.of(context).pop();
              context.goNamed(AppRoutes.selection);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: CustomText.labelSmall('Summary'),
            onTap: () {
              Navigator.of(context).pop();
              context.goNamed(AppRoutes.summary);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: CustomText.labelSmall('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              BlocProvider.of<LoginBloc>(context).add(const Submitted());
            },
          ),
        ],
      ),
    );
  }
}
