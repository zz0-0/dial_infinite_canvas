import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

double cx = 1000.0;
double cy = 1000.0;

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  final controller =
      TransformationController(Matrix4.translationValues(-cx, -cy, 0.0));

  final GlobalKey _key = GlobalKey();
  double cardtop = 50;
  double cardleft = 50;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
                // transformationController: controller,
                boundaryMargin: const EdgeInsets.all(0),
                onInteractionStart: (details) {},
                onInteractionUpdate: (details) {},
                onInteractionEnd: (details) {},
                clipBehavior: Clip.none,
                constrained: false,
                child: SizedBox(
                  width: 2 * cx,
                  height: 2 * cy,
                  child: Stack(
                    children: [
                      const Background(),
                      Positioned(
                        key: _key,
                        top: cardtop,
                        left: cardleft,
                        child: Draggable(
                          feedback: const Card(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Text("456"),
                            ),
                          ),
                          onDragEnd: (details) {
                            setState(() {
                              cardtop = details.offset.dy;
                              cardleft = details.offset.dx;
                            });
                          },
                          child: const Card(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Text("123"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  final viewport = Offset.zero & constraints.biggest;
                  final r = Rect.fromPoints(
                          controller.toScene(viewport.topLeft),
                          controller.toScene(viewport.bottomRight))
                      .translate(-cx, -cy);
                  return Text(
                    '${r.topLeft}\n${r.size}\ntop:$cardtop,left:$cardleft',
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
