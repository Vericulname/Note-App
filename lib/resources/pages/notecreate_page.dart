import 'package:flutter/material.dart';
import 'package:flutter_app/app/events/note_create_event.dart';
import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              pop();
              // _createNote();
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
                controller: titleController,
                hintText: "tiêu đề",
                maxLength: 120,
              ),
              NyTextField.compact(
                  controller: contentController, hintText: "nội dung"),
              Button.primary(
                text: "tao",
                onPressed: () {
                  validate(
                      onSuccess: () {
                        _createNote();
                      },
                      rules: {
                        "title": [titleController.text, "not_empty"],
                        "content": [contentController.text, "not_empty"]
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createNote() {
    String title = titleController.text;
    String content = contentController.text;

    DateTime date = DateTime.now();

    print("press");

    Note note = Note(title: title, content: content, dateTime: date);
    event<NoteCreateEvent>(data: {"note": note});
  }
}
