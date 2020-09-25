import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/ui/uix.dart';
import 'package:shoro/utils/CONSTANTS.dart';
import 'package:shoro/utils/demo_data.dart';
import 'distr_document_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MainMenuModel> menu =[];
 @override
  void initState() {
     super.initState();
     menu= MainMenuModel.getMainMenuModels();
  }

 void choiceAction(String choice,BuildContext context){

   if(choice==CONSTANTS.demo){
     DemoData.demoData.insertDemoData();
   }else if (choice==CONSTANTS.synchronization){
     BlocProvider.of<SyncBloc>(context).add(SynchronizationEvent(
         null,
         ''
     ));
   }else if (choice==CONSTANTS.loggedIn){
     Navigator.push(context, MaterialPageRoute(
       builder: (context) => ConnectWidget(),
     ));
   }else{
     BlocProvider.of<SyncBloc>(context).add(SyncDocumentsEvent(
       null,
       ''
     ));
   }

 }

 void onTapMenuItem (BuildContext context, DocumentType documentType) {

   BlocProvider.of<DocumentBloc>(context).add(
     DocumentOpeningEvent(documentType:documentType),
   );

   if(documentType==DocumentType.IncomeOrder){
     Navigator.push(context, MaterialPageRoute(
       builder: (context) => DocumentPage(
         isNew: true,
      )),
     );

   }else if (documentType==DocumentType.Distribution){
       Navigator.push(context, MaterialPageRoute(
           builder: (context) => DistrDocumentPage(
             isNew: true,
           )),
       );
   }else if(documentType==DocumentType.BalanceRemoval){
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => RemovalDocumentPage(
           isNew: true,
         )),
     );
   }else {
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => ReturnDocumentPage(
           isNew: true,
         )),
     );
   }
}

 @override
 Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
       body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text("Shoro"),
          pinned: false,
          expandedHeight: CONSTANTS.appBarHeight,
          elevation: 20.0,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value){
                choiceAction(value,context);
              },
              itemBuilder: (context) {
               return CONSTANTS.choices.map((String choice) => PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                )).toList();
              } ,
            )
          ],
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                onTap: () {

                  onTapMenuItem(context,menu.elementAt(index).documentType);

                },
                child: new Container(
                    decoration: BoxDecoration(
                    color: Colors.brown[100 * (index % 29)],
                  //  borderRadius:BorderRadius.circular(5.0),
                    border: Border(
                      left: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.0,
                      )
                    )
                  ),
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      menu.elementAt(index).icon,
                      Text(menu.elementAt(index).name,textAlign: TextAlign.center,),
                    ],
                  )
                ),
              );
            },
            childCount: menu.length,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.all(5.0),
              width:size.width,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                  border: Border(
                      left: BorderSide(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                  )
              ),
              height: size.height/10,
              margin: EdgeInsets.only(left: 8.0,right: 8.0),
              child: FlatButton(
                onPressed: (){
                   BlocProvider.of<DocumentBloc>(context).add(
                      DocumentOpeningEvent(documentType: DocumentType.DocumentList));
                   Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DocumentListPage(),
                   ));

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.event,color: Colors.white,size: 30,),
                    Text("Мои документы",style: TextStyle(
                      color: Colors.white,fontSize: 18.0,
                    ),),
                  ],
                ),
              ),
            ),

           Container(
              padding: EdgeInsets.all(8.0),
              width:size.width,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  border: Border(
                    left: BorderSide(
                      color: Colors.blueGrey,
                      width: 2.0,
                    ),
                  )
              ),
              height: size.height/10,
              margin: EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AgentReportPage(),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.monetization_on,color: Colors.white,size: 30,),
                    Text("Мои деньги",style: TextStyle(
                      color: Colors.white,fontSize: 18.0,
                    ),),
                  ],
                ),
              ),
            ),

            BlocListener<SyncBloc,SyncState>(
              listener: (context, state) {
                if(state is ErrorSyncState){
                  showDelayedSnackBar(error: true,context: context,text: state.errorText);
                }else if (state is SuccessSyncState){
                  showDelayedSnackBar(error: false,context: context,text: state.resultText);
                }else{
                  showDelayedSnackBar(error: false,context: context,text: "Идет загрузка данных ...");
                }
              },
              child: Container(),
            )


          ]
         ),
        ),

      ],
    ));
  }

  Future<void> showDelayedSnackBar({BuildContext context, String text,bool error}){
    Future.delayed(Duration(seconds: 1)).then((value) {
     final snackBar = new SnackBar(content: Text(text),
       backgroundColor: (error)?Colors.red:Colors.greenAccent,
       duration: Duration(seconds: 5),

     );

     Scaffold.of(context)..hideCurrentSnackBar();
     Scaffold.of(context).showSnackBar(snackBar);

   });


  }

}
