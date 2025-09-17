import 'package:flutter/material.dart';
import 'package:flutter_app/app/events/note_create_event.dart';
import 'package:flutter_app/app/events/note_modify_event.dart';
import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NotecreatePage extends NyStatefulWidget {
  static RouteView path = ("/notecreate", (_) => NotecreatePage());

  NotecreatePage({super.key}) : super(child: () => _NotecreatePageState());
}

class _NotecreatePageState extends NyPage<NotecreatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    Note? note;
    bool editMode = false;
    bool hasChanged = false;

    if (widget.data() != null) {
      note = widget.data();

      titleController.text = note!.title!;
      contentController.text = note.content!;

      editMode = true;
    }

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 20.0),
        actions: [
          //tạo 1 note mới để đưa đi lưu/update
          InkWell(
              onTap: () {
                String title = titleController.text;
                String content = contentController.text;

                if (title.isEmpty) {
                  title = content;
                }
                if (title.isNotEmpty && content.isNotEmpty && hasChanged) {
                  _createOrModifyNote(hasChanged, editMode, note);
                  hasChanged = false;
                } else {
                  hasChanged = false;
                  showToastOops(description: "tiêu đề và nội dung rỗng");
                }
              },
              child: Icon(Icons.done))
        ],
        leading: InkWell(
            onTap: () {
              _createOrModifyNote(hasChanged, editMode, note);
              pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 8.0,
            children: [
              NyTextField.compact(
                onChanged: (value) {
                  hasChanged = true;
                },
                controller: titleController,
                hintText: "tiêu đề",
                maxLength: 120,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text("tạo vào ngày: ${editMode ? _forMatDate(note?.dateCreate) : _forMatDate(DateTime.now())}")
                      .bodyMedium(),
                  editMode
                      ? Text("cập nhập vào ngày: ${_forMatDate(note?.dateUpdate)}")
                          .bodyMedium()
                      : SizedBox()
                ],
              ),
              Expanded(
                child: NyTextField.compact(
                    onChanged: (value) {
                      hasChanged = true;
                    },
                    textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: contentController,
                    hintText: "nội dung"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _forMatDate(DateTime? date) {
    return DateFormat("d \'tháng\' M H:m").format(date!);
  }

  void _createOrModifyNote(bool hasChanged, bool editMode, Note? note) {
    if (titleController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        hasChanged) {
      String title = titleController.text;
      String content = contentController.text;

      DateTime date = DateTime.now();

      Note noteToSaveOrModify = Note(
          title: title,
          content: content,
          dateCreate: editMode ? note!.dateCreate : date,
          dateUpdate: date);
      editMode
          ? event<NoteModifyEvent>(data: {"note": noteToSaveOrModify})
          : event<NoteCreateEvent>(data: {"note": noteToSaveOrModify});
    }
  }
}
