import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/ui/widget/product_card.dart';
import 'package:shoro/utils/CONSTANTS.dart';


class DocumentPage extends StatefulWidget {
  final bool isNew;
  final String documentGuid;

  const DocumentPage({Key key, this.isNew, this.documentGuid}) : super(key: key);
  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  int _currentIndex = 0;
  double _sum; 
  List<ProductList> products = [];
  List<ProductList> productsForReserve = [];
  Agent _selectedAgent;
  Price _selectedPrice;
  DocumentType _documentType;



  @override
  void initState() {
    super.initState();
    _documentType = DocumentType.IncomeOrder;
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
         documentType: _documentType,
         agent: _selectedAgent,
         price: _selectedPrice,
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
        documentGuid:widget.documentGuid,
        isNew: widget.isNew,
        agent: _selectedAgent,price: _selectedPrice,
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

  if (_selectedPrice == null) {
     mistakes['errorText'] = "Не заполнен Тип цен";
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
            icon: Icon(Icons.cancel,color: Colors.red,),
            title: Text("Отмена"),
            backgroundColor: Colors.white,
          )
        ],
        ),
        backgroundColor: Colors.white,
        body:BlocBuilder<DocumentBloc,DocumentState>(
          builder: (context, state) {
            if(state is DocumentSSuccessOpeningState){
              _selectedAgent= Agent(guid: '1',name: "Manager");
              _selectedPrice = state.currentPrice;
              products = state.productList;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: CONSTANTS.appBarColor,
                    title: Text(
                      "Приходная накладная",
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      BlocListener<DocumentBloc,DocumentState>(
                        listener: (context, state) {
                          if(state is DocumentSSuccessOpeningState){
                            if(state.productList.length == 0){
                              final snackBar = new SnackBar(content: Text("Пустые данные, нажмите на кнопку Обновить данные"),
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
                     _buildDropDownItemWidgetPrice(dropDownMenuPrice: state.prices,currentPrice: state.currentPrice),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ProductCard(
                          productList: products[index],
                          documentType: DocumentType.IncomeOrder,
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ],
              );

            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          }

        ));
  }

 Widget _buildDropDownItemWidgetPrice({
    List<DropdownMenuItem<Price>> dropDownMenuPrice,Price currentPrice

  }) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            labelText: 'Тип цен:',
          ),
          hint: Text(" Выберите вид цен"),
          icon: Icon(CONSTANTS.dropDownIcon),
          items: dropDownMenuPrice,
          value: (_selectedPrice!=null)?_selectedPrice:currentPrice,
         // dropdownColor: Colors.white,
          style: TextStyle(
              color: CONSTANTS.appBarColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
          onChanged: (value) {
            setState(() {
               _selectedPrice = value;
            });
            _onChangePriceType(_selectedPrice);
          },
        ),
      ),
    );
  }

  void _onChangePriceType(Price _selectedPrice) async {
    final productLists =
        await ProductList.getProductListByPrice(_selectedPrice);

    for (ProductList productList in products) {
      final foundPrices = productLists
          .where((element) => element.product.guid == productList.product.guid)
          .toList();

      if (foundPrices.length > 0) {
        productList.price = foundPrices[0].price;
        productList.sum = productList.price * productList.count;
        productList.priceType = _selectedPrice;
      }
      setState(() {});
    }
  }

}
