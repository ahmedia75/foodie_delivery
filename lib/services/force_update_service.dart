import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateService {
  // Update these with your actual app package details
  static const String _androidPackageId = "com.ahmedia.delivery";
  static const String _androidStoreUrl =
      "https://play.google.com/store/apps/details?id=com.ahmedia.delivery";

  /// Check if a force update is required (Android only)
  static Future<ForceUpdateResult> checkForForceUpdate() async {
    try {
      // Only check for Android platform
      if (!Platform.isAndroid) {
        print("🔄 Force update check skipped - iOS not supported");
        return ForceUpdateResult(
          isUpdateRequired: false,
          currentVersion: "Unknown",
          storeVersion: null,
          error: "Force update only supported on Android",
        );
      }

      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      print("🔄 FORCE UPDATE CHECK STARTED");
      print("📱 Current app version: $currentVersion");

      // Get store version
      String? storeVersion = await _getAndroidStoreVersion();
      print("🏪 Store version: $storeVersion");

      if (storeVersion == null || storeVersion.isEmpty) {
        print("❌ Could not fetch store version");
        return ForceUpdateResult(
          isUpdateRequired: false,
          currentVersion: currentVersion,
          storeVersion: null,
          error: "Could not fetch store version",
        );
      }

      // Compare versions
      int comparison = _compareVersions(storeVersion, currentVersion);
      bool isUpdateRequired = comparison > 0;

      print("🔍 Version comparison result: $comparison");
      print("📊 Current version: $currentVersion");
      print("📊 Store version: $storeVersion");
      print("⚡ Update required: $isUpdateRequired");

      // FOR TESTING: Uncomment the line below to force an update
      // isUpdateRequired = true;
      // print("🧪 TESTING MODE: Forcing update to true");

      // Debug: Additional logging for troubleshooting
      if (!isUpdateRequired) {
        print("🔍 DEBUG: No update required");
        print("🔍 Current parsed: ${_parseVersion(currentVersion)}");
        print("🔍 Store parsed: ${_parseVersion(storeVersion)}");
      }

      return ForceUpdateResult(
        isUpdateRequired: isUpdateRequired,
        currentVersion: currentVersion,
        storeVersion: storeVersion,
        error: null,
      );
    } catch (e) {
      print("❌ Error checking for force update: $e");
      return ForceUpdateResult(
        isUpdateRequired: false,
        currentVersion: "Unknown",
        storeVersion: null,
        error: e.toString(),
      );
    }
  }

  /// Get Android Play Store version
  static Future<String?> _getAndroidStoreVersion() async {
    try {
      PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();
      var result = await playStoreSearchAPI.lookupById(
        _androidPackageId,
        country: 'IN',
      );
      if (result != null) {
        return playStoreSearchAPI.version(result);
      }
      return null;
    } catch (e) {
      print("Error getting Android store version: $e");
      return null;
    }
  }

  /// Parse version string into list of integers for debugging
  static List<int> _parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  /// Compare two version strings
  static int _compareVersions(String version1, String version2) {
    List<int> v1Parts = _parseVersion(version1);
    List<int> v2Parts = _parseVersion(version2);

    // Pad with zeros to make lengths equal
    while (v1Parts.length < v2Parts.length) {
      v1Parts.add(0);
    }
    while (v2Parts.length < v1Parts.length) {
      v2Parts.add(0);
    }

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }

  /// Launch the Play Store (Android only)
  static Future<bool> launchStore() async {
    try {
      if (!Platform.isAndroid) {
        print("❌ Store launch not supported on iOS");
        return false;
      }

      Uri url = Uri.parse(_androidStoreUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      } else {
        print("Could not launch store URL: $_androidStoreUrl");
        return false;
      }
    } catch (e) {
      print("Error launching store: $e");
      return false;
    }
  }
}

/// Result class for force update check
class ForceUpdateResult {
  final bool isUpdateRequired;
  final String currentVersion;
  final String? storeVersion;
  final String? error;

  ForceUpdateResult({
    required this.isUpdateRequired,
    required this.currentVersion,
    this.storeVersion,
    this.error,
  });
}
