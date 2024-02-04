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
      height: 200,
      width: 100,
      child: Column(children: [
        IconButton(
          onPressed: () => createDetailCardWidget(ref),
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
