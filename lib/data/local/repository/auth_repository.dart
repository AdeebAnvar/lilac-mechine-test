import 'package:lilac_test/data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> saveToLocal(UserModel userModel);
  Future<UserModel?> fetchFromLocal();
}
