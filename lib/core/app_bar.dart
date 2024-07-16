import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/custom_text.dart';

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
            statusBarColor: Color(0xFF800000),
            statusBarIconBrightness: Brightness.light,
          ),
          title: CustomText.titleMedium(
            title,
            textColor: TextColor.white,
          ),
          backgroundColor: const Color(0xFFB22222),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          toolbarHeight: 48,
        );
      },
    );
  }

  @override
  Size get preferredSize => titleNotifier.value.isEmpty
      ? Size.zero
      : const Size.fromHeight(48); // Match the toolbarHeight
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
