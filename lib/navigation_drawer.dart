import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/widgets/custom_text.dart';
import 'features/login/presentation/blocs/bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
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
                  if (state is LoginSuccess || state is LogoutError) {
                    return CustomText.labelSmall(
                      'Login by ${(state as LoginSuccess).user!.name}',
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
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/selection');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: CustomText.labelSmall('Summary'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/summary');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: CustomText.labelSmall('Log out'),
            onTap: () {
              Navigator.pop(context);
              BlocProvider.of<LoginBloc>(context).add(const Submitted());
            },
          ),
        ],
      ),
    );
  }
}
