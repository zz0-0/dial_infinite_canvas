import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/interactive_canvas.dart';

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
  });

  final double? menuLeftPosition;
  final double? menuBottomPosition;
  final double? canvasHeight;
  final double? canvasWidth;
  final int? divisions;
  final int? subdivisions;
  final double? cardHeight;
  final double? cardWidth;

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
    if (widget.cardHeight != null) {
      ref
          .read(cardHeightProvider.notifier)
          .update((state) => widget.cardHeight!);
    }
    if (widget.cardWidth != null) {
      ref.read(cardWidthProvider.notifier).update((state) => widget.cardWidth!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const InteractiveCanvas(),
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
