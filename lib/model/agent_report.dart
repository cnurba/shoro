import 'package:shoro/model/agent.dart';
import 'package:shoro/model/documentsModel.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/utils/CONSTANTS.dart';

class AgentReport{
  Agent agent;
  double amountReceived;
  double amountRefund;
  double amountLeftover;
  String comment;

  AgentReport({this.agent, this.amountReceived, this.amountRefund,
      this.amountLeftover, this.comment});

static Future<List<AgentReport>> getAgentReportData() async {


  final db = await SQLProvider.db.database;

  List<AgentReport> agentReportForWidget = [];

  var res_1 = await db.rawQuery('''
  Select
  left.agentName,
  left.agentQuid,
  sum(left.sum) as sum
  from
  Leftovers as left  
  Group by
  left.agentName,
  left.agentQuid
 ''');
  var res_1List = res_1.toList();

  for(var item in res_1List){
    AgentReport _agentRep = new AgentReport(
      agent: Agent(name: item['agentName'],guid: item['agentQuid']),
      amountLeftover: 0,
      amountReceived: 0,
      amountRefund: 0,
    );

    agentReportForWidget.add(_agentRep) ;

  }



  var res = await db.rawQuery('''
  Select
  left.agentName,
  left.agentQuid,
  left.documentType,
  sum(left.sum) as sum
  from
  Leftovers as left  
  Group by
  left.agentName,
  left.agentQuid,
  left.documentType
  ''');

  var resList = res.toList();
  List<AgentReport> agentReports = [];

  for (var item in resList){
    DocumentType documentType = DocumentsModel.getDocumentType(item['documentType']);
    double amountReceived =  (documentType==DocumentType.Distribution)?item['sum']:0;
    double amountRefund = (documentType==DocumentType.BalanceRemoval)?item['sum']:0;

    AgentReport agentReport = new AgentReport(
      agent: Agent(name: item['agentName'],guid: item['agentQuid']),
      amountReceived:amountReceived,
      amountRefund:amountRefund,
      amountLeftover:amountReceived- amountRefund,
      comment: "",
     );

    agentReports.add(agentReport);
  }

  for(var item in agentReportForWidget){
    Iterable iterable = agentReports.where((element) => item.agent.guid==element.agent.guid);

    double get = 0 ;
    double give = 0 ;

   final tirii =  iterable.toList();

    for (var itr in tirii){
      get = get + itr.amountRefund;
      give = give + itr.amountReceived;
    }

    item.amountRefund = get;
    item.amountReceived = give;
    item.amountLeftover = give+get;

  }

  return agentReportForWidget;

}

}