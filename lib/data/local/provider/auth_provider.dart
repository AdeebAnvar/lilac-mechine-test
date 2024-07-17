import 'dart:convert';
import 'dart:developer';

import 'package:lilac_test/data/local/repository/auth_repository.dart';
import 'package:lilac_test/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends AuthRepository {
  @override
  Future<UserModel?> fetchFromLocal() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString('user');

      if (userData != null) {
        log(userData.toString());
        final Map<String, dynamic> userMap = jsonDecode(userData) as Map<String, dynamic>;
        final UserModel userModel = UserModel.fromMap(userMap);
        return userModel;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<void> saveToLocal(UserModel userModel) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userData = json.encode(userModel.toMap());
      print(userData);
      await prefs.setString('user', userData);
    } catch (e) {
      log(e.toString());
    }
  }
}
