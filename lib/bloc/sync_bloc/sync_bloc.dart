import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoro/bloc/sync_bloc/sync_event.dart';
import 'package:shoro/bloc/sync_bloc/sync_state.dart';
import 'package:shoro/model/user.dart';
import 'package:shoro/service/SQLProvider.dart';
import 'package:shoro/service/helper_1c.dart';
import 'package:shoro/service/preferense_helper.dart';

class SyncBloc extends Bloc<SyncEvent,SyncState>{
  SyncBloc(SyncState initialState) : super(initialState);

  @override
  Stream<SyncState> mapEventToState(SyncEvent event) async* {
    if(event is RegistrationEvent){
      yield* _mapRegEventToState(event);
    }else if(event is SynchronizationEvent){
      yield* _mapSyncEventToState(event);
    }else if(event is SyncDocumentsEvent){
      yield* _mapSyncDocEventToState(event);
    }
 }


  Stream<SyncState> _mapRegEventToState (RegistrationEvent event)async*{
    User user = event.user;
    String template = event.template;
    if(user==null){
      user = await getUser();
    }
    if(template==null||template==""){
      template = 'reg';
    }

   SQLProvider.db.deleteDB();
   Helper1C helper1C = new Helper1C(user, template);
   final data = await helper1C.postRegistration(user);

   if(data.error){
     yield ErrorSyncState(data.errorText);
   }else{
     yield SuccessSyncState(data.errorText);
   }
}

  Stream<SyncState> _mapSyncEventToState (SynchronizationEvent event)async*{
    User user = event.user;
    String template = event.template;
    if(user==null){
      user = await getUser();
    }
    if(template==null||template==""){
      template = 'synch';
    }

    if(user==null || user.login==""){
      yield ErrorSyncState("Вы не зарегистрированы в системе!!!");
    }

    final res = await SQLProvider.db.deleteDataBase();

    Helper1C helper1C = new Helper1C(user, template);
    final data = await helper1C.synchronization(user);

    if(data.error){
      yield ErrorSyncState(data.errorText);
    }else {
      await SQLProvider.db.updateDocuments(data.data['dataServ']);
      yield SuccessSyncState(data.errorText);
    }
}


Stream<SyncState> _mapSyncDocEventToState (SyncDocumentsEvent event)async*{
    User user = event.user;
    String template = event.template;
    if(user==null){
      user = await getUser();
    }
    if(template==null||template==""){
      template = 'synchdoc';
    }

    if(user==null || user.login==""){
      yield ErrorSyncState("Вы не зарегистрированы в системе!!!");
    }

    Helper1C helper1C = new Helper1C(user, template);
    final data = await helper1C.postAllDocumentsToServer(user);

    if(data.error){
      yield ErrorSyncState(data.errorText);
    }else{
      await SQLProvider.db.updateDocuments(data.data);
      yield SuccessSyncState(data.errorText);
    }

  }

Future<User> getUser () async{
    final hasKey = await PreferenceHelper.containsKey("User");
    User user = User();
    if(hasKey){
      final jsonString =  await PreferenceHelper.read("User");
      user = User.FromJson(jsonString);
    }

    return user;
  }

}

