import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    return result.fold(
      (failure) => throw AsyncError(failure.message, StackTrace.current),
      (user) => user,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading<User?>();

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(email: email, password: password);

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData<User?>.new,
    );
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncLoading<User?>();

    final result = await repository.logout();
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData<User?>(null),
    );
  }
}

@riverpod
DioClient dioClient(DioClientRef ref) => DioClient();

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AuthRemoteDataSourceImpl(dio);
}

@riverpod
AuthLocalDataSource authLocalDataSource(AuthLocalDataSourceRef ref) {
  return const AuthLocalDataSourceImpl();
}

@riverpod
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(dataSource, localDataSource);
}

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}
