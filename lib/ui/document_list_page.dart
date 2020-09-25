import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/blocs.dart';
import 'package:shoro/model/models.dart';
import 'package:shoro/ui/distr_document_page.dart';
import 'package:shoro/ui/document_page.dart';
import 'package:shoro/ui/home_page.dart';
import 'package:shoro/ui/removal_document_page.dart';
import 'package:shoro/ui/return_document_page.dart';
import 'package:shoro/utils/CONSTANTS.dart';
import 'package:shoro/utils/helper.dart';


class DocumentListPage extends StatefulWidget {
   @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {

  bool isOpened =false;

  @override
  void initState() {
    super.initState();

  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DocumentBloc,DocumentState>(
        builder: (context, state) {
          if(state is DocumentListSuccessOpeningState){
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  actions: <Widget>[
                    PopupMenuButton(
                      onSelected: (value){
                        onSelectedMenu (value,context);
                      },
                      icon: Icon(Icons.add),

                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text("Приходная накладная"),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text("Возвратная накладная"),
                            value: 2,
                          ),
                          PopupMenuItem(
                            child: Text("Раздача"),
                            value: 3,
                          ),
                          PopupMenuItem(
                            child: Text("Снятие остатка"),
                            value: 4,
                          )

                        ];

                      },)
                  ],
                  backgroundColor: CONSTANTS.appBarColor,
                  title: Text(
                    "Документы",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index){
                      return ListTile(
                        onLongPress:(){
                          onTapItem(context,state.documentListModel.elementAt(index));
                        },
                        title: Text('${state.documentListModel.elementAt(index).type} № ${state.documentListModel.elementAt(index).guid}'),
                        subtitle: Text('Сумма документа: ${Helper.formatNumberCurrency(state.documentListModel.elementAt(index).sum)}'),
                        leading: (state.documentListModel.elementAt(index).sentToServer)?Icon(Icons.check_box):Icon(Icons.check_box_outline_blank),
                      );
                    },
                    childCount:state.documentListModel.length,
                  ),
                ),

              ],
            );
          }else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.chevron_left,color: Colors.cyanAccent,size: 40,),
                 InkWell(
                     onTap:(){
                       Navigator.push(context, MaterialPageRoute(
                       builder: (context) => HomePage(),
                     ));
                  },
                     child: Center(child: CircularProgressIndicator(
                       backgroundColor: Colors.greenAccent,
                       strokeWidth: 20,
                     ))),
              ],
            );
          }

        },

      ),
    );
  }

  onTapItem ( BuildContext context,DocumentListModel model){

    final documentType = DocumentsModel.getDocumentType(model.type);

    if(documentType ==DocumentType.IncomeOrder){
       Navigator.of(context).push(MaterialPageRoute(
         builder: (context) => DocumentPage(isNew: false,documentGuid: model.guid,),
       ));
       BlocProvider.of<DocumentBloc>(context).add(DocumentReOpeningEvent(guid: model.guid));

    }else if(documentType ==DocumentType.Distribution){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DistrDocumentPage(
          isNew: false,
          documentGuid: model.guid,

        ),
      ));
      BlocProvider.of<DocumentBloc>(context).add(DocumentReOpeningEvent(guid: model.guid));

    }else if(documentType ==DocumentType.BalanceRemoval){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RemovalDocumentPage(
          isNew: false,
          documentGuid: model.guid,
        ),
      ));
      BlocProvider.of<DocumentBloc>(context).add(DocumentReOpeningEvent(guid: model.guid));

    }else if(documentType ==DocumentType.ReturnOrder){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReturnDocumentPage(
          isNew: false,
          documentGuid: model.guid,
        ),
      ));
      BlocProvider.of<DocumentBloc>(context).add(DocumentReOpeningEvent(guid: model.guid));

    }



  }


  onSelectedMenu(int choice,BuildContext context){
    DocumentType _documentType;
    if(choice ==1){
      _documentType = DocumentType.IncomeOrder;
    }else if(choice==2){
      _documentType = DocumentType.ReturnOrder;
    }else if (choice==3){
      _documentType = DocumentType.Distribution;
    }else {
      _documentType = DocumentType.BalanceRemoval;
    }

    BlocProvider.of<DocumentBloc>(context).add(DocumentOpeningEvent(
      documentType: _documentType,
    ));

  }

}
