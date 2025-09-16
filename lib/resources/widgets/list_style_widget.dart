import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ListStyle extends StatefulWidget {
  const ListStyle({super.key});

  @override
  createState() => _ListStyleState();
}

class _ListStyleState extends NyState<ListStyle> {
  List<bool> _listStyle = [true, false];
  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            items: [],
            onChanged: (value) {},
          ),
          ToggleButtons(
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
            },
            children: const <Widget>[
              Icon(Icons.list),
              Icon(Icons.grid_view),
            ],
          ),
        ],
      ),
    );
  }
}
