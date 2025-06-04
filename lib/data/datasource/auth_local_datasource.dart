import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/auth/model/auth_detail_user.dart';
import '../../presentation/auth/model/auth_response_model.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel data) async {
    print("save data login : ${data.toJson()}");
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', data.toJson());
  }

  Future<void> saveAuthDataDetail(AuthResponseDetailModel data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data_detail', data.toJson());
  }

  Future<void> updateAuthData(AuthResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    final authData = await getAuthData();
    if (authData != null) {
      final updatedData = authData.copyWith(busCode: data.busCode);
      await pref.setString('auth_data', updatedData.toJson());
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
    await pref.remove('auth_data_detail');
  }

  Future<AuthResponseModel?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return AuthResponseModel.fromJson(jsonDecode(data));
    } else {
      print("save data gagal");
      return null;
    }
  }

  Future<AuthResponseDetailModel?> getAuthDataDetail() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data_detail');
    if (data != null) {
      return AuthResponseDetailModel.fromJson(jsonDecode(data));
    } else {
      print("save data gagal");
      return null;
    }
  }

  Future<bool> isAuth() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    return data != null;
  }
}
