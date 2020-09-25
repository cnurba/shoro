
class Product{
  String name;
  String guid;

  Product({this.name, this.guid});


  factory Product.FromJson(Map<String,dynamic> parsedJson){
    return Product(
      name: parsedJson['name'],
      guid: parsedJson['guid'],

    );
  }
  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'guid':guid,
    };
  }
}