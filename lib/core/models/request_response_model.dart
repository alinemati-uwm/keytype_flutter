enum ResponseStatus { success, error, loading }

class RequestResponse<T> {
  final ResponseStatus status;
  T? data;
  String? msg;

  RequestResponse.success({this.data, this.msg})
      : status = ResponseStatus.success;

  RequestResponse.error({required this.msg,this.data}) : status = ResponseStatus.error;

  RequestResponse.loading() : status = ResponseStatus.loading;
}
