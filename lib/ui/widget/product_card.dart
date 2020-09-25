import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoro/model/models.dart';
import 'package:intl/intl.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class ProductCard extends StatefulWidget {
  final ProductList productList;
  final DocumentType documentType;

  const ProductCard({Key key, this.productList, this.documentType}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  TextEditingController countController = TextEditingController();

  double count = 0;

  @override
  void initState() {
    super.initState();
    countController.addListener(_onChangedCount);
    countController.text = (widget.productList.count!=0.0)?widget.productList.count.toString():"";
  }
  @override
  void dispose() {
    countController.dispose();
    super.dispose();
  }

  _onChangedCount(){
    if(widget.documentType!=DocumentType.IncomeOrder){
      if (widget.productList.leftover<count) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text("Ошибка"),
            content: Text("Остаток ${widget.productList.leftover
                .toString()}, вы вели больше чем есть!!!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Закрыть"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],

          );
        },);

        setState(() {
          count = 0;
          countController.text="";
        });
      }
    }

    widget.productList.sum = (count!=0)?count * widget.productList.price:widget.productList.sum;
    widget.productList.count = count;
    setState(() {
    });
  }

String formatNumberCurrency(double value) {
  return NumberFormat.currency(locale: 'ky').format(value);
}


double toDouble(String countString){
    double count = 0;
    String countStringToDouble = countString.replaceAll(",", ".");
    try{
      count = double.parse(countStringToDouble);
    }
    catch(e){
      count = 0;
    }
    return count;
  }

String formatDouble(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width/2.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),bottomLeft:Radius.circular(15.0)),
              color: Colors.brown.shade100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(widget.productList.product.name,
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ) ,),
                ),
                SizedBox(height: 10.0,),
                Expanded(child: Text((widget.productList.comment!=null)?
                    widget.productList.comment:"")),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            width: MediaQuery.of(context).size.width/2.1,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomRight:Radius.circular(15.0)),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(formatNumberCurrency(widget.productList.price),
                   style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                     color: Colors.white,
                  ) ,),
               Text(formatNumberCurrency(widget.productList.sum),
                    style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ) ,),

              Container(
                margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  height:30,
                  child: TextField(
                    cursorColor: Colors.red,
                    onChanged: (value){
                      count = toDouble(value);
                    },
                    controller: countController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
