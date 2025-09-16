// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:nylo_framework/nylo_framework.dart';

class Note extends Model {
  static StorageKey key = "note";

  String? title;
  String? content;
  DateTime? dateTime;

  Note({
    this.title,
    this.content,
    this.dateTime,
  }) : super(key: key);


  Note.fromJson(data) : super(key: key) {
    title = data["title"];
    content = data["content"];
    dateTime = DateTime.fromMillisecondsSinceEpoch(data["dateTime"]);
  }

  @override
  toJson() {
    return {
      "title": title,
      "content": content,
      "dateTime": dateTime?.millisecondsSinceEpoch
    };
  }
}
