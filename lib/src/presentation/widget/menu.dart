import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

class Menu extends ConsumerStatefulWidget {
  Function callback;
  Menu({
    super.key,
    required this.callback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Column(children: [
        IconButton(
          onPressed: () {
            widget.callback();
          },
          icon: Icon(Icons.add_box_outlined),
        ),
      ]),
    );
  }
}
