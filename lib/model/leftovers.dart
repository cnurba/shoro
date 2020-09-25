import 'package:shoro/model/documentsModel.dart';
import 'package:shoro/model/price.dart';
import 'package:shoro/model/product.dart';
import 'package:shoro/model/product_list.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/utils/CONSTANTS.dart';

import 'agent.dart';

class Leftovers{
  String documentGuid;
  String documentType;
  String productName;
  String productGuid;
  String agentName;
  String agentQuid;
  String priceName;
  String priceQuid;
  double count;
  double price;
  double sum;

  Leftovers({this.documentGuid,this.documentType,this.productName, this.productGuid, this.agentName, this.agentQuid,
     this.priceName,this.priceQuid, this.count, this.price, this.sum});

  factory Leftovers.FromJson(Map<String,dynamic> parsedJson){
    return Leftovers(
      documentGuid:parsedJson['documentGuid'] ,
      documentType: parsedJson['documentType'],
      productName: parsedJson['productName'],
      productGuid: parsedJson['productGuid'],
      agentName: parsedJson['agentName'],
      agentQuid: parsedJson['agentQuid'],
      priceName: parsedJson['priceName'],
      priceQuid: parsedJson['priceQuid'],
      count: parsedJson['count'],
      price: parsedJson['price'],
      sum: parsedJson['sum'],
    );
  }
 Map<String,dynamic> toMap(){
    return {
      'documentGuid':documentGuid,
      'documentType':documentType,
      'productName':productName,
      'productGuid':productGuid,
      'agentName':agentName,
      'agentQuid':agentQuid,
      'priceName':priceName,
      'priceQuid':priceQuid,
      'count':count,
      'price':price,
      'sum':sum,
    };
  }
 static List<Leftovers> prepareAgentLeftoversList(String documentGuid,DocumentType documentType,Agent agent,List<ProductList> products) {
    List<Leftovers> listAgentLeftovers = [];
    for (var item in products) {
      if (item.sum != 0) {
        double _sum = 0;
        double _count = 0;
        if(documentType==DocumentType.BalanceRemoval){
          _sum = item.sum *-1;
          _count =item.count*-1;
        }else{
          _sum =item.sum;
          _count =item.count;
        }
        final leftovers = Leftovers(
          documentGuid: documentGuid,
          documentType: DocumentsModel.getDocumentStringType(documentType),
          agentName: agent.name,
          agentQuid: agent.guid,
          productName: item.product.name,
          productGuid: item.product.guid,
          priceName: item.priceType.name,
          priceQuid: item.priceType.guid,
          count: _count,
          price: item.price,
          sum: _sum,
        );
        listAgentLeftovers.add(leftovers);
      }

    }
    return listAgentLeftovers;
  }

 static Future<List<ProductList>> getProductListWithLeftOvers(Agent agent) async{
    List<ProductList> _productList = [];
    final dataBase = await SQLProvider.db.database;
    var res = await dataBase.rawQuery('''
      Select
      leftover.productName,
      leftover.productGuid,
      leftover.priceName,
      leftover.priceQuid,
      leftover.price,
      SUM(leftover.count) as count,
      SUM(leftover.sum) as sum
      FROM
      Leftovers as leftover
      where
      leftover.agentQuid =?
      Group by 
      leftover.productName,
      leftover.productGuid,
      leftover.priceName,
      leftover.priceQuid,
      leftover.price
    ''',["${agent.guid}"]);

    var resList =  res.toList();
    for(var item in resList){
      var product= ProductList(
        product: Product(name:item['productName'],guid: item['productGuid'] ),
        priceType: Price(name:item['priceName'],guid: item['priceQuid'] ),
        price: item['price'],
        sum:  item['sum'],
        count:  0,
        leftover:item['count'],
        comment: "Кол-во ${item['count']}, Сумма:${item['sum']} [цена:${item['price'].toString()}]",
      );

      _productList.add(product);
    }
    return _productList;
  }
}