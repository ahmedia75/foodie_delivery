// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
// import 'package:dropwayy_app/view/authendication/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:foodie_delivery/model/delivery_agent_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

class SharedService {
  static Future<VoidCallback?> setLoginDetails(LoginResponseModel model) async {
    final SharedPreferences storage = await _storage;
    final cacheDBModel = jsonEncode(model.toJson());
    await storage.setString("Login_details", cacheDBModel);
    return null;
  }

  static Future<String?> isLoggedIn() async {
    final SharedPreferences storage = await _storage;
    var token = storage.getString('Login_details');
    return token;
  }

  static Future<String?> getString(value) async {
    final SharedPreferences storage = await _storage;
    return storage.getString(value);
  }

  static Future<List<String>?> getStringList(value) async {
    final SharedPreferences storage = await _storage;
    return storage.getStringList(value);
  }

  static Future<String?> getToken() async {
    final SharedPreferences storage = await _storage;
    var token = storage.getString('Login_details');
    LoginResponseModel customer = LoginResponseModel.fromJson(
      jsonDecode(token.toString()),
    );
    return customer.data!.token;
  }

  static Future<bool> getDeliveryAgent() async {
    final SharedPreferences storage = await _storage;
    var token = storage.getString('Login_details');

    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getDeliveryAgentId() async {
    final SharedPreferences storage = await _storage;
    var token = storage.getString('Login_details');
    LoginResponseModel deliveryAgent = LoginResponseModel.fromJson(
      jsonDecode(token.toString()),
    );
    return deliveryAgent.data!.id;
  }

  static Future<LoginResponseModel?> getLoggedDeliveryAgent() async {
    final SharedPreferences storage = await _storage;
    var data = storage.getString('Login_details');
    LoginResponseModel customer = LoginResponseModel.fromJson(
      jsonDecode(data.toString()),
    );
    return customer;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    final SharedPreferences storage = await _storage;
    var iskeyExist = storage.getString('Login_details');
    if (iskeyExist != null) {
      var cacheData = storage.getString('Login_details');
      return LoginResponseModel.fromJson(json.decode(cacheData!));
    }
    return null;
  }

  static Future<VoidCallback?> updateLoginDetails(
    LoginResponseModel model,
  ) async {
    model.data!.token = await getToken();
    final SharedPreferences storage = await _storage;
    LoginResponseModel? customer = await getLoggedDeliveryAgent();
    model.data!.token = customer!.data!.token;

    await storage.remove("Login_details");
    final cacheDBModel = jsonEncode(model.toJson());

    bool isUpdated = await storage.setString("Login_details", cacheDBModel);
    if (isUpdated) {
      storage.reload();
      var token = storage.getString('Login_details');
    } else {
      print("not updated");
    }

    return null;
  }

  // static Future<VoidCallback?> logout(context) async {
  //   final SharedPreferences storage = await _storage;
  //   await storage.clear();
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     NewLoginScreen.routeName,
  //     (route) => false,
  //   );
  //   return null;
  // }

  static Future<String?> getMerchantId() async {
    final SharedPreferences storage = await _storage;
    var token = storage.getString('Login_details');
    LoginResponseModel agent = LoginResponseModel.fromJson(
      jsonDecode(token.toString()),
    );
    return agent.data!.id;
  }
}
