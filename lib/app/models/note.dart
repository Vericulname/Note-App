// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:nylo_framework/nylo_framework.dart';

class Note extends Model {
  static StorageKey key = "note";

  String? title;
  String? content;
  DateTime? dateCreate;
  DateTime? dateUpdate;

  Note({
    this.title,
    this.content,
    this.dateCreate,
    this.dateUpdate
  }) : super(key: key);

  Note.fromJson(data) : super(key: key) {
    title = data["title"];
    content = data["content"];
    dateCreate = DateTime.fromMillisecondsSinceEpoch(data["dateCreate"]);
    dateUpdate = DateTime.fromMillisecondsSinceEpoch(data["dateUpdate"]);
  }

  @override
  toJson() {
    return {
      "title": title,
      "content": content,
      "dateCreate": dateCreate?.millisecondsSinceEpoch,
      "dateUpdate": dateUpdate?.millisecondsSinceEpoch
    };
  }
}
