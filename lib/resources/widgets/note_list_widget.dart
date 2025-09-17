import 'package:flutter/material.dart';
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
  const NoteList({super.key});
  static String state = "noteList";

  static List<Note> deleteNotes = [];

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends NyState<NoteList> {
  List<Note> notes = [];
  List<Note> filterednotes = [];

  bool deleteMode = false;
  bool isGribView = false;

  _NoteListState() {
    stateName = NoteList.state;
  }

  @override
  stateUpdated(data) async {
    notes = await NyStorage.readCollection<Note>(Keys.note,
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
        filterednotes = notes
            .where((e) =>
                e.title!.toLowerCase().contains(data["title"].toLowerCase()))
            .toList();
      case NoteListFlag.updateState:
        filterednotes = List.from(notes);
        break;
      default:
        print("có gì đó lỗi r");
        break;
    }

    setState(() {});
  }

  @override
  get init => () async {
        notes = await NyStorage.readCollection<Note>(Keys.note,
            modelDecoders: modelDecoders);

        setState(() {
          filterednotes = List.from(notes);
        });
      };

  @override
  Widget view(BuildContext context) {
    return isGribView
        ? NyListView.grid(
            shrinkWrap: true,
            crossAxisCount: 2,
            empty: Center(
                child: Text("Danh sách trống, hãy bấm + để thêm ghi chú mới")),
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
                child: ListTile(
                  onTap: () => routeTo(NotecreatePage.path, data: note),
                  subtitle:
                      Text(note.dateCreate.toDateStringUK()!).bodyMedium(),
                  title: Text(note.title!),
                  trailing: deleteMode
                      ? Checkbox(
                          value: NoteList.deleteNotes.contains(note),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                NoteList.deleteNotes.add(note);
                              } else {
                                NoteList.deleteNotes
                                    .removeWhere((val) => val == note);
                              }
                            });
                          },
                        )
                      : null,
                ),
              );
            },
            data: () async {
              return filterednotes.map((e) {
                return {"note": e};
              }).toList();
            },
          )
        : NyListView.separated(
            shrinkWrap: true,
            empty: Center(
                child: Text("Danh sách trống, hãy bấm + để thêm ghi chú mới")),
            child: (
              context,
              data,
            ) {
              Note note = data['note'];
              return ListTile(
                onTap: () => routeTo(NotecreatePage.path, data: note),
                leading: deleteMode
                    ? Checkbox(
                        value: NoteList.deleteNotes.contains(note),
                        onChanged: (value) {
                          if (value!) {
                            NoteList.deleteNotes.add(note);
                          } else {
                            NoteList.deleteNotes
                                .removeWhere((val) => val == note);
                          }
                          reboot();
                        },
                      )
                    : null,
                title: Text(note.title!),
                trailing: Text(note.dateCreate.toDateStringUK()!).bodyMedium(),
              );
            },
            data: () {
              return filterednotes.map((e) {
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
}
