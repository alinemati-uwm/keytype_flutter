import 'package:get_it/get_it.dart';

// Import all domain repositories
import '../network/auth/auth_repository.dart';
import '../network/chatbot/chatbot_repository.dart';
import '../network/templates/templates_repository.dart';
import '../network/user/user_repository.dart';
import '../network/payments/payments_repository.dart';
import '../network/ai_writer/ai_writer_repository.dart';
import '../network/tasks/task_repository.dart';

// Import all domain API calls
import '../network/auth/auth_api_calls.dart';
import '../network/chatbot/chatbot_api_calls.dart';
import '../network/templates/templates_api_calls.dart';
import '../network/user/user_api_calls.dart';
import '../network/payments/payments_api_calls.dart';
import '../network/ai_writer/ai_writer_api_calls.dart';
import '../network/tasks/task_api_calls.dart';

final GetIt getIt = GetIt.instance;

/// Initializes all domain-based network services
void setupDependencyInjection() {
  // Register all repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<ChatBotRepository>(() => ChatBotRepository());
  getIt.registerLazySingleton<TemplatesRepository>(() => TemplatesRepository());
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<PaymentsRepository>(() => PaymentsRepository());
  getIt.registerLazySingleton<AIWriterRepository>(() => AIWriterRepository());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepository());

  // Register all API calls
  getIt.registerLazySingleton<AuthApiCalls>(() => AuthApiCalls());
  getIt.registerLazySingleton<ChatBotApiCalls>(() => ChatBotApiCalls());
  getIt.registerLazySingleton<TemplatesApiCalls>(() => TemplatesApiCalls());
  getIt.registerLazySingleton<UserApiCalls>(() => UserApiCalls());
  getIt.registerLazySingleton<PaymentsApiCalls>(() => PaymentsApiCalls());
  getIt.registerLazySingleton<AIWriterApiCalls>(() => AIWriterApiCalls());
  getIt.registerLazySingleton<TaskApiCalls>(() => TaskApiCalls());
}
