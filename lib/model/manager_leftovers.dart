import 'package:shoro/model/models.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class ManagerLeftovers{
  String documentGuid;
  String documentType;
  String productName;
  String productGuid;
  String priceGuid;
  String priceName;
  double count;
  double price;
  double sum;

  ManagerLeftovers({this.documentGuid,this.documentType, this.productName, this.productGuid,
      this.priceName,this.priceGuid,this.count, this.price, this.sum});

  factory ManagerLeftovers.FromJson(Map<String,dynamic> parsedJson){
    return ManagerLeftovers(
      documentGuid: parsedJson['documentGuid'] ,
      documentType: parsedJson['documentType'],
      productName: parsedJson['productName'],
      productGuid: parsedJson['productGuid'],
      priceName: parsedJson['priceName'],
      priceGuid: parsedJson['priceGuid'],
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
      'priceGuid':priceGuid,
      'priceName':priceName,
      'count':count,
      'price':price,
      'sum':sum,
     };
  }
 
 static List<ManagerLeftovers> prepareManagerLeftoversList(String documentGuid,DocumentType documentType,List<ProductList> products) {
    List<ManagerLeftovers> listManagerLeftovers = [];
    for (var item in products) {
      if (item.sum != 0) {
        double _sum = 0;
        double _count = 0;
        if(documentType==DocumentType.Distribution || documentType==DocumentType.ReturnOrder ){
          _sum = item.sum *-1;
          _count =item.count*-1;
        }else{
          _sum =item.sum;
          _count =item.count;
        }
          final manageLeftovers = ManagerLeftovers(
          documentGuid: documentGuid,
          documentType: DocumentsModel.getDocumentStringType(documentType),
          productName: item.product.name,
          productGuid: item.product.guid,
          priceName: item.priceType.name,
          priceGuid: item.priceType.guid,
          count: _count,
          price: item.price,
          sum: _sum,
        );
        listManagerLeftovers.add(manageLeftovers);
      }

    }

    return listManagerLeftovers;
  }

static Future<List<ProductList>> getProductListWithLeftOvers(List<ProductList> productList) async{
    List<ProductList> productListForWidget = [];

    final dataBase = await SQLProvider.db.database;

    var res = await dataBase.rawQuery('''
      Select 
      managerLeftovers.productName,
      managerLeftovers.productGuid,
      Sum(managerLeftovers.sum) as sum,
      Sum(managerLeftovers.count) as count
      FROM ManagerLeftovers 
      GROUP BY
      managerLeftovers.productName,
      managerLeftovers.productGuid
      ''');
    var resList =  res.toList();

    for(var productItem in productList){
      String comment = "Остаток = 0";
      double leftover=0;
      double sum =0;
      for (var item in resList){
        if(item["productGuid"]==productItem.product.guid){
          leftover = item['count'];
          comment = "Остаток = ${item['count'].toString()}";
          sum = item['sum'];
        }
      }
      var product= ProductList(
        product: productItem.product,
        priceType: productItem.priceType,
        price: productItem.price,
        sum:  sum,
        count:  productItem.count,
        leftover:leftover,
        comment: comment,
      );
      productListForWidget.add(product);
    }
    return productListForWidget;
  }

static Future<List<ProductList>> getProductListForReturnOrder() async{
    List<ProductList> productListForWidget = [];
    final dataBase = await SQLProvider.db.database;
    //get typeofPrice and price
    var resPrice = await dataBase.rawQuery('''
      Select 
      managerLeftovers.productName,
      managerLeftovers.productGuid,
      managerLeftovers.priceName,
      managerLeftovers.priceGuid,
      managerLeftovers.price
      FROM ManagerLeftovers 
      Where 
      managerLeftovers.documentType=?        
    ''',["${DocumentsModel.getDocumentStringType(DocumentType.IncomeOrder)}"]);

    var resPriceList = resPrice.toList();
    List<ProductList> productPrices = [];
    for(var item in resPriceList){
      ProductList productList = new ProductList(
        product: Product(name: item['productName'],guid: item['productGuid']),
        priceType: Price(name: item['priceName'],guid: item['priceGuid']),
        price: item['price'],
      );
      productPrices.add(productList);
    }


    var res = await dataBase.rawQuery('''
      Select 
      managerLeftovers.productName,
      managerLeftovers.productGuid,
      Sum(managerLeftovers.count) as count,
      Sum(managerLeftovers.sum) as sum
      FROM ManagerLeftovers 
      GROUP BY
      managerLeftovers.productName,
      managerLeftovers.productGuid
  
    ''');

    var resList =  res.toList();

    for(var item in resList){
      ProductList productList = new ProductList(
        product: Product(name: item['productName'],guid: item['productGuid']),
        priceType: Price(),
        sum: 0,
        price: item['price'],
        leftover: item['count'],
        count: 0,
        comment: "К возврату: кол-во ${item['count']}, Сумма:${item['sum']}",
      );
      productListForWidget.add(productList);
    }
    for(var item in productListForWidget){
      productPrices.forEach((element) {
        if(element.product.guid ==item.product.guid){
          item.priceType = element.priceType;
          item.price = element.price;
        }
      });

    }

    return productListForWidget;
 }

static Future<List<ProductList>> getProductListWithLeftOversByPrice(Price price) async{
   final dataBase = await SQLProvider.db.database;
   var res = await dataBase.rawQuery('''
      Select 
      managerLeftovers.productName,
      managerLeftovers.productGuid,
      Sum(managerLeftovers.sum) as sum,
      Sum(managerLeftovers.count) as count
      FROM ManagerLeftovers 
      GROUP BY
      managerLeftovers.productName,
      managerLeftovers.productGuid
      ''');

    var resList =  res.toList();
    List<ProductList> productListForWidget=[];

   for(var item in resList){
      ProductList productList = new ProductList(
        product: Product(name: item['productName'],guid: item['productGuid']),
        leftover: item['count'],
        comment: 'Остаток: ${item['count']}',
        count: 0,
        sum: 0,
        price: 0,
        priceType: Price(),
      );
      productListForWidget.add(productList);
   }

   if(price!=null){
     final productListWithPrice = await ProductList.getProductListByPrice(price);

     for(var item in productListForWidget){
       productListWithPrice.forEach((element) {
         if(element.product.guid == item.product.guid){
           item.price = element.price;
           item.priceType = element.priceType;
         }
       });
     }
  }
   //delete if count = 0;
  productListForWidget.removeWhere((element) => element.leftover==0);

  return productListForWidget;

}

}