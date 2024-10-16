abstract class ResponseResult<T> {
  final T? data;
  final Exception? error;

  const ResponseResult({this.data, this.error});
}

class ResponseSuccess<T> extends ResponseResult<T> {
  const ResponseSuccess(T data) : super(data: data);
}

class ResponseError<T> extends ResponseResult<T> {
  const ResponseError(Exception error) : super(error: error);
}