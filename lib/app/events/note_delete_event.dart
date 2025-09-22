import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/config/decoders.dart';
import 'package:flutter_app/config/enum.dart';
import 'package:flutter_app/config/keys.dart';
import 'package:flutter_app/resources/widgets/note_list_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NoteDeleteEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    List<Note> deleteNotes = event["notes"];

    await NyStorage.deleteFromCollectionWhere<Note>((value) {
      return deleteNotes.any((note) =>
          note.dateCreate?.millisecondsSinceEpoch ==
          value.dateCreate?.millisecondsSinceEpoch);
    }, key: Keys.note);

    updateState<NoteList>(NoteList.state,
        data: {"flag": NoteListFlag.updateState});
  }
}
