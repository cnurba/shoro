import 'package:shoro/utils/CONSTANTS.dart';
import 'package:intl/intl.dart';

class Helper{

  static String getDocumentNameByType(DocumentType documentType){
   if(documentType==DocumentType.IncomeOrder){
      return "Приходная накладная";
    }else if(documentType==DocumentType.Distribution){
      return "Раздача";
    }else if(documentType==DocumentType.BalanceRemoval){
      return "Снятие остатка";
   } else{
     return "Возвратная накладная";
   }
  }



  static String formatNumberCurrency(double value) {
    return NumberFormat.currency(locale: 'ky').format(value);
  }
}