class PriceList{
  String productName;
  String productGuid;
  String priceName;
  String priceQuid;
  double price;

  PriceList({this.productName, this.productGuid, this.priceName, this.priceQuid,
      this.price});

  factory PriceList.FromJson(Map<String,dynamic> parsedJson){
    return PriceList(
      price: parsedJson['price'].toDouble(),
      productName: parsedJson['productName'],
      productGuid: parsedJson['productGuid'],
      priceName: parsedJson['priceName'],
      priceQuid: parsedJson['priceQuid'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'price':price,
      'productName':productName,
      'productGuid':productGuid,
      'priceName':priceName,
      'priceQuid':priceQuid,
    };
  }

}