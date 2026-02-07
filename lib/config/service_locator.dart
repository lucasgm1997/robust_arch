import 'package:get_it/get_it.dart';

import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/strategies/apple_auth_strategy.dart';
import '../data/strategies/email_auth_strategy.dart';
import '../data/strategies/google_auth_strategy.dart';
import '../data/strategies/phone_auth_strategy.dart';
import '../domain/entities/auth_credentials.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/strategies/auth_strategy.dart';
import '../domain/usecases/auth_usecase.dart';
import '../services/session_manager.dart';
import '../ui/auth/view_model/auth_view_model.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Services
  sl.registerSingleton<SessionManager>(SessionManager.instance);

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Strategies
  sl.registerLazySingleton<Map<Type, AuthStrategy>>(
    () => {
      EmailCredentials: EmailAuthStrategy(remoteDataSource: sl()),
      GoogleCredentials: GoogleAuthStrategy(remoteDataSource: sl()),
      AppleCredentials: AppleAuthStrategy(remoteDataSource: sl()),
      PhoneCredentials: PhoneAuthStrategy(remoteDataSource: sl()),
    },
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      strategies: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => AuthUseCase(repository: sl(), sessionManager: sl()),
  );

  // ViewModels
  sl.registerFactory(() => AuthViewModel(authUseCase: sl()));
}
