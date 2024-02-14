import 'package:flutter/material.dart';
import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 100,
      child: Column(children: [
        IconButton(
          onPressed: () => createGroupWidget(ref),
          icon: const Icon(Icons.add_home_outlined),
        ),
        IconButton(
          onPressed: () => createInfoCardWidget(ref),
          icon: const Icon(Icons.add_box_outlined),
        ),
        IconButton(
          onPressed: () => resetCanvasZoomLevel(),
          icon: const Icon(Icons.restore_page_outlined),
        ),
        IconButton(
          onPressed: () => zoomIn(ref),
          icon: const Icon(Icons.arrow_circle_up),
        ),
        IconButton(
          onPressed: () => zoomOut(ref),
          icon: const Icon(Icons.arrow_circle_down),
        )
      ]),
    );
  }

  createInfoCardWidget(WidgetRef ref) {
    // final GlobalKey key = GlobalKey();
    // final GlobalKey key1 = GlobalKey();
    // final GlobalKey key2 = GlobalKey();
    // var positionWidget = LayoutId(
    //   id: key,
    //   child: InfoCardWidget(
    //     cardKey: key,
    //   ),
    // );

    // var details = ref.read(infoCardWidgetListProvider);
    // details.add(positionWidget);

    // ref
    //     .read(infoCardWidgetListProvider.notifier)
    //     .update((state) => details.toList());

    // var cardPositions = ref.read(cardPositionMapProvider);
    // cardPositions[key] = InfoCard(
    //   key: key,
    //   position: Offset.infinite,
    //   height: ref.read(cardHeightProvider(key)),
    //   width: ref.read(cardHeightProvider(key)),
    //   inputNode: Node(key: key1, position: Offset.infinite),
    //   outputNode: Node(key: key2, position: Offset.infinite),
    // );

    // ref.read(cardPositionMapProvider.notifier).update((state) {
    //   state = cardPositions;
    //   return state;
    // });

    var card = ref.watch(cardProvider);

    var layoutId =
        ref.read(cardLayoutProvider.notifier).build(card.key, ResizeType.card);
    ref.read(cardLayoutProvider.notifier).addLayoutId(layoutId);
  }

  createGroupWidget(WidgetRef ref) {
    var group = ref.watch(groupProvider);

    var layoutId = ref
        .read(groupLayoutProvider.notifier)
        .build(group.key, ResizeType.group);
    ref.read(groupLayoutProvider.notifier).addLayoutId(layoutId);
  }

  resetCanvasZoomLevel() {
    ref.read(scaleProvider.notifier).update((state) => 1);
  }

  zoomIn(WidgetRef ref) {
    ref.read(scaleProvider.notifier).update((state) => state + 0.1);
  }

  zoomOut(WidgetRef ref) {
    ref.read(scaleProvider.notifier).update((state) => state - 0.1);
  }
}
