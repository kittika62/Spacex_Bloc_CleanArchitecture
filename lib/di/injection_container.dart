import 'package:get_it/get_it.dart'; // ใช้สำหรับ DI
import 'package:http/http.dart' as http;
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/features/spacex/data/datasource.dart';
import 'package:spacex_bloc/features/spacex/data/repositories_impl.dart';
import 'package:spacex_bloc/features/spacex/domain/repositories.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart'; // ใช้สำหรับ HTTP

final sl = GetIt.instance; // สร้างตัวแปรสำหรับ Service Locator

void init() {
  // ลงทะเบียน DataSource
  sl.registerLazySingleton<SpacexRemoteDataSource>(
    () => SpacexRemoteDataSourceImpl(client: http.Client()),
  );

  // ลงทะเบียน Repository
  sl.registerLazySingleton<SpacexRepository>(
    () => SpacexRepositoryImpl(remoteDataSource: sl()),
  );

  // ลงทะเบียน UseCases
  sl.registerLazySingleton<FetchSpacexUseCase>(() => FetchSpacexUseCase(sl()));
  sl.registerLazySingleton<SearchSpacexUseCase>(() => SearchSpacexUseCase());
  sl.registerLazySingleton<SortSpacexUseCase>(() => SortSpacexUseCase());

  // ลงทะเบียน Bloc
  sl.registerFactory<SpacexBloc>(
    () => SpacexBloc(
      fetchSpacexUseCase: sl(),
      searchSpacexUseCase: sl(),
      sortSpacexUseCase: sl(),
    ),
  );

  // ลงทะเบียน LocalizationBloc
  sl.registerFactory<LocalizationBloc>(
    () => LocalizationBloc()..add(LoadSavedLocalization()),
  );
}


/*  note before using di */
// void main() {
//   สร้าง Repository และ Inject เข้าไปใน UseCase
//   final spacexRepository = SpacexRepositoryImpl(
//     remoteDataSource: SpacexRemoteDataSourceImpl(client: http.Client()),
//   );
//   final fetchSpacexUseCase = FetchSpacexUseCase(spacexRepository);
//   final searchSpacexUseCase = SearchSpacexUseCase();
//   final sortSpacexUseCase = SortSpacexUseCase();

//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create:
//               (context) => SpacexBloc(
//                 fetchSpacexUseCase: fetchSpacexUseCase,
//                 searchSpacexUseCase: searchSpacexUseCase,
//                 sortSpacexUseCase: sortSpacexUseCase,
//               )..add(SpacexFetchEvent()),
//         ),
//         BlocProvider(
//           create: (context) => LocalizationBloc()..add(LoadSavedLocalization()),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }  */