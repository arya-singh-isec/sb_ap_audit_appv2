import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('SELECT'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('HOME'),
          ),
          ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Text('DRAWER'),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('REPORT'),
          ),
        ],
      ),
    );
  }
}
