import 'dart:async';

import 'package:dio/dio.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

/// Temporary in-memory implementation until the real backend is wired.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;
  UserModel? _currentUser;

  @override
  Future<UserModel> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _currentUser = UserModel(
      id: email.hashCode.toString(),
      email: email,
      name: email.split('@').first,
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _currentUser = UserModel(
      id: '$name-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }
}
