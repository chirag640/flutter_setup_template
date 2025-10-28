import 'package:hive/hive.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  static const String userBoxKey = 'user_box';
  static const String currentUserKey = 'current_user';

  @override
  Future<UserModel?> getCachedUser() async {
    final box = await Hive.openBox<dynamic>(userBoxKey);
    final json = box.get(currentUserKey);
    if (json is Map) {
      return UserModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final box = await Hive.openBox<dynamic>(userBoxKey);
    await box.put(currentUserKey, user.toJson());
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<dynamic>(userBoxKey);
    await box.delete(currentUserKey);
  }
}
