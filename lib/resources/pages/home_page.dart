import 'package:flutter_app/app/events/note_delete_event.dart';
import 'package:flutter_app/app/models/note.dart';
import 'package:flutter_app/config/enum.dart';
import 'package:flutter_app/resources/pages/notecreate_page.dart';
import 'package:flutter_app/resources/widgets/list_style_widget.dart';
import 'package:flutter_app/resources/widgets/note_list_widget.dart';

import '/resources/widgets/theme_toggle_widget.dart';
import '/app/networking/api_service.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/safearea_widget.dart';
import '/app/controllers/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static RouteView path = ("/home", (_) => HomePage());

  HomePage({super.key}) : super(child: () => _HomePageState());

  @override
  createState() => _HomePageState();
}

class _HomePageState extends NyPage<HomePage> {
  int? _stars;
  bool deleteMode = false;

  @override
  stateUpdated(data) async {
    (print("in home page"));
    // return super.stateUpdated(data);
  }

  @override
  get init => () async {
        /// Uncomment the code below to fetch the number of stars for the Nylo repository
        // Map<String, dynamic>? githubResponse = await api<ApiService>(
        //         (request) => request.githubInfo(),
        // );
        // _stars = githubResponse?["stargazers_count"];
      };

  /// Define the Loading style for the page.
  /// Options: LoadingStyle.normal(), LoadingStyle.skeletonizer(), LoadingStyle.none()
  /// uncomment the code below.
  @override
  LoadingStyle get loadingStyle => LoadingStyle.normal();

  /// The [view] method displays your page.
  @override
  Widget view(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
        //dan don
        appBar: deleteMode
            ? AppBar(
                title: Text("Hãy chọn ghi chú để xoá").titleLarge(fontSize: 20),
                actions: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        deleteMode = false;

                        updateState<NoteList>(NoteList.state,
                            data: {"flag": NoteListFlag.deleteMode});
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                  Spacing.horizontal(20.0),
                  InkWell(
                      onTap: () {
                        setState(() {
                          stateAction("delete_note", state: NoteList.state);

                          deleteMode = false;
                        });
                      },
                      child: Icon(
                        Icons.done,
                        size: 30,
                      ))
                ],
                actionsPadding: EdgeInsets.only(right: 20.0),
              )
            : AppBar(
                title: Text("Ghi chú").titleLarge(fontSize: 40),
                actions: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        deleteMode = true;
                        updateState<NoteList>(NoteList.state,
                            data: {"flag": NoteListFlag.deleteMode});
                      });
                    },
                    child: Text(
                      "Xoá ghi chú",
                    ).titleLarge(fontSize: 20),
                  ),
                ],
                actionsPadding: EdgeInsets.only(right: 10.0),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            routeTo(NotecreatePage.path);
          },
          child: const Icon(Icons.add),
        ),
        body: SafeAreaWidget(
          child: Column(
            spacing: 8.0,
            children: [
              NyTextField.compact(
                controller: searchController,
                backgroundColor: Colors.grey.withOpacity(0.4),
                hintText: "tìm kiếm",
                prefixIcon: Icon(Icons.search),
                onChanged: (value) {
                  updateState<NoteList>(NoteList.state,
                      data: {"flag": NoteListFlag.SearchNote, "title": value});
                },
              ),
              Align(alignment: AlignmentGeometry.topLeft, child: ListStyle()),
              Expanded(child: NoteList()),
            ],
          ),
        ));
  }
}
