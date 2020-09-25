import 'package:flutter/material.dart';

class CONSTANTS{

  static Color primaryColor = Colors.brown.shade500;
  static Color appBarColor = Colors.brown.shade900;
  static double appBarHeight = 80;

  static const String loggedIn = "Регистрация";
  static const String synchronization = "Получить данные";
  static const String synchDocuments = "Выгрузка документов";
  static const String demo = "Demo";

  static const dropDownIcon = Icons.arrow_forward_ios;

  static const List<String> choices = [synchronization,synchDocuments,demo,loggedIn];
}
enum DocumentType{
  IncomeOrder,
  ReturnOrder,
  Distribution,
  BalanceRemoval,
  DocumentList,
}
