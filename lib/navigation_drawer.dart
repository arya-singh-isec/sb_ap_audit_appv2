import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    return Text(
                      'Login by ${(state as LoginSuccess).user!.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('New Form'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/selection');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Summary'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/summary');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
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
