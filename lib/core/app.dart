import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../features/login/data/datasources/user_remote_data_source.dart';
import '../features/login/data/repositories/user_repository_impl.dart';
import '../features/login/domain/repositories/user_repository.dart';
import '../features/login/domain/usecases/login_user.dart';
import '../features/login/domain/usecases/logout_user.dart';
import '../features/login/presentation/blocs/login_bloc.dart';
import '../features/login/presentation/pages/login_screen.dart';
import '../navigation_drawer.dart';
import '../selection_screen.dart';
import 'network/network_info.dart';
import 'utils/input_validator.dart';

class MyApp extends StatelessWidget {
  late final http.Client client;
  late final UserRemoteDataSource userRemoteDataSource;
  late final UserRepository userRepository;
  late final NetworkInfo networkInfo;
  late final InternetConnectionChecker connectionChecker;

  MyApp({super.key}) {
    client = http.Client();
    connectionChecker = InternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
    userRemoteDataSource = UserRemoteDataSourceImpl(client: client);
    userRepository = UserRepositoryImpl(
        remoteDataSource: userRemoteDataSource, networkInfo: networkInfo);
  }

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            loginUser: LoginUser(userRepository),
            logoutUser: LogoutUser(userRepository),
            inputValidator: InputValidator(),
          ),
        ),
      ],
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) =>
              _wrapWithScaffold(const LoginScreen()),
          '/selection': (BuildContext context) =>
              _wrapWithScaffold(const SelectionScreen())
        },
        initialRoute: '/login',
        title: 'My App',
      ),
    );
  }
}
