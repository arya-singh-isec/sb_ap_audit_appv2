import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/presentation/blocs/bloc.dart';
import '../config/constants.dart';
import 'custom_text.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.25, 1.0, 0.25, 1.0),
      reverseCurve: const Cubic(0.75, 0.0, 0.75, 0.0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> toggleDrawer(bool open) async {
    if (open && _controller.isCompleted) return;
    if (!open && _controller.isDismissed) return;

    try {
      await (open ? _controller.forward() : _controller.reverse()).orCancel;
    } on TickerCanceled {
      // Animation was canceled, do nothing
    }
  }

  void _onDrawerItemTap(VoidCallback action) {
    toggleDrawer(false);
    action();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: _animation.value == 0,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => toggleDrawer(false),
                child: Container(
                  color: Colors.black.withOpacity(_animation.value * 0.5),
                ),
              ),
              Opacity(
                opacity: _animation.value,
                child: Transform.translate(
                  offset: Offset(
                      -MediaQuery.of(context).size.width *
                          0.6 *
                          (1 - _animation.value),
                      0),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          children: [
            _buildHeader(),
            _buildDrawerItem(
                'New Form', () => context.goNamed(AppRoutes.selection)),
            _buildDrawerItem(
                'Summary', () => context.goNamed(AppRoutes.summary)),
            _buildDrawerItem(
                'Log out',
                () =>
                    BlocProvider.of<LoginBloc>(context).add(const Submitted())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 87, 80, 77),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccess) {
                return CustomText.labelSmall(
                  'Login by ${state.user!.id}',
                  textColor: TextColor.white,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: () => _onDrawerItemTap(onTap),
      style: TextButton.styleFrom(
        alignment: Alignment.center,
      ),
      child: CustomText.labelSmall(
        title,
        textColor: TextColor.black,
      ),
    );
  }
}

class AppDrawerWrapper extends StatelessWidget {
  final Widget child;

  const AppDrawerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child, AppDrawer(key: AppDrawerController.drawerKey)],
    );
  }
}

class AppDrawerProvider extends InheritedWidget {
  final AppDrawerController controller;

  const AppDrawerProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static AppDrawerController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppDrawerProvider>();
    assert(provider != null, 'No AppDrawerProvider found in context');
    return provider!.controller;
  }

  @override
  bool updateShouldNotify(AppDrawerProvider oldWidget) => false;
}

class AppDrawerController {
  static final GlobalKey<AppDrawerState> drawerKey =
      GlobalKey<AppDrawerState>();

  void open() async {
    await drawerKey.currentState?.toggleDrawer(true);
  }

  void close() async {
    await drawerKey.currentState?.toggleDrawer(false);
  }
}
