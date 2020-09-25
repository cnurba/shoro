import 'package:flutter/material.dart';
import 'package:shoro/model/models.dart';

class AgentReportPage extends StatefulWidget {
  @override
  _AgentReportPageState createState() => _AgentReportPageState();
}

class _AgentReportPageState extends State<AgentReportPage> {

  Future _future;

  @override
  void initState() {
     super.initState();
     _future = AgentReport.getAgentReportData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Отчет по агентам"),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (context, index) => Divider(height: 3.0,color: Colors.green,),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                          "Агент: ${snapshot.data[index].agent.name}",style: TextStyle(
                            fontSize: 16.0,fontWeight: FontWeight.bold,
                          ),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                Text(snapshot.data[index].amountReceived.toString(),),
                                Text(snapshot.data[index].amountRefund.toString()),
                                Text(snapshot.data[index].amountLeftover.toString()),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                );

          }else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
