import 'dart:convert';
import 'dart:ui';
import 'package:mobx/mobx.dart';
import 'package:shoro/model/user.dart';
import 'package:shoro/service/preferense_helper.dart';
part 'form_store.g.dart';

class CustomColor extends Color {
  CustomColor(int value) : super(value);
}

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store{
  final FormErrorState error= FormErrorState();

  @observable
  CustomColor color;
  @observable
  String login='';
  @observable
  String ip='';
  @observable
  String password='';
  @observable
  String http='';
  @observable
  String port='';
  @observable
  String code='';

  @observable
  ObservableFuture<bool> httpCheck = ObservableFuture.value(true);

  @computed
  bool get isHttpCheckPending => httpCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => login, validateLogin),
      reaction((_) => http, validateHttp),
      reaction((_) => password, validatePassword),
      reaction((_) => code, validateCode),
    ];
  }

  @action
  Future<void> validateHttp(String value) async{
   if(value==null|| value.isEmpty){
     error.http = "Не заполнено поле http";
     return;
   }

   try{
     httpCheck = ObservableFuture(checkValidHttp(value));
     error.http=null;
     final isValid = await httpCheck;

     if (!isValid) {
       error.http = 'Username cannot be "admin"';
       return;
     }

   } on Object catch (_){
     error.http = null;
   }

   error.http = null;

  }

  Future<bool> checkValidHttp(String value) async {
    await Future.delayed(const Duration(seconds: 1));

    return value != 'admin';
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAll() {
    validatePassword(password);
    validateHttp(http);
    validateCode(code);
    validateLogin(login);
    validateIp(ip);

    if(canLogin){
     saveUser();
    }
  }

  @action
  void validateLogin(String value) {
     error.login=(value==null||value.isEmpty)?"Не заполнен логин":null;
  }

  @action
  void validateIp(String value) {
    error.ip=(value==null||value.isEmpty)?"Не заполнен ip":null;
  }

  @action
  void validatePassword(String value) {
    error.password=(value==null||value.isEmpty)?"Не заполнен пароль":null;
  }

  @action
  void validateCode(String value) {
    error.code=(value==null||value.isEmpty)?"Не заполнен код менеджера":null;
  }

  @action
  void setCode(String value) {
    code = value;
  }

  void saveUser (){
    final user =  User(
      code:code,
      port:port,
      http:http,
      login:login,
      ip:ip,
      password:password,
    );
   PreferenceHelper.save("User",json.encode(user.toMap()));
  }
  void removeUser(){
    PreferenceHelper.remove("User");
  }
}

class FormErrorState =_FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store{
  @observable
  String login='';
  @observable
  String password='';
  @observable
  String http='';
  @observable
  String port='';
  @observable
  String code='';
  @observable
  String ip='';

  @computed
  bool get hasErrors => login != null || password != null || http != null || code!=null|| ip!=null;
}

