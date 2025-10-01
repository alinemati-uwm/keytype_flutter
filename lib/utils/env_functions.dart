import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvUtils {
  static String get getApiBaseUrl => dotenv.env['BASE_URL'] ?? '';
  // static String get getApiKey => dotenv.env['API_KEY'] ?? '';
  static String get getWebUrl => dotenv.env['WEB_URL'] ?? '';
}
