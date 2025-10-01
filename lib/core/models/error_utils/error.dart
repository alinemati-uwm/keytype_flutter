abstract class AppError<ErrorType> {
  String errorMessage(final ErrorType errorType);
}

class Failure {
  final String? message;
  final int? code;

  Failure(this.message, this.code);
}
