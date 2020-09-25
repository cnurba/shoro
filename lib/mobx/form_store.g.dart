// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormStore on _FormStore, Store {
  Computed<bool> _$isHttpCheckPendingComputed;

  @override
  bool get isHttpCheckPending => (_$isHttpCheckPendingComputed ??=
          Computed<bool>(() => super.isHttpCheckPending,
              name: '_FormStore.isHttpCheckPending'))
      .value;
  Computed<bool> _$canLoginComputed;

  @override
  bool get canLogin => (_$canLoginComputed ??=
          Computed<bool>(() => super.canLogin, name: '_FormStore.canLogin'))
      .value;

  final _$colorAtom = Atom(name: '_FormStore.color');

  @override
  CustomColor get color {
    _$colorAtom.reportRead();
    return super.color;
  }

  @override
  set color(CustomColor value) {
    _$colorAtom.reportWrite(value, super.color, () {
      super.color = value;
    });
  }

  final _$loginAtom = Atom(name: '_FormStore.login');

  @override
  String get login {
    _$loginAtom.reportRead();
    return super.login;
  }

  @override
  set login(String value) {
    _$loginAtom.reportWrite(value, super.login, () {
      super.login = value;
    });
  }

  final _$passwordAtom = Atom(name: '_FormStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$httpAtom = Atom(name: '_FormStore.http');

  @override
  String get http {
    _$httpAtom.reportRead();
    return super.http;
  }

  @override
  set http(String value) {
    _$httpAtom.reportWrite(value, super.http, () {
      super.http = value;
    });
  }

  final _$portAtom = Atom(name: '_FormStore.port');

  @override
  String get port {
    _$portAtom.reportRead();
    return super.port;
  }

  @override
  set port(String value) {
    _$portAtom.reportWrite(value, super.port, () {
      super.port = value;
    });
  }

  final _$codeAtom = Atom(name: '_FormStore.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  final _$httpCheckAtom = Atom(name: '_FormStore.httpCheck');

  @override
  ObservableFuture<bool> get httpCheck {
    _$httpCheckAtom.reportRead();
    return super.httpCheck;
  }

  @override
  set httpCheck(ObservableFuture<bool> value) {
    _$httpCheckAtom.reportWrite(value, super.httpCheck, () {
      super.httpCheck = value;
    });
  }

  final _$validateHttpAsyncAction = AsyncAction('_FormStore.validateHttp');

  @override
  Future<void> validateHttp(String value) {
    return _$validateHttpAsyncAction.run(() => super.validateHttp(value));
  }

  final _$_FormStoreActionController = ActionController(name: '_FormStore');

  @override
  void validateLogin(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateLogin');
    try {
      return super.validateLogin(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validatePassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validatePassword');
    try {
      return super.validatePassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateCode(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateCode');
    try {
      return super.validateCode(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
color: ${color},
login: ${login},
password: ${password},
http: ${http},
port: ${port},
code: ${code},
httpCheck: ${httpCheck},
isHttpCheckPending: ${isHttpCheckPending},
canLogin: ${canLogin}
    ''';
  }
}

mixin _$FormErrorState on _FormErrorState, Store {
  Computed<bool> _$hasErrorsComputed;

  @override
  bool get hasErrors =>
      (_$hasErrorsComputed ??= Computed<bool>(() => super.hasErrors,
              name: '_FormErrorState.hasErrors'))
          .value;

  final _$loginAtom = Atom(name: '_FormErrorState.login');

  @override
  String get login {
    _$loginAtom.reportRead();
    return super.login;
  }

  @override
  set login(String value) {
    _$loginAtom.reportWrite(value, super.login, () {
      super.login = value;
    });
  }

  final _$passwordAtom = Atom(name: '_FormErrorState.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$httpAtom = Atom(name: '_FormErrorState.http');

  @override
  String get http {
    _$httpAtom.reportRead();
    return super.http;
  }

  @override
  set http(String value) {
    _$httpAtom.reportWrite(value, super.http, () {
      super.http = value;
    });
  }

  final _$portAtom = Atom(name: '_FormErrorState.port');

  @override
  String get port {
    _$portAtom.reportRead();
    return super.port;
  }

  @override
  set port(String value) {
    _$portAtom.reportWrite(value, super.port, () {
      super.port = value;
    });
  }

  final _$codeAtom = Atom(name: '_FormErrorState.code');

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  @override
  String toString() {
    return '''
login: ${login},
password: ${password},
http: ${http},
port: ${port},
code: ${code},
hasErrors: ${hasErrors}
    ''';
  }
}
