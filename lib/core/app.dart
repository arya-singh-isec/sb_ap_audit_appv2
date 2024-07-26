import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loggy/loggy.dart';

import '../features/login/data/datasources/user_remote_data_source.dart';
import '../features/login/data/repositories/user_repository_impl.dart';
import '../features/login/domain/repositories/user_repository.dart';
import '../features/login/domain/usecases/login_user.dart';
import '../features/login/domain/usecases/logout_user.dart';
import '../features/login/presentation/blocs/bloc.dart';
import '../features/selection/data/datasources/partners_remote_data_source.dart';
import '../features/selection/data/datasources/team_members_remote_data_source.dart';
import '../features/selection/data/repositories/partners_repository_impl.dart';
import '../features/selection/data/repositories/team_members_repository_impl.dart';
import '../features/selection/domain/repositories/partners_repository.dart';
import '../features/selection/domain/repositories/team_members_repository.dart';
import '../features/selection/domain/usecases/get_partners.dart';
import '../features/selection/domain/usecases/get_subordinates.dart';
import '../features/selection/domain/usecases/get_team_members.dart';
import '../features/selection/presentation/blocs/get_partners_bloc.dart';
import '../features/selection/presentation/blocs/get_team_members_bloc.dart';
import 'config/theme.dart';
import 'navigation/app_router.dart';
import 'network/network_info.dart';
import 'utils/utils.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
    late final Dio dio;
  late final DioClient dioClient;
  late final http.Client client;
  late final UserRemoteDataSource userRemoteDataSource;
  late final UserRepository userRepository;
  late final PartnersRemoteDataSource partnersRemoteDataSource;
  late final PartnersRepository partnersRepository;
  late final TeamMembersRemoteDataSource teamMembersRemoteDataSource;
  late final TeamMembersRepository teamMembersRepository;
  late final NetworkInfo networkInfo;
  late final InternetConnectionChecker connectionChecker;

  MyApp({super.key}) {
    client = http.Client();
    dio = Dio();
    dioClient = DioClient(dio);
    connectionChecker = InternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
    userRemoteDataSource = UserRemoteDataSourceImpl(dioClient: dioClient);
    userRepository = UserRepositoryImpl(
        remoteDataSource: userRemoteDataSource, networkInfo: networkInfo);
    partnersRemoteDataSource = PartnersRemoteDataSourceImpl(client: client);
    partnersRepository = PartnersRepositoryImpl(
        remoteDataSource: partnersRemoteDataSource, networkInfo: networkInfo);
    teamMembersRemoteDataSource =
        TeamMembersRemoteDataSourceImpl(client: client);
    teamMembersRepository = TeamMembersRepositoryImpl(
        remoteDataSource: teamMembersRemoteDataSource,
        networkInfo: networkInfo);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, UiLoggy {
  final ValueNotifier<String> appBarTitleNotifier = ValueNotifier('root');

  // Bloc instances
  late final LoginBloc _loginBloc;
  late final GetPartnersBloc _getPartnersBloc;
  late final GetTeamMembersBloc _getTeamMembersBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loginBloc = LoginBloc(
      loginUser: LoginUser(widget.userRepository),
      logoutUser: LogoutUser(widget.userRepository),
      inputValidator: InputValidator(),
    );
    _getPartnersBloc = GetPartnersBloc(
      getPartners: GetPartners(repository: widget.partnersRepository),
    );
    _getTeamMembersBloc = GetTeamMembersBloc(
      getTeamMembers: GetTeamMembers(repository: widget.teamMembersRepository),
      getSubordinates:
          GetSubordinates(repository: widget.teamMembersRepository),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appBarTitleNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    loggy.debug('AppLifecycle state changed to ${state.name}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _loginBloc),
        BlocProvider.value(value: _getPartnersBloc),
        BlocProvider.value(value: _getTeamMembersBloc),
      ],
      child: MaterialApp.router(
        title: 'ICICIDirect',
        theme: appTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
