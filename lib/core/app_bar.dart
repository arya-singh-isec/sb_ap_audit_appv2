import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<String> titleNotifier;

  CustomAppBar({super.key, required String initialTitle})
      : titleNotifier = ValueNotifier(initialTitle);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: titleNotifier,
      builder: (context, title, child) {
        return AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 128, 0, 0),
          ),
          title: Text(title),
          backgroundColor: const Color.fromARGB(255, 178, 34, 34),
          foregroundColor: Colors.white,
        );
      },
    );
  }

  @override
  Size get preferredSize => titleNotifier.value.isEmpty
      ? Size.zero
      : const Size.fromHeight(kToolbarHeight);
}

class AppBarProvider extends InheritedWidget {
  final ValueNotifier<String> titleNotifier;

  const AppBarProvider({
    super.key,
    required super.child,
    required this.titleNotifier,
  });

  static AppBarProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppBarProvider>()!;
  }

  @override
  bool updateShouldNotify(AppBarProvider oldWidget) {
    return titleNotifier != oldWidget.titleNotifier;
  }
}
