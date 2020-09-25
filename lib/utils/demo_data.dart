import 'package:shoro/model/models.dart';
import 'package:shoro/service/SQLProvider.dart';

class DemoData{
  DemoData._();

  static final DemoData demoData = DemoData._();

  List<Agent>demoAgents(){
    return [
      Agent(guid: "1",name: "Чынара"),
      Agent(guid: "2",name: "Кубанычбек"),
    ];
  }

  List<Price>demoPrices(){
    return [
      Price(guid: "1",name: "Оптовая"),
      Price(guid: "2",name: "Розничная"),
      Price(guid: "3",name: "Закупочная"),
    ];
  }
  List<Product>demoProducts(){
    return [
      Product(guid: "1",name: "Максым шоро (лт.)"),
      Product(guid: "2",name: "Жарма шоро (лт.)"),
      Product(guid: "3",name: "Чалап шоро (лт.)"),
      Product(guid: "4",name: "Кега (шт.)"),
      Product(guid: "5",name: "Стаканы большие (шт)"),
      Product(guid: "6",name: "Стаканы маленкие (шт)"),
    ];
}
  List<PriceList>demoPriceLists(){
    return [
      PriceList(
        price: 75.0,
        priceName: "Оптовая",
        priceQuid: "1",
        productName: "Максым шоро (лт.)",
        productGuid: "1",
      ),
      PriceList(
        price: 65.0,
        priceName: "Розничная",
        priceQuid: "2",
        productName: "Максым шоро (лт.)",
        productGuid: "1",
      ),
      PriceList(
        price: 55.0,
        priceName: "Закупочная",
        priceQuid: "3",
        productName: "Максым шоро (лт.)",
        productGuid: "1",
      ),
      PriceList(
        price: 70.0,
        priceName: "Оптовая",
        priceQuid: "1",
        productName: "Жарма шоро (лт.)",
        productGuid: "2",
      ),
      PriceList(
        price: 60.0,
        priceName: "Розничная",
        priceQuid: "2",
        productName: "Жарма шоро (лт.)",
        productGuid: "2",
      ),
      PriceList(
        price: 50.0,
        priceName: "Закупочная",
        priceQuid: "3",
        productName: "Жарма шоро (лт.))",
        productGuid: "2",
      ),
      PriceList(
        price: 85.0,
        priceName: "Оптовая",
        priceQuid: "1",
        productName: "Чалап шоро (лт.)",
        productGuid: "3",
      ),
      PriceList(
        price: 95.0,
        priceName: "Розничная",
        priceQuid: "2",
        productName: "Чалап шоро (лт.)",
        productGuid: "3",
      ),
      PriceList(
        price: 73.0,
        priceName: "Закупочная",
        priceQuid: "3",
        productName: "Чалап шоро (лт.)",
        productGuid: "3",
      ),

      PriceList(
        price: 510.0,
        priceName: "Оптовая",
        priceQuid: "1",
        productName: "Кега (шт.)",
        productGuid: "4",
      ),
      PriceList(
        price: 625.0,
        priceName: "Розничная",
        priceQuid: "2",
        productName: "Кега (шт.)",
        productGuid: "4",
      ),
      PriceList(
        price: 15.0,
        priceName: "Закупочная",
        priceQuid: "3",
        productName: "Кега (шт.)",
        productGuid: "4",
      ),

      PriceList(
        price: 510.0,
        priceName: "Оптовая",
        priceQuid: "1",
        productName: "Стаканы большие (шт)",
        productGuid: "5",
      ),
      PriceList(
        price: 625.0,
        priceName: "Розничная",
        priceQuid: "2",
        productName: "Стаканы большие (шт)",
        productGuid: "5",
      ),
      PriceList(
        price: 15.0,
        priceName: "Закупочная",
        priceQuid: "3",
        productName: "Стаканы большие (шт)",
        productGuid: "5",
      ),

    ];
  }

 insertDemoData()async{
    await deleteDemoData();
    final agents = demoAgents();
    await SQLProvider.db.insertAgent(agents);
    final prices = demoPrices();
    await SQLProvider.db.insertPrice(prices);
    final priceLists = demoPriceLists();
    await SQLProvider.db.insertPriceList(priceLists);
    final products = demoProducts();
    await SQLProvider.db.insertProduct(products);
  }

 deleteDemoData() async {
    await SQLProvider.db.deleteDB();
  }

}