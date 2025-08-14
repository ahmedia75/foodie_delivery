import 'package:flutter/material.dart';
import 'package:foodie_delivery/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/delivery_agent_model.dart';
import '../networking/api_service.dart';

class LoginController extends ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  String? _error;
  DeliveryAgentModel? _user;

  LoginController(this._apiService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  DeliveryAgentModel? get user => _user;

  Future<bool> login(
    String phone,
    String password,
    String deviceToken,
    String devicePlatform,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post(
        ApiConfig.loginAPI,
        body: {
          'phone': phone,
          'password': password,
          'deviceToken': deviceToken,
          'devicePlatform': devicePlatform,
        },
      );

      print("Login Response: $response");

      if (response['success'] == true && response['data'] != null) {
        _user = DeliveryAgentModel.fromMap(response['data']);
        await _saveUserData();
        return true;
      } else {
        _error = response['error'] ?? 'Login failed';
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserData() async {
    try {
      if (_user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _user!.token ?? '');
        await prefs.setString('user_data', _user!.toJson());
        print("User data saved successfully");
      }
    } catch (e) {
      print("Error saving user data: $e");
      rethrow;
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userData = prefs.getString('user_data');

      print("Checking login status - Token: $token");
      print("Checking login status - User data: $userData");

      if (token != null && userData != null && userData.isNotEmpty) {
        try {
          _user = DeliveryAgentModel.fromJson(userData);
          print("User data loaded successfully: ${_user?.toJson()}");
          notifyListeners();
          return true;
        } catch (e) {
          print("Error parsing user data: $e");
          await logout();
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error checking login status: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_data');
      _user = null;
      notifyListeners();
      print("User logged out successfully");
    } catch (e) {
      print("Error during logout: $e");
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool?> toggleAvailability(bool isAvailable) async {
    if (_user == null || _user!.id == null) return null;
    final agentId = _user!.id!;
    final endpoint = '/delivery-agents/$agentId/availability';
    final response = await _apiService.put(
      endpoint,
      body: {'isAvailable': isAvailable},
    );
    if (response['success'] == true || response['status'] == 200) {
      _user = _user!.copyWith(isAvailable: isAvailable);
      await _saveUserData();
      notifyListeners();
      return isAvailable;
    } else {
      return null;
    }
  }
}
