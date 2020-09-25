import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/mobx/form_store.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/service/preferense_helper.dart';

class ConnectWidget extends StatefulWidget {
  const ConnectWidget();
  @override
  _ConnectWidgetState createState() => _ConnectWidgetState();
}

class _ConnectWidgetState extends State<ConnectWidget> {
  final FormStore store = FormStore();
  TextEditingController httpController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    store.setupValidations();

    getUser().then((value) {
      httpController.text = (value!=null)?value.http:null;
      portController.text = (value!=null)?value.port:null;
      loginController.text = (value!=null)?value.login:null;
      passwordController.text = (value!=null)?value.password:null;
      codeController.text = (value!=null)?value.code:null;
      ipController.text = (value!=null)?value.ip:null;

      store.password = passwordController.text;
      store.login = loginController.text;
      store.http = httpController.text;
      store.port = portController.text;
      store.ip = ipController.text;
      store.code = codeController.text;


    }
    );

  }

 Future<User> getUser () async{
    final hasKey = await PreferenceHelper.containsKey("User");
    User user = User();
    if(hasKey){
      final jsonString =  await PreferenceHelper.read("User");
      user = User.FromJson(jsonString);
    }

    return user;
 }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Параметры подключения"),
      ),
      body:
          SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
               children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                   Observer(builder: (context) =>
                       TextField(
                         onChanged: (value) => store.login = value,
                         controller: loginController,
                         decoration: InputDecoration(
                             labelText: 'login',
                             hintText: 'Введите логин',
                             errorText: store.error.login),
                       ),
                     ),
                   Observer(builder: (context) =>
                        TextField(
                          onChanged: (value) => store.password = value,
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'password',
                              hintText: 'Введите пароль',
                              errorText: store.error.password),
                        ),
                    ),
                    Observer(builder: (context) =>
                        TextField(
                          onChanged: (value) => store.ip = value,
                          keyboardType: TextInputType.number,
                          controller: ipController,
                          decoration: InputDecoration(
                              labelText: 'ip',
                              hintText: 'Введите ip',
                              errorText: store.error.ip),
                        ),
                    ),
                    Observer(builder: (context) =>
                        TextField(
                          onChanged: (value) => store.http = value,
                          controller: httpController,
                          decoration: InputDecoration(
                              labelText: 'http',
                              hintText: 'wts/hs/serv',
                              errorText: store.error.http),
                        ),
                    ),
                    Observer(builder: (context) {
                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: store.isHttpCheckPending?1:0,
                        child: const LinearProgressIndicator(),
                      );
                    },),
                    Observer(builder: (context) =>
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: portController,
                          onChanged: (value) => store.port = value,
                          decoration: InputDecoration(
                              labelText: 'port',
                              hintText: '80',
                              errorText: store.error.port),
                        ),
                    ),
                    Observer(builder: (context) =>
                        TextField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value){
                            codeController.text = value;
                          },
                          onChanged: (value) => store.code = value,
                          decoration: InputDecoration(
                              labelText: 'Код менеджера',
                              hintText: 'Введите код менеджера',
                              errorText: store.error.code),
                        ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                         RaisedButton(
                               color: Colors.brown,
                               child: const Text(
                                 'Регистрация', style: TextStyle(
                                 color: Colors.white,
                               ),),
                               onPressed: store.validateAll,
                             ),

                        IconButton(
                          icon: Icon(Icons.sync,size: 30,color: Colors.greenAccent,),
                        // child: const Text('Синхронизация'),
                          onPressed:(!store.error.hasErrors)?null:(){
                               BlocProvider.of<SyncBloc>(context).add(
                                  RegistrationEvent(
                                    User(
                                      code: codeController.text,
                                      login: loginController.text,
                                      http: httpController.text,
                                      port: portController.text,
                                      password: passwordController.text,
                                      ip: ipController.text,
                                    ),
                                    "reg",
                                  ));
                            },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever,color: Colors.red,size: 30,),
                          onPressed: store.removeUser,
                        )
                      ],
                    ),

                    BlocListener<SyncBloc,SyncState>(
                      child: Container(),
                      listener: (context, state) {
                        if(state is ErrorSyncState){
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 5),
                            content: Text(state.errorText,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        else if(state is SuccessSyncState){
                            final snackBar = SnackBar(
                              backgroundColor: Colors.blue,
                              duration: Duration(seconds: 5),
                              content: Text(state.resultText,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);

                            Navigator.pop(context);
                          }
                        else{
                          final snackBar = SnackBar(
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 5),
                            content: Text("Идет загрузка",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                         Scaffold.of(context).showSnackBar(snackBar);

                        }


                      },
                    )


                  ],
                ),
              ],
            ),
          ),


    );
  }
}
