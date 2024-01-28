import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu extends ConsumerStatefulWidget {
  final Function callback;
  const Menu({
    super.key,
    required this.callback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(children: [
        IconButton(
          onPressed: () {
            widget.callback();
          },
          icon: const Icon(Icons.add_box_outlined),
        ),
      ]),
    );
  }
}
