import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoro/model/models.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'API_model.dart';

class Helper1C {
 User user;
 String template;

 Helper1C(this.user, this.template);

 String getUrl() {
   if(user.port!=null ||user.port!="") {
     return 'http://${user.ip}:${user.port}/${user.http}/${template}';
   }
   return 'http://${user.ip}/${user.http}/${template}';
 }

 Map<String,dynamic> getCodeUser(){
   return {
     'code':user.code,
   };
 }

 Map<String,String>  getHeaders () {
   return {
     'Authorization': 'Basic ' + base64Encode(utf8.encode('${user.login}:${user.password}')),
     'Content-type': 'text/html; charset=utf-8',
   };
 }

Future<APIModel<List<String>>> postRegistration(User user) async{
   return await http.post(getUrl(),headers: getHeaders(),body: json.encode(getCodeUser())).then((data) {
     if(data.statusCode==200) {
       final jsonData = json.decode(utf8.decode(data.bodyBytes));
       if (jsonData["error"]) {
         return APIModel<List<String>>(errorText: jsonData["errorText"],
             error: jsonData["error"],
             data: null);
       } else {
         List<String> resultSync = [];

         if (jsonData["data"].containsKey("Agent")) {
           final text = SQLProvider.db.insertAgents(jsonData["data"]);
           resultSync.add(text);
         }
         if (jsonData["data"].containsKey("Product")) {
           final text = SQLProvider.db.insertProducts(jsonData["data"]);
           resultSync.add(text);
         }
         if (jsonData["data"].containsKey("Price")) {
           final text = SQLProvider.db.insertPrices(jsonData["data"]);
           resultSync.add(text);
         }
         if (jsonData["data"].containsKey("PriceList")) {
           final text = SQLProvider.db.insertPriceLists(jsonData["data"]);
           resultSync.add(text);
         }
         return APIModel<List<String>>(error: false,
             errorText: "Успешно данные получены из сервера",
             data: resultSync);
       }
     }
     return APIModel<List<String>>(
       errorText:
       "Ошибка подключения: код ошибки ${data.statusCode.toString()}",
       error: true,);
   }).catchError((e){
     return APIModel<List<String>>(
       data: [],
       errorText:
       "Ошибка подключения:${e.toString()}",
       error: true,);
   });
 }

Future<APIModel<List<String>>> postAllDocumentsToServer(User user) async{

  final dataToSend = await SQLProvider.db.getAllDocumentsAsJson();
  dataToSend["User"] = user.toMap();
  dataToSend["code"] = user.code;
  return await http.post(getUrl(),headers: getHeaders(),body: json.encode(dataToSend)).then((data) {
    if(data.statusCode==200) {
      final jsonData = json.decode(utf8.decode(data.bodyBytes));
      if (jsonData["error"]) {
        return APIModel<List<String>>(errorText: jsonData["errorText"],
            error: jsonData["error"],
            data: null);
      } else {

        List<String> documents = [];

        if(jsonData['data']!='') {
          for (var item in jsonData['data']) {
            documents.add(item);
          }
        }

        return APIModel<List<String>>(error: false,
            errorText: "Успешно данные получены из сервера",
            data: documents);
      }
    }
    return APIModel<List<String>>(
      errorText:
      "Ошибка подключения: код ошибки ${data.statusCode.toString()}",
      error: true,);
  }).catchError((e){
    return APIModel<List<String>>(
      data: null,
      errorText:
      "Ошибка подключения:${e.toString()}",
      error: true,);
  });

}


Future<APIModel<Map<String,dynamic>>> synchronization(User user) async{
   final dataToSend = await SQLProvider.db.getAllDocumentsAsJson();
   dataToSend["User"] = user.toMap();
   dataToSend["code"] = user.code;
   return await http.post(getUrl(),headers: getHeaders(),body: json.encode(dataToSend)).then((data) {
     if(data.statusCode==200) {
       final jsonData = json.decode(utf8.decode(data.bodyBytes));
       if (jsonData["error"]) {
         return APIModel<Map<String,dynamic>>(errorText: jsonData["errorText"],
             error: jsonData["error"],
             data: null);
       } else {

         List<String> documents = [];

         for(var item in jsonData['data']['dataServ']){
           documents.add(item);
         }
         List<String> resultSync = [];
         if (jsonData["data"]['dataDoc'].containsKey("Agent")) {
           final text = SQLProvider.db.insertAgents(jsonData["data"]['dataDoc']);
           resultSync.add(text);
         }
         if (jsonData["data"]['dataDoc'].containsKey("Product")) {
           final text = SQLProvider.db.insertProducts(jsonData["data"]['dataDoc']);
           resultSync.add(text);
         }
         if (jsonData["data"]['dataDoc'].containsKey("Price")) {
           final text = SQLProvider.db.insertPrices(jsonData["data"]['dataDoc']);
           resultSync.add(text);
         }
         if (jsonData["data"]['dataDoc'].containsKey("PriceList")) {
           final text = SQLProvider.db.insertPriceLists(jsonData["data"]['dataDoc']);
           resultSync.add(text);
         }
         final Map<String,dynamic> dates = {
           'dataServ':documents,
           'dataDoc' :resultSync,
         };
         return APIModel<Map<String,dynamic>>(error: false,
             errorText: "Успешно данные получены из сервера",
             data: dates);
       }
     }
     return APIModel<Map<String,dynamic>>(
       errorText:
       "Ошибка подключения: код ошибки ${data.statusCode.toString()}",
       error: true,);
   }).catchError((e){
     return APIModel<Map<String,dynamic>>(
       data: null,
       errorText:
       "Ошибка подключения:${e.toString()}",
       error: true,);
   });
 }

}

