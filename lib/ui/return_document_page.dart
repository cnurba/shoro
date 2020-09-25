import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/ui/uix.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class ReturnDocumentPage extends StatefulWidget {
  final bool isNew;
  final String documentGuid;

  const ReturnDocumentPage({Key key, this.isNew, this.documentGuid}) : super(key: key);
   @override
  _ReturnDocumentPageState createState() => _ReturnDocumentPageState();
}

class _ReturnDocumentPageState extends State<ReturnDocumentPage> {
  int _currentIndex = 0;
  double _sum; 
  List<ProductList> products = [];

  @override
  void initState() {
    super.initState();
     products = [];
  }

  @override
  void dispose() {
    super.dispose();
    products.clear();
  }

  void _onTapped (int index) async{
    setState(() {
      _currentIndex =index;
    });
   final mistake = await getMistakes();
   if(index==0){

     if(mistake["error"]){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:  Text("Ошибка"),
                content: Text(mistake["errorText"]),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Закрыть"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
         );
     }
     else {
       BlocProvider.of<DocumentBloc>(context).add(DocumentSavingEvent(
         documentGuid: widget.documentGuid,
         isNew: widget.isNew,
         documentType: DocumentType.ReturnOrder,
         productLists: products,
       ));
       Navigator.of(context).pop();
     }
   } else if(index==1){

     if(mistake["error"]){
       showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title:  Text("Ошибка"),
             content: Text(mistake["errorText"]),
             actions: <Widget>[
               FlatButton(
                 child: Text("Закрыть"),
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
               )
             ],
           );
         },
       );
     }
     else {
       BlocProvider.of<DocumentBloc>(context).add(DocumentSendingEvent(
         documentGuid: widget.documentGuid,
         isNew: widget.isNew,
         productLists: products,
       ));
       Navigator.of(context).pop();
     }
   } else{
     Navigator.of(context).pop();
   }

  }

 Future<Map<String,dynamic>> getMistakes() async {
   double sum = products.fold(0, (previousValue, e) => previousValue + e.count);

   Map<String, dynamic> mistakes = {
     "errorText": "",
     "error": false,
   };

   if (sum == 0) {
     mistakes['errorText'] = "Итоговая сумма = 0";
     mistakes['error'] = true;
   }

   double sumCount = products.fold(
       0, (previousValue, e) => previousValue + e.count);
   if (sumCount == 0) {
     mistakes['errorText'] = "Не заполнено количество в строках";
     mistakes['error'] = true;
   }

   return mistakes;

 }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            title: Text("Сохранить"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync,color: Colors.green,),
            title: Text("Отправить"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel,color:Colors.red),
            title: Text("Отмена"),
            backgroundColor: Colors.white,
          )
        ],
        ),
        backgroundColor: Colors.white,
        body:BlocBuilder<DocumentBloc,DocumentState>(
          builder: (context, state) {
            if(state is DocumentReturnOrderOpeningState){
              products=state.productList;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: CONSTANTS.appBarColor,
                    title: Text(
                      "Возвратная накладная",
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ProductCard(
                          productList: products[index],
                          documentType: DocumentType.ReturnOrder,
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },

     ));
  }

}
