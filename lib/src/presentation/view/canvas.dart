import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/card_renderer.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/node_renderer.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/edge_renderer.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/group_renderer.dart';

class Canvas extends ConsumerStatefulWidget {
  const Canvas({
    super.key,
    // this.gridSize = const Size.square(50),
    // this.backgroundBuilder,
  });

  // final Size gridSize;
  // final Widget Function(BuildContext, Rect)? backgroundBuilder;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CanvasState();
}

class _CanvasState extends ConsumerState<Canvas> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer.builder(
            alignment: Alignment.center,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            onInteractionStart: (details) {},
            onInteractionUpdate: (details) {},
            builder: (context, quad) {
              return SizedBox.fromSize(
                size: Size.square(500),
                child: const Stack(
                  children: [
                    Background(),
                    // Menu(),
                    // GroupRenderer(),
                    // CardRenderer(),
                    // EdgeRenderer(),
                    // NodeRenderer(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
