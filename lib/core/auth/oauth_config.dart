/// OAuth configuration constants for Google authentication
class OAuthConfig {
  // IMPORTANT: Use the Web Client ID for serverClientId, not the Android Client ID
  // The Android Client ID is automatically handled by the google_sign_in package
  static const String googleServerClientId =
      '866623698380-64qpmr2vlbs0o92cle4ksce63lfmkhra.apps.googleusercontent.com';

  // Android Client ID (not directly used but for reference)
  // This should be configured in Google Cloud Console with your SHA-1 fingerprint
  static const String googleAndroidClientId = 'YOUR_ANDROID_CLIENT_ID_HERE';

  static const String googleProjectId = 'keytype-us';
  static const String googleAuthUri =
      'https://accounts.google.com/o/oauth2/auth';
  static const String googleTokenUri = 'https://oauth2.googleapis.com/token';
  static const String googleCertUrl =
      'https://www.googleapis.com/oauth2/v1/certs';

  // OAuth scopes for Google Sign-In
  static const List<String> googleScopes = ['email', 'profile'];

  // Debug information
  static const String debugSHA1 =
      '63:6A:16:A9:C5:96:38:B9:ED:61:A3:FC:12:C6:DE:23:81:B3:10:DE';
  static const String packageName = 'com.nematiai.keytype';

  // Private constructor to prevent instantiation
  OAuthConfig._();
}
