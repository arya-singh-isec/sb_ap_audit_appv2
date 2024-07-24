import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/presentation/pages/login_screen.dart';
import '../../features/questionTable/presentation/pages/rejected_record_page.dart';
import '../../features/selection/presentation/pages/selection_screen.dart';
import '../../features/summary/domain/entities/record.dart';
import '../../features/summary/presentation/pages/record_list.dart';
import '../widgets/base_screen.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _titleNotifier = ValueNotifier<String>('');

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      name: AppRoutes.login,
      path: '/login',
      builder: (context, state) => BaseScreen(
        titleNotifier: _titleNotifier,
        child: const LoginScreen(),
      ),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        if (state.fullPath == '/selection') {
          _titleNotifier.value = 'Partner Selection';
        } else if (state.fullPath == '/selection/summary') {
          _titleNotifier.value = 'Summary';
        } else if (state.fullPath == '/selection/summary/rejectedRecord') {
          _titleNotifier.value = '${(state.extra as Record).name} Details';
        }
        return NoTransitionPage(
          child: BaseScreen(
            titleNotifier: _titleNotifier,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
            name: AppRoutes.selection,
            path: '/selection',
            builder: (context, state) => const SelectionScreen(),
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.summary,
                path: 'summary',
                builder: (context, state) => const RecordListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    name: AppRoutes.rejectedRecord,
                    path: 'rejectedRecord',
                    builder: (context, state) => RejectedRecordPage(
                      record: state.extra as Record,
                    ),
                  ),
                ],
              ),
            ]),
      ],
    ),
  ],
);
