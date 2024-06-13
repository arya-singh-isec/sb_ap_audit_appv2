import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

 @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 67, 70, 71),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20, ),
                Text(
                  'Login By',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
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
              Navigator.of(context).pushReplacementNamed( '/summary');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
