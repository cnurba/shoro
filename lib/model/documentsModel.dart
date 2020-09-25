import 'package:flutter/material.dart';
import 'package:shoro/model/agent.dart';
import 'package:shoro/model/price.dart';
import 'package:shoro/model/product_list.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class DocumentsModel{
  int id;
  String type;
  String guid;
  String agentName;
  String agentGuid;
  String priceName;
  String priceGuid;
  String productName;
  String productQuid;
  double count;
  double price;
  double sum;
  bool sentToServer;


  DocumentsModel({
      this.id,
      this.guid,
      this.type,
      this.agentName,
      this.agentGuid,
      this.priceName,
      this.priceGuid,
      this.productName,
      this.productQuid,
      this.count,
      this.price,
      this.sum,
      this.sentToServer});

 static String getDocumentStringType(DocumentType type) {
    if (type == DocumentType.IncomeOrder) {
      return "Приходная накладная";
    } else if (type == DocumentType.ReturnOrder) {
      return "Возвратная накладная";
    } else if (type == DocumentType.Distribution) {
      return "Раздача";
    } else if (type == DocumentType.BalanceRemoval) {
      return "Возврат";
    } else {
      return "";
    }
  }

 static DocumentType getDocumentType(String type) {
    if (type == "Приходная накладная") {
      return DocumentType.IncomeOrder;
    } else if (type == "Возвратная накладная") {
      return DocumentType.ReturnOrder;
    } else if (type == "Раздача" ) {
      return DocumentType.Distribution;
    } else {
      return DocumentType.BalanceRemoval;
    }
  }

 static List<DocumentsModel> prepareDocumentList(String documentGuid, DocumentType documentType, Agent agent,Price price,List<ProductList> products){
    List<DocumentsModel> listDocumentsModel =[];

    for(var item in products){
     if(item.sum>0) {
       var documentsModel = DocumentsModel(
         guid: documentGuid,
         agentName: (agent != null) ? agent.name : "",
         agentGuid: (agent != null) ? agent.guid : "",
         priceName: (price != null) ? price.name : "",
         priceGuid: (price != null) ? price.guid : "",
         type: getDocumentStringType(documentType),
         productName: item.product.name,
         productQuid: item.product.guid,
         price: item.price,
         sum: item.sum,
         count: item.count,
         sentToServer: false,
       );

       listDocumentsModel.add(documentsModel);
     }
    }

    return listDocumentsModel;

  }


 factory DocumentsModel.fromJSon(Map<String,dynamic> parsedJson){
    return DocumentsModel(
      id: parsedJson["id"],
      type: parsedJson["type"],
      guid: parsedJson["guid"],
      agentName: parsedJson["agentName"],
      agentGuid: parsedJson["agentGuid"],
      priceName: parsedJson["priceName"],
      priceGuid: parsedJson["priceGuid"],
      productName: parsedJson["productName"],
      productQuid: parsedJson["productQuid"],
      count: parsedJson["count"],
      price: parsedJson["price"],
      sum: parsedJson["sum"],
      sentToServer: parsedJson["sentToServer"],
    );
  }

 Map<String,dynamic> toMap(){
    return {
      'id':id,
      'guid':guid,
      'agentName':agentName,
      'agentGuid':agentGuid,
      'priceName':priceName,
      'priceGuid':priceGuid,
      'productName':productName,
      'productQuid':productQuid,
      'count':count,
      'price':price,
      'sum':sum,
      'sentToServer':sentToServer,
      'type':type,
    };
  }

}