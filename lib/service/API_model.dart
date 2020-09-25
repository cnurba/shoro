class APIModel<T>{
  T data;
  bool error;
  String errorText;

  APIModel({this.data, this.error, this.errorText});

}