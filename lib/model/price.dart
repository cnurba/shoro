class Price{
  String name;
  String guid;
  Price({this.name, this.guid});


  factory Price.FromJson(Map<String,dynamic> parsedJson){
    return Price(
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