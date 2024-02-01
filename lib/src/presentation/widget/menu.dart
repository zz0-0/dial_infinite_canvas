import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

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
          onPressed: () => createDetailCardWidget(ref),
          icon: const Icon(Icons.add_box_outlined),
        ),
        // IconButton(
        //   onPressed: () => resetCanvasZoomLevel(),
        //   icon: const Icon(Icons.restore_page_outlined),
        // ),
      ]),
    );
  }
}

createDetailCardWidget(WidgetRef ref) {
  final GlobalKey key = GlobalKey();
  var positionWidget = LayoutId(
    id: key,
    child: DetailCardWidget(
      cardKey: key,
    ),
  );

  var details = ref.read(detailCardWidgetListProvider);
  details.add(positionWidget);

  ref
      .read(detailCardWidgetListProvider.notifier)
      .update((state) => details.toList());

  var positions = ref.read(cardPositionMapProvider);
  positions[key] = Offset.infinite;

  ref.read(cardPositionMapProvider.notifier).update((state) {
    state = Map.from(positions);
    return state;
  });
}

// resetCanvasZoomLevel() {
//   setState(() {
//     viewTransformationController.value.setEntry(0, 0, 2);
//   });
// }
