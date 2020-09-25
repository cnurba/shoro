import 'package:flutter/material.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class MainMenuModel{
  Icon icon;
  String name;
  DocumentType documentType;

  MainMenuModel(this.icon, this.name, this.documentType);

 static List<MainMenuModel> getMainMenuModels(){
    return [
      MainMenuModel(Icon(Icons.add,size: 40.0,color: Colors.brown,), "Приходная Накладная", DocumentType.IncomeOrder),
      MainMenuModel(Icon(Icons.add,size: 40.0,color: Colors.purpleAccent,), "Возвратная накладная", DocumentType.ReturnOrder),
      MainMenuModel(Icon(Icons.add,size: 40.0,color: Colors.amberAccent,), "Раздача", DocumentType.Distribution),
      MainMenuModel(Icon(Icons.add,size: 40.0,color: Colors.green,), "Снятие остатка", DocumentType.BalanceRemoval),
    ];
  }
}