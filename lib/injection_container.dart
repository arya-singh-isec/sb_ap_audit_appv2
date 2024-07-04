import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/dio_client.dart';
import 'features/summary/data/datasources/record_remote_data_source.dart';
import 'features/summary/data/repository/record_repository_impl.dart';
import 'features/summary/domain/repositories/record_repository.dart';
import 'features/summary/domain/usecases/get_record_data.dart';
import 'features/summary/presentation/blocs/record_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit
  sl.registerFactory(() => RecordCubit(getRecords: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetRecords(sl()));

  // Repository
  sl.registerLazySingleton<RecordRepository>(() => RecordRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<RecordRemoteDataSource>(() => RecordRemoteDataSourceImpl(dioClient: sl()));

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}