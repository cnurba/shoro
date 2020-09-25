import 'package:shoro/model/user.dart';

abstract class SyncEvent {
  final String template;
  final User user;
  SyncEvent(this.user, this.template);
}

class RegistrationEvent extends SyncEvent{
  RegistrationEvent(User user, String template) : super(user, template);

}

class SynchronizationEvent extends SyncEvent{
  SynchronizationEvent(User user, String template) : super(user, template);

}

class SyncDocumentsEvent extends SyncEvent{
  SyncDocumentsEvent(User user, String template) : super(user, template);

}

