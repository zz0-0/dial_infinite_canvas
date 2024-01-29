import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu extends ConsumerWidget {
  final Function callback;
  const Menu({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(children: [
        IconButton(
          onPressed: () {
            callback();
          },
          icon: const Icon(Icons.add_box_outlined),
        ),
      ]),
    );
  }
}
