import 'dependency_injection.dart';

class AppInit {
  void useCaseRepository() {
    // Initialize all domain-based network services
    setupDependencyInjection();
  }
}
