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
import '../features/login/presentation/pages/login_screen.dart';
import '../features/questionTable/presentation/pages/rejected_record_page.dart';
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
import '../features/selection/presentation/pages/selection_screen.dart';
import '../features/summary/presentation/pages/record_list.dart';
import '../navigation_drawer.dart';
import 'app_bar.dart';
import 'network/network_info.dart';
import 'utils/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
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
    connectionChecker = InternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
    userRemoteDataSource = UserRemoteDataSourceImpl(client: client);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    loggy.debug('AppLifecycle state changed to ${state.name}');
  }

  Widget _wrapWithScaffold(
      BuildContext context, Widget child, String appBarTitle) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const MyDrawer(),
        appBar: CustomAppBar(initialTitle: appBarTitle),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LogoutError) {
              showSnackbar(context, state.message);
            } else if (state is LoginError) {
              showSnackbar(context, state.message);
            } else if (state is LogoutSuccess) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            loginUser: LoginUser(widget.userRepository),
            logoutUser: LogoutUser(widget.userRepository),
            inputValidator: InputValidator(),
          ),
        ),
        BlocProvider<GetPartnersBloc>(
          create: (context) => GetPartnersBloc(
            getPartners: GetPartners(repository: widget.partnersRepository),
          ),
        ),
        BlocProvider<GetTeamMembersBloc>(
          create: (_) => GetTeamMembersBloc(
            getTeamMembers:
                GetTeamMembers(repository: widget.teamMembersRepository),
            getSubordinates:
                GetSubordinates(repository: widget.teamMembersRepository),
          ),
        )
      ],
      child: AppBarProvider(
        titleNotifier: appBarTitleNotifier,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          title: 'My App',
          initialRoute: '/login',
          routes: {
            '/login': (_) => _wrapWithScaffold(_, const LoginScreen(), ''),
            '/selection': (_) => _wrapWithScaffold(
                _, const SelectionScreen(), 'Partner Selection'),
            '/summary': (_) =>
                _wrapWithScaffold(_, const RecordListPage(), 'Summary'),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == '/rejectedRecord') {
              final args = settings.arguments as RejectedRecordPageArguments;
              return MaterialPageRoute(builder: (context) {
                return _wrapWithScaffold(
                    context,
                    RejectedRecordPage(record: args.record),
                    '${args.record.name} Details');
              });
            }
            return null;
          },
        ),
      ),
    );
  }
}
