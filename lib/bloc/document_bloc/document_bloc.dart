import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/service/helper_1c.dart';
import 'package:shoro/service/preferense_helper.dart';
import 'package:shoro/utils/CONSTANTS.dart';
import 'package:shoro/model/models.dart';

class DocumentBloc extends Bloc<DocumentEvent,DocumentState>{
  DocumentBloc(DocumentState initialState) : super(initialState);

  @override
  Stream<DocumentState> mapEventToState(DocumentEvent event) async*{
    if(event is DocumentOpeningEvent){
      if(event.documentType == DocumentType.IncomeOrder){
        yield* _mapIncomeOrderOpeningEventToState();
      }else if(event.documentType == DocumentType.ReturnOrder) {
        yield* _mapReturnOrderOpeningEventToState();
      }else if(event.documentType == DocumentType.Distribution) {
        yield* _mapDistributionOpeningEventToState();
      }else if(event.documentType == DocumentType.BalanceRemoval) {
        yield* _mapBalanceRemovalOpeningEventToState();
      }else{
        yield* _mapDocumentListOpeningEventToState();
      }
    }else if (event is DocumentSavingEvent){
      yield* _mapDocumentSavingEventToState(event);
    }else if (event is DocumentReOpeningEvent){
      yield* _mapDocumentReOpeningEventToState(event);
    }
     else{
      yield* _mapDocumentSendingEventToState(event);
    }
  }

}

Stream<DocumentState> _mapIncomeOrderOpeningEventToState() async*{
    final List<DropdownMenuItem<Price>> _dropMenuPrices = await getDropMenuPrices();
    final currentPrice = (_dropMenuPrices.length > 0)
        ? _dropMenuPrices[0].value
        : null;

    List<ProductList> productList = [];

    if (currentPrice == null) {
      final products = await SQLProvider.db.getAllProducts();
      productList = await ProductList.getProductListByProduct(products);
    } else {
      productList = await ProductList.getProductListByPrice(
          currentPrice);
    }

    final productsForDocument =  await ManagerLeftovers.getProductListWithLeftOvers(
        productList);

    yield DocumentSSuccessOpeningState(
      prices: _dropMenuPrices,
      currentPrice: currentPrice,
      productList: productsForDocument,
    );


  }

Stream<DocumentState> _mapReturnOrderOpeningEventToState() async*{

 final productsForDocument =  await ManagerLeftovers.getProductListForReturnOrder();

  yield DocumentReturnOrderOpeningState(
    productList: productsForDocument,
  );

}

Stream<DocumentState> _mapDistributionOpeningEventToState() async*{

  yield DocumentLoadingState();

  final List<DropdownMenuItem<Price>> _dropMenuPrices = await getDropMenuPrices();

  final currentPrice = (_dropMenuPrices.length > 0)
      ? _dropMenuPrices[0].value
      : null;

  final List<DropdownMenuItem<Agent>> _dropMenuAgents = await getDropMenuAgents();
  final currentAgent = (_dropMenuAgents.length > 0)
      ? _dropMenuAgents[0].value
      : null;

  List<ProductList> productList = [];

  if(currentAgent!=null) {
    productList = await ManagerLeftovers.getProductListWithLeftOversByPrice(currentPrice);
  }

 yield DocumentDstrSSuccessOpeningState(
    agents:_dropMenuAgents ,
    currentAgent: currentAgent,
    prices: _dropMenuPrices,
    currentPrice: currentPrice,
    productList: productList,
  );

}

Stream<DocumentState> _mapBalanceRemovalOpeningEventToState() async*{

  final List<DropdownMenuItem<Agent>> _dropMenuAgents = await getDropMenuAgentsFromLeftOver();

  final currentAgent = (_dropMenuAgents.length > 0)
      ? _dropMenuAgents[0].value
      : null;
  List<ProductList> productList = [];

  if(currentAgent!=null) {
    productList = await Leftovers.getProductListWithLeftOvers(currentAgent);
  }

  yield DocumentBalanceRemovalSuccessOpeningState(
    agents:_dropMenuAgents ,
    currentAgent: currentAgent,
    productList: productList,
  );

}

Stream<DocumentState> _mapDocumentListOpeningEventToState()async*{
  final documentsListModels = await DocumentListModel.getDocumentListModels();
  yield DocumentListSuccessOpeningState(
      documentListModel: documentsListModels);
}

Stream<DocumentState> _mapDocumentSendingEventToState(DocumentSendingEvent sendEvent)async*{
 String documentGuid ='';
  if(sendEvent.documentGuid ==null){
    documentGuid = UniqueKey().toString();
  }else {
    documentGuid = sendEvent.documentGuid;
  }

  if(!sendEvent.isNew){
   await SQLProvider.db.deleteDocumentsByGuid(documentGuid);
   await SQLProvider.db.deleteManagerLeftOversByGuid(documentGuid);
  }

  final listDocumentsModel = DocumentsModel.prepareDocumentList(
        documentGuid,
        sendEvent.documentType,
        sendEvent.agent,
        sendEvent.price,
        sendEvent.productLists);
    SQLProvider.db.insertDocumentsModel(listDocumentsModel);
     //Write to register balances ManagerLeftovers
    final managerLeftovers = ManagerLeftovers.prepareManagerLeftoversList(
        documentGuid,
        sendEvent.documentType,
        sendEvent.productLists);
    SQLProvider.db.insertManagerLeftovers(managerLeftovers);
    //Write to register balances Agent leftovers
    if(sendEvent.documentType==DocumentType.BalanceRemoval || sendEvent.documentType==DocumentType.Distribution) {
      if(!sendEvent.isNew){
        await SQLProvider.db.deleteLeftOversByGuid(documentGuid);
       }

      final agentLeftovers = Leftovers.prepareAgentLeftoversList(
          documentGuid,
          sendEvent.documentType,
          sendEvent.agent,
          sendEvent.productLists);
      SQLProvider.db.insertLeftovers(agentLeftovers);
    }

    //send to server current document
    final user = await getUser();
    final template = "synchdoc";

    if(user!=null) {
      Helper1C helper1C = new Helper1C(user, template);
      final data = await helper1C.postAllDocumentsToServer(user);

      if (!data.error) {
        await SQLProvider.db.updateDocuments(data.data);
      }
    }

 }

Stream<DocumentState> _mapDocumentSavingEventToState(DocumentSavingEvent saveEvent)async*{
  String documentGuid ='';
  if(saveEvent.documentGuid ==null){
    documentGuid = UniqueKey().toString();
  }else {
    documentGuid = saveEvent.documentGuid;
  }

  if(!saveEvent.isNew){
    await SQLProvider.db.deleteDocumentsByGuid(documentGuid);
    await SQLProvider.db.deleteManagerLeftOversByGuid(documentGuid);
  }

    final listDocumentsModel = DocumentsModel.prepareDocumentList(
        documentGuid,
        saveEvent.documentType,
        saveEvent.agent,
        saveEvent.price,
        saveEvent.productLists);
    await SQLProvider.db.insertDocumentsModel(listDocumentsModel);
    //Write to register balances ManagerLeftovers
    final managerLeftovers = ManagerLeftovers.prepareManagerLeftoversList(
        documentGuid,
        saveEvent.documentType,
        saveEvent.productLists);
      SQLProvider.db.insertManagerLeftovers(managerLeftovers);
    //Write to register balances Agent leftovers
    if(saveEvent.documentType==DocumentType.BalanceRemoval || saveEvent.documentType==DocumentType.Distribution) {
      if(!saveEvent.isNew){
        await SQLProvider.db.deleteLeftOversByGuid(documentGuid);
      }
      final agentLeftovers = Leftovers.prepareAgentLeftoversList(
          documentGuid,
          saveEvent.documentType,
          saveEvent.agent,
          saveEvent.productLists);
      SQLProvider.db.insertLeftovers(agentLeftovers);
    }
 }

Future<List<DropdownMenuItem<Agent>>> getDropMenuAgents()async {
  List<Agent> agents = await SQLProvider.db.getAllAgents();
  List<DropdownMenuItem<Agent>> _dropMenuAgents= [];
  for(Agent agent in agents){
    _dropMenuAgents.add(DropdownMenuItem(
      child: Container(
          width: 250,
          child: Text(agent.name)),
      value: agent,
    ));
  }
  return _dropMenuAgents;
}

Future<List<DropdownMenuItem<Agent>>> getDropMenuAgentsFromLeftOver()async {
  List<Agent> agents = await SQLProvider.db.getAllAgentsFromLeftovers();
  List<DropdownMenuItem<Agent>> _dropMenuAgents= [];
  for(Agent agent in agents){
    _dropMenuAgents.add(DropdownMenuItem(
      child: Container(
          width: 250,
          child: Text(agent.name)),
      value: agent,
    ));
  }
  return _dropMenuAgents;
}

Future<List<DropdownMenuItem<Price>>> getDropMenuPrices()async {
    List<Price> prices = await SQLProvider.db.getAllPrices();
    List<DropdownMenuItem<Price>> _dropMenuPrices= [];
    for(Price price in prices){
      _dropMenuPrices.add(DropdownMenuItem(
        child: Text(price.name),
        value: price,
      ));
    }
    return _dropMenuPrices;
  }

Future<User> getUser () async{
  final hasKey = await PreferenceHelper.containsKey("User");
  User user = User();
  if(hasKey){
    final jsonString =  await PreferenceHelper.read("User");
    user = User.FromJson(jsonString);
  }

  return user;
}

Stream<DocumentState>_mapDocumentReOpeningEventToState(DocumentReOpeningEvent reOpen) async*{

  final documentModelList = await SQLProvider.db.getDocumentByGuid(reOpen.guid);

  if (documentModelList.length != 0){
    final documentType = DocumentsModel.getDocumentType(documentModelList[0].type);
    final agent = Agent(name: documentModelList[0].agentName,guid: documentModelList[0].agentGuid);
    final priceType = Price(guid: documentModelList[0].priceGuid,name: documentModelList[0].priceName);

    List<ProductList> productList = [];

    for(final item in documentModelList){
      var product = ProductList(
        product: Product(name:item.productName,guid: item.productQuid ),
        priceType: priceType,
        price: (item.price==null)?0:item.price,
        count: item.count,
        sum: item.sum,
        leftover: 0,
        comment: "Корректировка документа",
      );
      productList.add(product);
    }

    final List<DropdownMenuItem<Price>> _dropMenuPrices = await getDropMenuPrices();

    final List<DropdownMenuItem<Agent>> _dropMenuAgents = await getDropMenuAgents();

    if(documentType ==DocumentType.IncomeOrder){
      final dropPrice = _dropMenuPrices.firstWhere((element) => element.value.guid == priceType.guid,orElse: null);
      yield DocumentSSuccessOpeningState(
        currentPrice:(dropPrice==null)?null:dropPrice.value,
        productList: productList,
        prices: _dropMenuPrices,
      );
    }else if(documentType ==DocumentType.Distribution){
      final dropPrice = _dropMenuPrices.firstWhere((element) => element.value.guid == priceType.guid,orElse: null);
      final dropAgent = _dropMenuAgents.firstWhere((element) => element.value.guid==agent.guid,orElse: null);

      List<ProductList> productListLeftovers =[];

      if(dropPrice!=null) {
        productListLeftovers =
        await ManagerLeftovers.getProductListWithLeftOversByPrice(
            dropPrice.value);
      }

      for (var item in productList){
        if(productListLeftovers.length>0) {
          final prod = productListLeftovers.firstWhere((element) =>
          element.product.guid == item.product.guid, orElse: null);
          if(prod!=null){
            item.leftover = prod.leftover + item.count;
            item.comment = "Общий остаток ${item.leftover}, Остаток в документе ${item.count}";
          }else{
            item.leftover = item.count;
            item.comment = "Остаток в документе ${item.count}";
          }
        } else{
          item.leftover = item.count;
          item.comment = "Остаток в документе ${item.count}";
        }
      }

     yield DocumentDstrSSuccessOpeningState(
        prices: _dropMenuPrices,
        currentPrice: (dropPrice==null)?null:dropPrice.value,
        productList: productList,
        currentAgent: (dropAgent==null)?null:dropAgent.value,
        agents: _dropMenuAgents,
      );

    }else if(documentType ==DocumentType.BalanceRemoval){
      final dropAgent = _dropMenuAgents.firstWhere((element) => element.value.guid==agent.guid,orElse: null);
      List<ProductList> productListLeftovers = [];
      if(dropAgent!=null) {
        productListLeftovers = await Leftovers.getProductListWithLeftOvers(dropAgent.value);
      }
      for (var item in productList){
        if(productListLeftovers.length>0) {
          final prod = productListLeftovers.firstWhere((element) =>
          element.product.guid == item.product.guid, orElse: null);

          if (prod != null) {
            item.leftover = prod.leftover + item.count;
            item.comment =
            "Общий остаток ${item.leftover}, Остаток в документе ${item.count}";
          } else {
            item.leftover = item.count;
            item.comment = "Остаток в документе ${item.count}";
          }
        }else{
          item.leftover = item.count;
          item.comment = "Остаток в документе ${item.count}";
        }
      }
      yield DocumentBalanceRemovalSuccessOpeningState(
        agents: _dropMenuAgents,
        currentAgent: (dropAgent==null)?null:dropAgent.value,
        productList: productList,
      );
    }else if(documentType ==DocumentType.ReturnOrder){
      final productsForDocument =  await ManagerLeftovers.getProductListForReturnOrder();
      for (var item in productList){
        if(productsForDocument.length>0) {
          final prod = productsForDocument.firstWhere((element) =>
          element.product.guid == item.product.guid, orElse: null);

          if (prod != null) {
            item.leftover = prod.leftover + item.count;
            item.comment =
            "Общий остаток ${item.leftover}, Остаток в документе ${item.count}";
          } else {
            item.leftover = item.count;
            item.comment = "Остаток в документе ${item.count}";
          }
        }else{
          item.leftover = item.count;
          item.comment = "Остаток в документе ${item.count}";
        }
      }
      yield DocumentReturnOrderOpeningState(
        productList: productList,
      );
    }
  }

}