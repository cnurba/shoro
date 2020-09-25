import 'package:flutter/material.dart';
import 'package:shoro/model/models.dart';

abstract class DocumentState{}

class DocumentLoadingState extends DocumentState{}

class DocumentFailedState extends DocumentState{}

class DocumentDstrSSuccessOpeningState extends DocumentState{

 final List<DropdownMenuItem<Price>> prices;
 final Price currentPrice;
 final List<DropdownMenuItem<Agent>> agents;
 final Agent currentAgent;
 final List<ProductList> productList;

 DocumentDstrSSuccessOpeningState({this.productList,
  this.prices, this.currentPrice,
  this.agents, this.currentAgent});

}

class DocumentBalanceRemovalSuccessOpeningState extends DocumentState{
 final List<DropdownMenuItem<Agent>> agents;
 final Agent currentAgent;
 final List<ProductList> productList;

 DocumentBalanceRemovalSuccessOpeningState({this.productList,
 this.agents, this.currentAgent});
}

class DocumentReturnOrderOpeningState extends DocumentState{
 final List<ProductList> productList;
 DocumentReturnOrderOpeningState({this.productList});
}

class DocumentSSuccessOpeningState extends DocumentState{
 final List<DropdownMenuItem<Price>> prices;
 final Price currentPrice;
 final List<ProductList> productList;

 DocumentSSuccessOpeningState({this.productList,
    this.prices, this.currentPrice});

}

class DocumentListSuccessOpeningState extends DocumentState{
 final List<DocumentListModel> documentListModel;
 DocumentListSuccessOpeningState({this.documentListModel});
}