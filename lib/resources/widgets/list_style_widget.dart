import 'package:flutter/material.dart';
import 'package:flutter_app/config/enum.dart';
import 'package:flutter_app/resources/widgets/note_list_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ListStyle extends StatefulWidget {
  const ListStyle({super.key});

  @override
  createState() => _ListStyleState();
}

class _ListStyleState extends NyState<ListStyle> {
  //listView, gribView
  List<bool> _listStyle = [true, false];
  @override
  get init => () {};

  String DropdownVal = "test2";

  @override
  Widget view(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(8.0),
        isSelected: _listStyle,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _listStyle.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _listStyle[buttonIndex] = true;
              } else {
                _listStyle[buttonIndex] = false;
              }
            }
          });
          if (_listStyle[0]) {
            updateState<NoteList>(NoteList.state,
                data: {"flag": NoteListFlag.ChangeToListView});
          }
          if (_listStyle[1]) {
            updateState<NoteList>(NoteList.state,
                data: {"flag": NoteListFlag.ChangeToGribView});
          }
        },
        children: const <Widget>[
          Icon(Icons.list),
          Icon(Icons.grid_view),
        ],
      ),
    );
  }
}
