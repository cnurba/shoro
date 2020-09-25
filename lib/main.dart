import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/mobx/form_store.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/ui/home_page.dart';
import 'package:shoro/utils/CONSTANTS.dart';


void main() {
  runApp(MultiBlocProvider(
      providers: [
       BlocProvider<SyncBloc>(
         create: (context)=>SyncBloc(LoadingSyncState()),
       ) ,
       BlocProvider<DocumentBloc>(
         create: (context) => DocumentBloc(DocumentLoadingState()),
       ),
      ],
      child: MyApp()));
  SQLProvider.db.initDB();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
       Provider<FormStore>(
         create: (_)=>FormStore(),
         child: MaterialApp(
          title: 'Shoro',
          theme: ThemeData(
            primaryColor: CONSTANTS.primaryColor,
             visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
     ),
       );
  }
}
