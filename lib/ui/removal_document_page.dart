import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/ui/widget/product_card.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class RemovalDocumentPage extends StatefulWidget {
  final bool isNew;
  final String documentGuid;

  const RemovalDocumentPage({Key key, this.isNew, this.documentGuid}) : super(key: key);
  @override
  _RemovalDistrDocumentPageState createState() => _RemovalDistrDocumentPageState();
}

class _RemovalDistrDocumentPageState extends State<RemovalDocumentPage> {
  int _currentIndex = 0;
  double _sum; 
  List<ProductList> products = [];
  List<ProductList> productsForReserve = [];
  Agent _selectedAgent;
  Price _selectedPrice;
  Agent _currentAgent;
  Price _currentPrice;

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
         documentType: DocumentType.BalanceRemoval,
         agent: (_selectedAgent ==null)?_currentAgent:_selectedAgent,
         price: (_selectedPrice==null)?_currentPrice:_selectedPrice,
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
         documentType: DocumentType.BalanceRemoval,
         agent: (_selectedAgent ==null)?_currentAgent:_selectedAgent,
         price: (_selectedPrice==null)?_currentPrice:_selectedPrice,
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


   if (_selectedAgent == null&&_currentAgent==null) {

       {
         mistakes['errorText'] = "Не заполнен агент";
         mistakes['error'] = true;
      }


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
            icon: Icon(Icons.cancel,color: Colors.red,),
            title: Text("Отмена"),
            backgroundColor: Colors.white,
          )
        ],
        ),
        backgroundColor: Colors.white,
        body:BlocBuilder<DocumentBloc,DocumentState>(
          builder: (context, state) {
            if(state is DocumentBalanceRemovalSuccessOpeningState){
              _currentAgent =state.currentAgent;

              if(products.length==0) {
                products = state.productList;
              }
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: CONSTANTS.appBarColor,
                    title: Text(
                      "Cнятие остатка",
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      BlocListener<DocumentBloc,DocumentState>(
                        listener: (context, state) {
                          if(state is DocumentBalanceRemovalSuccessOpeningState){
                            if(state.productList.length == 0){
                              final snackBar = new SnackBar(content: Text("Документ раздача не оформлен или выберите другого агента,"),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                elevation: 20.0,
                              );

                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          }
                        },
                        child: Container(),
                      ),

                     _buildDropDownItemWidgetAgent(state.agents,state.currentAgent),

                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ProductCard(
                          productList: products[index],
                          documentType: DocumentType.BalanceRemoval,
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ],
              );
            }else {
              return Center(child: CircularProgressIndicator());
            }

          },

        ));
  }

 Widget _buildDropDownItemWidgetAgent(
    List<DropdownMenuItem<Agent>> dropDownMenuAgents,Agent currentAgent

  ) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            labelText: 'Агент:',
          ),
          hint: Text(" Выберите агента"),
          icon: Icon(CONSTANTS.dropDownIcon),
          items: dropDownMenuAgents,
          value: (_selectedAgent!=null)?_selectedAgent:currentAgent,
          //dropdownColor: Colors.white,
          style: TextStyle(
              color: CONSTANTS.appBarColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
              onChanged: (value) {
              onChangeAgent(value);
          },
        ),
      ),
    );
  }

 void onChangeAgent(Agent value) async{

      _selectedAgent = value;
       final productsFromAgent =
        await Leftovers.getProductListWithLeftOvers(value);
        products = productsFromAgent;
        setState(() {

        });
  }
}
