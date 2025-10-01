import '../models/request_response_model.dart';

/// Extension to provide backward compatibility for Either results
/// This allows existing controllers to continue using .status and .data properties
extension EitherCompat<T> on dynamic {
  ResponseStatus get status {
    if (this is Future) {
      throw Exception('Cannot get status from Future. Use await first.');
    }

    // Handle Either<Failure, T> results
    if (toString().contains('Right(')) {
      return ResponseStatus.success;
    } else if (toString().contains('Left(')) {
      return ResponseStatus.error;
    }

    // Fallback for other types
    return ResponseStatus.error;
  }

  T? get data {
    if (this is Future) {
      throw Exception('Cannot get data from Future. Use await first.');
    }

    // Handle Either<Failure, T> results
    try {
      return fold((l) => null, (r) => r);
    } catch (e) {
      return null;
    }
  }

  String? get msg {
    if (this is Future) {
      throw Exception('Cannot get msg from Future. Use await first.');
    }

    // Handle Either<Failure, T> results
    try {
      return fold((l) => l.message, (r) => 'Success');
    } catch (e) {
      return 'Unknown error';
    }
  }
}
