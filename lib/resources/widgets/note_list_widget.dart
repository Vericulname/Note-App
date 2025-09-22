import 'package:flutter/material.dart';
import 'package:flutter_app/app/events/note_delete_event.dart';
import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/config/decoders.dart';
import 'package:flutter_app/config/enum.dart';

import 'package:flutter_app/config/keys.dart';
import 'package:flutter_app/resources/pages/notecreate_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/list_style_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

//TODO: doc 1 đằng code 1 lẻo ??? ưtf

class NoteList extends StatefulWidget {
  NoteList({super.key});
  static String state = "noteList";

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends NyState<NoteList> {
  List<Note> _notes = [];
  List<Note> _filterednotes = [];
  List<Note> _deleteNotes = [];

  bool deleteMode = false;
  bool isGribView = false;

  _NoteListState() {
    stateName = NoteList.state;
  }

  //vi 1 ly do nao day stateUpdate chay trc stateAction
  @override
  Map<String, Function> get stateActions => {
        "delete_note": () {
          if (_deleteNotes.isNotEmpty) {
            event<NoteDeleteEvent>(data: {"notes": _deleteNotes});
            _deleteNotes = [];
            setState(() {});
          }
          deleteMode = false;
        },
      };

  @override
  stateUpdated(data) async {
    _notes = await NyStorage.readCollection<Note>(Keys.note,
        modelDecoders: modelDecoders);

    //dai qua
    switch (data["flag"]) {
      case NoteListFlag.deleteMode:
        deleteMode = !deleteMode;
        break;
      case NoteListFlag.ChangeToGribView:
        isGribView = true;
        break;
      case NoteListFlag.ChangeToListView:
        isGribView = false;
        break;

      case NoteListFlag.SearchNote:
        _filterednotes = _notes
            .where((e) =>
                e.title!.toLowerCase().contains(data["title"].toLowerCase()))
            .toList();
      case NoteListFlag.updateState:
        _filterednotes = List.from(_notes);
        break;
      default:
        print("NoteListFlag = null hoặc có gì đó lỗi r");
        break;
    }

    setState(() {});
  }

  @override
  get init => () async {
        _notes = await NyStorage.readCollection<Note>(Keys.note,
            modelDecoders: modelDecoders);

        setState(() {
          _filterednotes = List.from(_notes);
        });
      };

  @override
  Widget view(BuildContext context) {
    return isGribView
        ? NyListView.grid(
            shrinkWrap: true,
            crossAxisCount: 2,
            empty: _createListEmptyWiget(),
            child: (
              context,
              dynamic data,
            ) {
              Note note = data['note'];
              return Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.withOpacity(0.2)),
                child: _createNoteListTile(note),
              );
            },
            data: () {
              return _filterednotes.map((e) {
                return {"note": e};
              }).toList();
            },
          )
        : NyListView.separated(
            shrinkWrap: true,
            empty: _createListEmptyWiget(),
            child: (
              context,
              data,
            ) {
              Note note = data['note'];
              return _createNoteListTile(note);
            },
            data: () {
              return _filterednotes.map((e) {
                return {"note": e};
              }).toList();
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black,
              );
            },
          );
  }

  ListTile _createNoteListTile(Note note) {
    return ListTile(
      onTap: () => routeTo(NotecreatePage.path, data: note),
      subtitle: Text(note.dateCreate.toDateStringUK()!).bodyMedium(),
      title: Text(note.title!),
      trailing: deleteMode
          ? Checkbox(
              value: _deleteNotes.contains(note),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    _deleteNotes.add(note);
                  } else {
                    _deleteNotes.removeWhere((val) => val == note);
                  }
                });
              },
            )
          : null,
    );
  }
}

class _createListEmptyWiget extends StatelessWidget {
  const _createListEmptyWiget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Danh sách trống, hãy bấm + để thêm ghi chú mới"));
  }
}
