import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/config/decoders.dart';
import 'package:flutter_app/config/enum.dart';
import 'package:flutter_app/config/keys.dart';
import 'package:flutter_app/resources/widgets/note_list_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NoteModifyEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    Note note = event["note"];

    await NyStorage.updateCollectionWhere<Note>(
        (value) {
          return note.dateCreate?.millisecondsSinceEpoch ==
              value.dateCreate?.millisecondsSinceEpoch;
        },
        key: Keys.note,
        update: (value) {
          value.content = note.content;
          value.title = note.title;
          value.dateUpdate = note.dateUpdate;
          return value;
        });

    updateState<NoteList>(NoteList.state,
        data: {"flag": NoteListFlag.updateState});
  }
}
