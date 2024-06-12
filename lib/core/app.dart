import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/login/presentation/pages/login_screen.dart';
import '../navigation_drawer.dart';
import '../selection_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _wrapWithScaffold(Widget? child) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        drawer: child is! LoginScreen ? const MyDrawer() : null,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 128, 0, 0),
          ),
        ),
        body: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) =>
            _wrapWithScaffold(const LoginScreen()),
        '/selection': (BuildContext context) =>
            _wrapWithScaffold(const SelectionScreen())
      },
      initialRoute: '/login',
      title: 'My App',
    );
  }
}
