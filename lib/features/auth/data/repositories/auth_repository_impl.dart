import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel userModel = await _remoteDataSource.login(
        email,
        password,
      );
      try {
        await _localDataSource.cacheUser(userModel);
      } catch (error) {
        return Left(CacheFailure(error.toString()));
      }
      return Right(userModel);
    } on DioException catch (error) {
      return Left(ServerFailure(error.message ?? 'Login failed'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearCache();
      return const Right(null);
    } on DioException catch (error) {
      return Left(ServerFailure(error.message ?? 'Logout failed'));
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }

    try {
      final remoteUser = await _remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        try {
          await _localDataSource.cacheUser(remoteUser);
        } catch (_) {
          // Ignore cache errors on background refresh.
        }
        return Right(remoteUser);
      }
      return const Right(null);
    } on DioException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to fetch user'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserModel userModel = await _remoteDataSource.register(
        email,
        password,
        name,
      );
      try {
        await _localDataSource.cacheUser(userModel);
      } catch (error) {
        return Left(CacheFailure(error.toString()));
      }
      return Right(userModel);
    } on DioException catch (error) {
      return Left(ServerFailure(error.message ?? 'Registration failed'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
