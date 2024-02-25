import 'package:dial_infinite_canvas/src/presentation/widget/interactive_canvas.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:dial_minimap/dial_minimap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({
    super.key,
    this.canvasHeight,
    this.canvasWidth,
    this.menuLeftPosition,
    this.menuBottomPosition,
    this.divisions,
    this.subdivisions,
    this.cardHeight,
    this.cardWidth,
    this.groupHeight,
    this.groupWidth,
  });

  final double? menuLeftPosition;
  final double? menuBottomPosition;
  final double? canvasHeight;
  final double? canvasWidth;
  final int? divisions;
  final int? subdivisions;
  final double? cardHeight;
  final double? cardWidth;
  final double? groupHeight;
  final double? groupWidth;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  @override
  void initState() {
    super.initState();
    if (widget.menuLeftPosition != null) {
      ref
          .read(menuLeftPositionProvider.notifier)
          .update((state) => widget.menuLeftPosition!);
    }
    if (widget.menuBottomPosition != null) {
      ref
          .read(menuBottomPositionProvider.notifier)
          .update((state) => widget.menuBottomPosition!);
    }
    if (widget.canvasHeight != null) {
      ref
          .read(canvasHeightProvider.notifier)
          .update((state) => widget.canvasHeight!);
    }
    if (widget.canvasWidth != null) {
      ref
          .read(canvasWidthProvider.notifier)
          .update((state) => widget.canvasWidth!);
    }
    if (widget.divisions != null) {
      ref.read(divisionsProvider.notifier).update((state) => widget.divisions!);
    }
    if (widget.subdivisions != null) {
      ref
          .read(subdivisionsProvider.notifier)
          .update((state) => widget.subdivisions!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // const InteractiveCanvas(),
              const MinimapScreen(widget: InteractiveCanvas()),
              Positioned(
                left: ref.watch(menuLeftPositionProvider),
                bottom: ref.watch(menuBottomPositionProvider),
                child: const Menu(),
              ),
            ],
          );
        },
      ),
    );
  }
}
