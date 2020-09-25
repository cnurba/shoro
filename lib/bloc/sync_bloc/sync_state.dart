abstract class SyncState{}

class LoadingSyncState extends SyncState{}

class SuccessSyncState extends SyncState{
  String resultText;

  SuccessSyncState(this.resultText);
}

class ErrorSyncState extends SyncState{
  String errorText;
  ErrorSyncState(this.errorText);
}