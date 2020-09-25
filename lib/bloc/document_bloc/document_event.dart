import 'package:shoro/model/agent.dart';
import 'package:shoro/model/price.dart';
import 'package:shoro/model/product_list.dart';
import 'package:shoro/utils/CONSTANTS.dart';

abstract class DocumentEvent{}

class DocumentOpeningEvent extends DocumentEvent{
  final DocumentType documentType;
  DocumentOpeningEvent({this.documentType});
}

class DocumentSavingEvent extends DocumentEvent{
  final bool isNew;
  final String documentGuid;
  final DocumentType documentType;
  final List<ProductList> productLists;
  final Agent agent;
  final Price price;

  DocumentSavingEvent({this.documentGuid, this.documentType, this.productLists,
      this.agent, this.price,this.isNew=true});
}

class DocumentSendingEvent extends DocumentEvent{
  final bool isNew;
  final String documentGuid;
  final DocumentType documentType;
  final List<ProductList> productLists;
  final Agent agent;
  final Price price;

  DocumentSendingEvent({this.documentGuid, this.documentType, this.productLists,
    this.agent,  this.price,this.isNew=true});
}

class DocumentReOpeningEvent extends DocumentEvent{
  final String guid;

  DocumentReOpeningEvent({this.guid});

}