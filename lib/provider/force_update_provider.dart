import 'package:flutter/material.dart';
import '../services/force_update_service.dart';

class ForceUpdateProvider extends ChangeNotifier {
  bool _isChecking = false;
  bool _isUpdateRequired = false;
  bool _hasChecked = false; // Add flag to track if we've already checked
  ForceUpdateResult? _updateResult;
  String? _error;

  bool get isChecking => _isChecking;
  bool get isUpdateRequired => _isUpdateRequired;
  bool get hasChecked => _hasChecked;
  ForceUpdateResult? get updateResult => _updateResult;
  String? get error => _error;

  /// Check for force update
  Future<void> checkForForceUpdate({bool forceRecheck = false}) async {
    // Prevent multiple checks unless force recheck is requested
    if (_isChecking || (_hasChecked && !forceRecheck)) {
      print("🔄 Force update check skipped - already checked or in progress");
      return;
    }

    print("🚀 Starting force update check...");
    _isChecking = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ForceUpdateService.checkForForceUpdate();
      _updateResult = result;
      _isUpdateRequired = result.isUpdateRequired;
      _error = result.error;
      _hasChecked = true; // Mark as checked

      print(
        "✅ Force update check completed - Update required: $_isUpdateRequired",
      );
    } catch (e) {
      print("❌ Force update check failed: $e");
      _error = e.toString();
      _isUpdateRequired = false;
      _hasChecked = true; // Mark as checked even on error
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }

  /// Launch the store for update
  Future<bool> launchStore() async {
    try {
      return await ForceUpdateService.launchStore();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Reset the provider state
  void reset() {
    _isChecking = false;
    _isUpdateRequired = false;
    _hasChecked = false;
    _updateResult = null;
    _error = null;
    notifyListeners();
  }
}
