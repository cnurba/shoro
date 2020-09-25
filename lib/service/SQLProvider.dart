import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shoro/model/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLProvider {
  SQLProvider._();

  static final SQLProvider db = SQLProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "shoro.db");
    return await openDatabase(
      path, version: 1, onCreate: _onCreateDB, onOpen: (db) {},);
  }

  void _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Agent(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      guid TEXT NOT NULL
      )''');

    await db.execute('''
      CREATE TABLE Leftovers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      documentGuid TEXT NOT NULL,
      productName TEXT NOT NULL,
      productGuid TEXT NOT NULL,
      agentName TEXT NOT NULL,
      agentQuid TEXT NOT NULL,
      priceQuid TEXT NOT NULL,
      priceName TEXT NOT NULL,
      documentType TEXT NOT NULL,
      count REAL,
      price REAL,
      sum REAL
      )
      ''');
    await db.execute('''
      CREATE TABLE ManagerLeftovers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      documentGuid TEXT NOT NULL,
      productName TEXT NOT NULL,
      productGuid TEXT NOT NULL,
      documentType TEXT NOT NULL,
      priceGuid TEXT NOT NULL,
      priceName TEXT NOT NULL,
      count REAL,
      price REAL,
      sum REAL
     )
      ''');
    await db.execute('''
      CREATE TABLE Price(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      guid TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE PriceList(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productName TEXT NOT NULL,
      productGuid TEXT NOT NULL,
      priceName TEXT NOT NULL,
      priceQuid TEXT NOT NULL,
      price REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE Product(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      guid TEXT NOT NULL
         )
    ''');
    await db.execute('''
      CREATE TABLE Documents(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      guid Text not null,
      agentName TEXT NOT NULL,
      agentGuid TEXT NOT NULL,
      priceName TEXT NOT NULL,
      priceGuid TEXT NOT NULL,
      productName TEXT NOT NULL,
      productQuid TEXT NOT NULL,
      type TEXT NOT NULL,
      count REAL,
      price REAL,
      sum REAL,
      sentToServer BIT
     )
    ''');
  }

  void deleteDB() async {
    final db = await database;
    await db.delete("Agent");
    await db.delete("Leftovers");
    await db.delete("ManagerLeftovers");
    await db.delete("Price");
    await db.delete("PriceList");
    await db.delete("Product");
    await db.delete("Documents");
  }

  Future<void> deleteDataBase() async {
    final db = await database;
    await db.delete("Agent");
    await db.delete("Leftovers");
    await db.delete("ManagerLeftovers");
    await db.delete("Price");
    await db.delete("PriceList");
    await db.delete("Product");
    await db.delete("Documents");
  }

  void insertAgent(List<Agent> agents) async {
    final db = await database;
    for (var item in agents) {
      var res = await db.insert("Agent", item.toMap());
    }
  }

  String insertAgents(Map<String, dynamic> jsonData) {
    List<Agent> agents = [];
    for (var item in jsonData["Agent"]) {
      Agent agent = Agent.FromJson(item);
      agents.add(agent);
    }
    insertAgent(agents);
    return "Агенты: загружены...";
  }

  void insertLeftovers(List<Leftovers> leftovers) async {
    final db = await database;
    for (var item in leftovers) {
      var res = await db.insert("Leftovers", item.toMap());
    }
  }

  void insertManagerLeftovers(List<ManagerLeftovers> leftovers) async {
    final db = await database;
    for (var item in leftovers) {
      var res = await db.insert("ManagerLeftovers", item.toMap());
    }
  }

  void insertPrice(List<Price> prices) async {
    final db = await database;
    for (var item in prices) {
      var res = await db.insert("Price", item.toMap());
    }
  }

  String insertPrices(Map<String, dynamic> jsonData) {
    List<Price> prices = [];
    for (var item in jsonData["Price"]) {
      Price price = Price.FromJson(item);
      prices.add(price);
    }
    insertPrice(prices);
    return "Цены: загружены...";
  }

  void insertPriceList(List<PriceList> priceLists) async {
    final db = await database;
    for (var item in priceLists) {
      var res = await db.insert("PriceList", item.toMap());
    }
  }

  String insertPriceLists(Map<String, dynamic> jsonData) {
    List<PriceList> priceLists = [];
    for (var item in jsonData["PriceList"]) {
      PriceList priceList = PriceList.FromJson(item);
      priceLists.add(priceList);
    }
    insertPriceList(priceLists);
    return "Типы цен: загружены...";
  }

  void insertProduct(List<Product> products) async {
    final db = await database;
    for (var item in products) {
      var res = await db.insert("Product", item.toMap());
    }
  }

  String insertProducts(Map<String, dynamic> jsonData) {
    List<Product> products = [];
    for (var item in jsonData["Product"]) {
      Product product = Product.FromJson(item);
      products.add(product);
    }
    insertProduct(products);
    return "Товары: загружены...";
  }

  Future<bool> insertDocumentsModel(List<DocumentsModel> documents) async {
    final db = await database;
    for (var item in documents) {
      var res = await db.insert("Documents", item.toMap()).catchError((
          onError) {
        return false;
      });
    }
    return true;
  }

  updateDocuments (List<String> documents)async{
    final db = await database;
    for(var item in documents){
      await db.rawUpdate('''
         UPDATE 
         Documents
         SET 
         sentToServer =?
         Where
         guid =?
       ''',[1,item]);
    }

  }

 Future<List<Agent>> getAllAgentsFromLeftovers() async {
    final db = await database;
    var res = await db.rawQuery('''
        SELECT  
        agent.agentName,
        agent.agentQuid
        FROM Leftovers as agent
        Group by 
        agent.agentName,
        agent.agentQuid
        ''');
    var resList = res.toList();
    List<Agent> list = [];
    for (var item in resList) {
      Agent agent = new Agent(guid: item['agentQuid'],name: item['agentName']);
      list.add(agent);
    }
    return list;
  }

 Future<List<Agent>> getAllAgents() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Agent');
    var resList = res.toList();
    List<Agent> list = [];
    for (var item in resList) {
      Agent agent = new Agent.FromJson(item);
      list.add(agent);
    }
    return list;
  }

  Future<List<Price>> getAllPrices() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Price');
    var resList = res.toList();
    List<Price> list = [];
    for (var item in resList) {
      Price price = new Price.FromJson(item);
      list.add(price);
    }
    return list;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    var res = await db.rawQuery('''
     Select *
     from
     Product
   ''');
    var resList = res.toList();
    List<Product> products = [];
    for (var item in resList) {
      Product product = Product.FromJson(item);
      products.add(product);
    }

    return products;
  }


  Future<Map<String,dynamic>> getAllDocumentsAsJson() async {
    final db = await database;
    var res = await db.rawQuery('''
     Select *
     from
     Documents
     Where
     documents.sentToServer =?
   ''',["${0}"]);

    Map<String,dynamic> data = {
      "User":'',
      "data":res,
      "code":'',
    }  ;

    return data;
  }

Future<List<DocumentsModel>> getDocumentByGuid(String guid) async {
    List<DocumentsModel> documentsModelList =[];

    final db = await database;
    var res = await db.rawQuery('''
     Select *
     from
     Documents
     Where
     documents.guid = ?
   ''',["${guid}"]);

    var resList =  res.toList();
    for(var item in resList){
      var document= DocumentsModel(
        guid: item['guid'],
        priceGuid:item['priceGuid'],
        priceName: item['priceName'],
        agentGuid:item['agentGuid'] ,
        agentName:item['agentName'] ,
        id:item['id'] ,
        count: item['count'],
        sum:item['sum'],
        price: item['price'],
        type: item['type'],
        productName: item['productName'],
        productQuid:item['productQuid'],);
      documentsModelList.add(document);
    }
   return  documentsModelList;
  }


  deleteDocumentsByGuid (String guid)async{
    final db = await database;
    await db.rawDelete('''
    DELETE 
    FROM
    Documents
    WHERE
    guid =?
        
    ''',["$guid"]);
  }


  deleteManagerLeftOversByGuid (String guid)async{
    final db = await database;
    await db.rawDelete('''
    DELETE 
    FROM
    ManagerLeftovers
    WHERE
    documentGuid =?
        
    ''',["$guid"]);
  }


  deleteLeftOversByGuid (String guid)async{
    final db = await database;
    await db.rawDelete('''
    DELETE 
    FROM
    Leftovers
    WHERE
    documentGuid =?
        
    ''',["$guid"]);
  }



}
