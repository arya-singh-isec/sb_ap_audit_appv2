import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<String> titleNotifier;
  final Function() openDrawer;

  const CustomAppBar(
      {super.key, required this.titleNotifier, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF800000),
        statusBarIconBrightness: Brightness.light,
      ),
      leading: IconButton(
        onPressed: openDrawer,
        icon: const Icon(Icons.menu),
      ),
      title: ValueListenableBuilder(
        valueListenable: titleNotifier,
        builder: (context, title, child) => CustomText.titleMedium(
          title,
          textColor: TextColor.white,
        ),
      ),
      backgroundColor: const Color(0xFFB22222),
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      toolbarHeight: 48,
    );
  }

  @override
  Size get preferredSize => titleNotifier.value.isEmpty
      ? Size.zero
      : const Size.fromHeight(48); // Match the toolbarHeight
}
