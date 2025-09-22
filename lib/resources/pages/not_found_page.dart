import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NotFoundPage extends NyStatefulWidget {
  static RouteView path = ("/not-found", (_) => NotFoundPage());

  NotFoundPage({super.key}) : super(child: () => _NotFoundPageState());
}

class _NotFoundPageState extends NyState<NotFoundPage> {
  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Không thấy")),
      body: SafeArea(
        child: Center(
          child: Text("Không tìm thấy trang x.x, lỗi gì rồi"),
        ),
      ),
    );
  }
}
