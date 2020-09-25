import 'package:shoro/model/agent.dart';
import 'package:shoro/model/price.dart';
import 'package:shoro/service/SQLProvider.dart';

class DocumentListModel{
  String guid;
  String type;
  Agent agent;
  Price price;
  double sum;
  bool sentToServer;

  DocumentListModel({this.type,this.guid, this.agent,
      this.price, this.sum, this.sentToServer});

  factory DocumentListModel.FromJson(Map<String,dynamic>parsedJson){
    return DocumentListModel(

    );
  }


  static Future<List<DocumentListModel>> getDocumentListModels()async{

    List<DocumentListModel> documentListModels=[];


    final db = await SQLProvider.db.database;
    var res = await db.rawQuery("""
    Select
    document.guid,
    document.agentName,
    document.agentGuid,
    document.priceName,
    document.priceGuid,
    document.type,
    document.sentToServer,
    sum(document.sum) as sum
    FROM 
    Documents as document
    Group By
    document.guid,
    document.agentName,
    document.agentGuid,
    document.priceName,
    document.priceGuid,
    document.sentToServer,
    document.type
 
    """);
    var resList = res.toList();

    for(var item in resList){
      DocumentListModel documentListModel = new DocumentListModel(
       agent: new Agent(name: item['agentName'],guid: item['agentGuid']),
       price: new Price(name: item["priceName"],guid: item['priceGuid']) ,
        guid: item['guid'],
        sum: item['sum'],
        sentToServer: (item['sentToServer']==0)?false:true,
        type: item['type'],
      );
    documentListModels.add(documentListModel);
    }
    return documentListModels;
  }
}