import '/app/events/note_modify_event.dart';
import '/app/events/note_delete_event.dart';
import '/app/events/note_create_event.dart';
import '/app/events/logout_event.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Events
|--------------------------------------------------------------------------
| Add your "app/events" here.
| Events can be fired using: event<MyEvent>();
|
| Learn more: https://nylo.dev/docs/6.x/events
|-------------------------------------------------------------------------- */

final Map<Type, NyEvent> events = {
  LogoutEvent: LogoutEvent(),

  NoteCreateEvent: NoteCreateEvent(),
  
  NoteDeleteEvent: NoteDeleteEvent(),
  
  NoteModifyEvent: NoteModifyEvent(),
  };
