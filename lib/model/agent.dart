class Agent{
  String name;
  String guid;
  Agent({this.name, this.guid});

 factory Agent.FromJson(Map<String,dynamic> parsedJson){
    return Agent(
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