import 'package:shoro/model/models.dart';
import 'package:shoro/service/SQLProvider.dart';

class ProductList{
  Product product;
  Price  priceType;
  double price;
  double count;
  double sum;
  double leftover;
  String comment;

  ProductList({this.product, this.priceType,this.price,
      this.count, this.sum, this.leftover, this.comment});

  factory ProductList.FromJson(Map<String,dynamic> parsedJson){
    return ProductList(
      product: Product.FromJson(parsedJson['product']),
      priceType: Price.FromJson(parsedJson['price']),
      price:parsedJson['priceType'],
      count:parsedJson['count'],
      sum:parsedJson['sum'],
      leftover:parsedJson['leftover'],
      comment:parsedJson['comment'],
    );
  }

 static Future<List<ProductList>>getProductListByPrice(Price price)async{
    final db = await SQLProvider.db.database;
    var res = await db.rawQuery('''
        SELECT 
        priceList.productName,
        priceList.productGuid,
        priceList.priceName,
        priceList.priceQuid,
        priceList.price
        FROM PriceList
        Where 
        priceList.priceQuid =?  
        ''',['${price.guid}'] );
    var resList = res.toList();
    List<ProductList> list=[];

  for(var item in resList){
      Product product = new Product(name:item["productName"],guid: item["productGuid"]);
      ProductList productList = ProductList(
        product: product,
        priceType: price,
        price: item['price'],
        count: 0,
        sum: 0,
        leftover: 0,
       );
      list.add(productList);
    }
    return list;
  }

 static Future<List<ProductList>>getProductListByProduct(List<Product> products)async {
    List<ProductList> productLists = [];
    for(var item in products){
      ProductList productList = ProductList(
        product: item,
        sum: 0,
        price: 0,
        count: 0,
        comment: 'Не установлен тип цен',
        leftover: 0,
        priceType: Price(),
      );
      productLists.add(productList);
    }
    return productLists;
  }
}