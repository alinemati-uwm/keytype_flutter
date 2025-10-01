import 'package:flutter/foundation.dart';
import 'oauth_config.dart';

/// Debug helper for OAuth configuration
class OAuthDebugHelper {
  static void printConfiguration() {
    if (kDebugMode) {
      print('=== OAuth Configuration Debug ===');
      print('Package Name: ${OAuthConfig.packageName}');
      print('Project ID: ${OAuthConfig.googleProjectId}');
      print('Server Client ID: ${OAuthConfig.googleServerClientId}');
      print('Debug SHA-1: ${OAuthConfig.debugSHA1}');
      print('Scopes: ${OAuthConfig.googleScopes.join(', ')}');
      print('================================');
    }
  }

  static void printGoogleCloudConsoleChecklist() {
    if (kDebugMode) {
      print('=== Google Cloud Console Checklist ===');
      print('1. ✓ Project: ${OAuthConfig.googleProjectId}');
      print('2. ✓ Android OAuth Client:');
      print('   - Package: ${OAuthConfig.packageName}');
      print('   - SHA-1: ${OAuthConfig.debugSHA1}');
      print('3. ✓ Web OAuth Client (for serverClientId):');
      print('   - Client ID: ${OAuthConfig.googleServerClientId}');
      print('4. ✓ APIs Enabled:');
      print('   - Google Sign-In API');
      print('   - Google+ API (if needed)');
      print('=====================================');
    }
  }

  static Map<String, String> getRequiredGoogleCloudSettings() {
    return {
      'project_id': OAuthConfig.googleProjectId,
      'android_package_name': OAuthConfig.packageName,
      'android_sha1_fingerprint': OAuthConfig.debugSHA1,
      'web_client_id': OAuthConfig.googleServerClientId,
      'required_apis': 'Google Sign-In API, Identity Toolkit API',
    };
  }
}
