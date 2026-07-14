import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class UserRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
}

class UserRepositoryImpl implements UserRepository {
  final Box<UserModel> _userBox;

  UserRepositoryImpl(this._userBox);

  @override
  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  @override
  Future<UserModel?> getUser() async {
    return _userBox.get('current_user');
  }

  @override
  Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }
}