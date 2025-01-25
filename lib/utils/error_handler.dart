class ErrorHandler {
  static String handle(dynamic error) {
    if (error is HttpException) {
      return 'HTTP Error: ${error.message}';
    } else if (error is FormatException) {
      return 'Format Error: Invalid response format';
    } else {
      return 'Unexpected Error: ${error.toString()}';
    }
  }
}

class HttpException implements Exception{
  final int statusCode;
  final String message;

  HttpException(this.statusCode,this.message);
    @override
  String toString() => 'HttpException($statusCode): $message';
}