import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loggy/loggy.dart';

import '../core/network/dio_client.dart';
import '../features/login/data/datasources/user_remote_data_source.dart';
import '../features/login/data/repositories/user_repository_impl.dart';
import '../features/login/domain/repositories/user_repository.dart';
import '../features/login/domain/usecases/login_user.dart';
import '../features/login/domain/usecases/logout_user.dart';
import '../features/login/presentation/blocs/bloc.dart';
import '../features/selection/data/datasources/partners_remote_data_source.dart';
import '../features/selection/data/datasources/selection_remote_data_source.dart';
import '../features/selection/data/datasources/team_members_remote_data_source.dart';
import '../features/selection/data/repositories/partners_repository_impl.dart';
import '../features/selection/data/repositories/selection_repository_impl.dart';
import '../features/selection/data/repositories/team_members_repository_impl.dart';
import '../features/selection/domain/repositories/partners_repository.dart';
import '../features/selection/domain/repositories/selection_repository.dart';
import '../features/selection/domain/repositories/team_members_repository.dart';
import '../features/selection/domain/usecases/get_fiscal_year_data.dart';
import '../features/selection/domain/usecases/get_partners.dart';
import '../features/selection/domain/usecases/get_subordinates.dart';
import '../features/selection/domain/usecases/get_team_members.dart';
import '../features/selection/presentation/blocs/get_fiscal_year/bloc.dart';
import '../features/selection/presentation/blocs/get_partners/bloc.dart';
import '../features/selection/presentation/blocs/get_team_members/bloc.dart';
import '../features/selection/presentation/blocs/submit_selection/bloc.dart';
import '../features/summary/data/datasources/summary_remote_data_source.dart';
import '../features/summary/data/repository/summary_repository_impl.dart';
import '../features/summary/domain/repositories/summary_repository.dart';
import '../features/summary/domain/usecases/get_summary_data.dart';
import '../features/summary/presentation/blocs/summary_bloc.dart';
import 'config/theme.dart';
import 'navigation/app_router.dart';
import 'network/network_service.dart';
import 'utils/utils.dart';

late final LoginBloc loginBloc;

class MyApp extends StatefulWidget {
  late final DioClient client;
  late final UserRemoteDataSource userRemoteDataSource;
  late final UserRepository userRepository;
  late final PartnersRemoteDataSource partnersRemoteDataSource;
  late final PartnersRepository partnersRepository;
  late final TeamMembersRemoteDataSource teamMembersRemoteDataSource;
  late final SelectionRemoteDataSource selectionRemoteDataSource;
  late final SummaryRemoteDataSource summaryRemoteDataSource;
  late final SummaryRepository summaryRepository;
  late final TeamMembersRepository teamMembersRepository;
  late final SelectionRepository selectionRepostiory;
  late final NetworkService networkService;

  MyApp({super.key}) {
    client = DioClient(Dio());
    networkService = NetworkService();
    userRemoteDataSource = UserRemoteDataSourceImpl(client: client);
    userRepository = UserRepositoryImpl(
        remoteDataSource: userRemoteDataSource, networkService: networkService);
    partnersRemoteDataSource = PartnersRemoteDataSourceImpl(client: client);
    partnersRepository = PartnersRepositoryImpl(
        remoteDataSource: partnersRemoteDataSource,
        networkService: networkService);
    teamMembersRemoteDataSource =
        TeamMembersRemoteDataSourceImpl(client: client);
    teamMembersRepository = TeamMembersRepositoryImpl(
        remoteDataSource: teamMembersRemoteDataSource,
        networkService: networkService);
    selectionRemoteDataSource = SelectionRemoteDataSourceImpl(client: client);
    selectionRepostiory = SelectionRepositoryImpl(
        remoteDataSource: selectionRemoteDataSource,
        networkService: networkService);
    summaryRemoteDataSource = SummaryRemoteDataSourceImpl(client: client);
    summaryRepository = SummaryRepositoryImpl(
        remoteDataSource: summaryRemoteDataSource,
        networkService: networkService);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, UiLoggy {
  final ValueNotifier<String> appBarTitleNotifier = ValueNotifier('root');
  late final StreamSubscription _connectivityListener;

  // Bloc/Cubit instances
  late final GetPartnersBloc _getPartnersBloc;
  late final GetTeamMembersBloc _getTeamMembersBloc;
  late final GetFiscalYearBloc _getFiscalYearBloc;
  late final SelectionBloc _selectionBloc;
  late final SummaryCubit _summaryCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loginBloc = LoginBloc(
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
    _getFiscalYearBloc = GetFiscalYearBloc(
      getFiscalYearData:
          GetFiscalYearData(repository: widget.selectionRepostiory),
    );
    _selectionBloc = SelectionBloc();
    _summaryCubit = SummaryCubit(
      getSummarys: GetSummarys(repository: widget.summaryRepository),
    );
    // Listen to Network Service
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _connectivityListener =
          widget.networkService.connectivityStream.listen((isConnected) {
        if (isConnected!) {
          showToastMessage(context, 'Back Online');
        } else {
          showToastMessage(context, 'Lost Internet Connection');
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityListener.cancel();
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
        BlocProvider.value(value: loginBloc),
        BlocProvider.value(value: _getPartnersBloc),
        BlocProvider.value(value: _getTeamMembersBloc),
        BlocProvider.value(value: _getFiscalYearBloc),
        BlocProvider.value(value: _selectionBloc),
        BlocProvider.value(value: _summaryCubit),
      ],
      child: MaterialApp.router(
        title: 'ICICIDirect',
        theme: appTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
