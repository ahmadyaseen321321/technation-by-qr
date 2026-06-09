

class AppExceptions implements Exception{

  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    if (_message == null || _message.toString().isEmpty) {
      return _prefix != null ? _prefix.toString() : "";
    }
    if (_prefix == null || _prefix.toString().isEmpty) {
      return _message.toString();
    }
    return "$_prefix: $_message";
  }
}

class InternetException extends AppExceptions{
  InternetException([String? message]) : super(message, "No Internet");

}

class RequestTimeOutException extends AppExceptions{
  RequestTimeOutException([String? message]) : super(message, "Request Time Out");

}

class ServerException extends AppExceptions{
  ServerException([String? message]) : super(message, "Internal Server Error");

}

class BadRequestException extends AppExceptions{
  BadRequestException([String? message]) : super(message, "Invalid Request");

}

class FetchDataException extends AppExceptions{
  FetchDataException([String? message]) : super(message, "");
}

class UnauthorizedException extends AppExceptions{
  UnauthorizedException([String? message]) : super(message, "");
}

class InvalidUrlException extends AppExceptions{
  InvalidUrlException([String? message]) : super(message, "");
}


