import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () => createGroupWidget(ref),
            mini: true,
            tooltip: "Add Group",
            child: const Icon(Icons.add_home_outlined),
          ),
          FloatingActionButton(
            onPressed: () => createInfoCardWidget(ref),
            mini: true,
            tooltip: "Add Card",
            child: const Icon(Icons.add_box_outlined),
          ),
          FloatingActionButton(
            onPressed: () => resetCanvasZoomLevel(),
            mini: true,
            tooltip: "Reset Zoom",
            child: const Icon(Icons.restore_page_outlined),
          ),
          FloatingActionButton(
            onPressed: () => zoomIn(ref),
            mini: true,
            tooltip: "Zoom in",
            child: const Icon(Icons.arrow_circle_up),
          ),
          FloatingActionButton(
            onPressed: () => zoomOut(ref),
            mini: true,
            tooltip: "Zoom out",
            child: const Icon(Icons.arrow_circle_down),
          ),
        ],
      ),
    );
  }

  void createInfoCardWidget(WidgetRef ref) {
    final GlobalKey key = GlobalKey();
    final card = ref.watch(cardProvider(key));
    final layoutId =
        ref.read(cardLayoutProvider.notifier).build(card.key, ResizeType.card);
    ref.read(cardLayoutProvider.notifier).addLayoutId(layoutId);
  }

  void createGroupWidget(WidgetRef ref) {
    final GlobalKey key = GlobalKey();
    final group = ref.watch(groupProvider(key));

    final layoutId = ref
        .read(groupLayoutProvider.notifier)
        .build(group.key, ResizeType.group);
    ref.read(groupLayoutProvider.notifier).addLayoutId(layoutId);
  }

  void resetCanvasZoomLevel() {
    ref.read(scaleProvider.notifier).update((state) => 1);
  }

  void zoomIn(WidgetRef ref) {
    ref.read(scaleProvider.notifier).update((state) => state + 0.1);
  }

  void zoomOut(WidgetRef ref) {
    ref.read(scaleProvider.notifier).update((state) => state - 0.1);
  }
}
