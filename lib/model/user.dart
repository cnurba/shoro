class User {
  String login;
  String password;
  String ip;
  String http;
  String port;
  String code;

  User({this.ip,this.login, this.password, this.http, this.port, this.code});

  factory User.FromJson(Map<String,dynamic> parsedJson){
    return User(
      password: parsedJson['password'],
      port: parsedJson['port'],
      http: parsedJson['http'],
      ip: parsedJson['ip'],
      login: parsedJson['login'],
      code: parsedJson['code']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'login':login,
      'ip':ip,
      'password':password,
      'http':http,
      'port':port,
      'code':code,
    };
  }

}