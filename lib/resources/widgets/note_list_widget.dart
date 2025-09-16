import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/config/decoders.dart';
import 'package:flutter_app/config/keys.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/list_style_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

//TODO: doc 1 đằng code 1 lẻo ??? ưtf

class NoteList extends StatefulWidget {
  const NoteList({super.key});
  static String state = "noteList";

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends NyState<NoteList> {
  List<Note> notes = [];

  _NoteListState() {
    stateName = NoteList.state;
  }

  @override
  stateUpdated(data) async {
    notes = await NyStorage.readCollection<Note>(Keys.note,
        modelDecoders: modelDecoders);

    setState(() {});
  }

  @override
  get init => () async {
        notes = await NyStorage.readCollection<Note>(Keys.note,
            modelDecoders: modelDecoders);
        setState(() {});
      };

  @override
  Widget view(BuildContext context) {
    return NyListView(
      shrinkWrap: true,
      empty: Center(child: Text("trống")),
      child: (BuildContext context, dynamic data) {
        return ListTile(
          title: Text(data['title']),
          subtitle: Text(data['date']),
        );
      },
      data: () async {
        return notes.map((e) {
          return {"title": e.title, "date": e.dateTime.toDateStringUK()};
        }).toList();
      },
    );
  }
}
