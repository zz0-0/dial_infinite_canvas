import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  double cx = 1000.0;
  double cy = 1000.0;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _key1 = GlobalKey();
  double cardtop = 50;
  double cardleft = 50;
  double cardtop1 = 50;
  double cardleft1 = 350;
  late Offset pos1 = Offset.infinite;
  late Offset pos2 = Offset.infinite;

  callback(pos) {
    setState(() {
      pos1 = pos;
    });
  }

  callback1(pos) {
    setState(() {
      pos2 = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        TransformationController(Matrix4.translationValues(-cx, -cy, 0.0));

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
                          feedback: DetailCardWidget(
                            callback: callback,
                          ),
                          onDragEnd: (details) {
                            setState(() {
                              pos1 = pos1.translate(
                                  details.offset.dx - cardleft,
                                  details.offset.dy - cardtop);

                              cardtop = details.offset.dy;
                              cardleft = details.offset.dx;
                            });
                          },
                          child: DetailCardWidget(
                            callback: callback,
                          ),
                        ),
                      ),
                      Positioned(
                        key: _key1,
                        top: cardtop,
                        left: cardleft + 300,
                        child: Draggable(
                          feedback: DetailCardWidget(
                            callback: callback1,
                          ),
                          onDragEnd: (details) {
                            setState(() {
                              pos2 = pos2.translate(
                                  details.offset.dx - cardleft1,
                                  details.offset.dy - cardtop1);

                              cardtop1 = details.offset.dy;
                              cardleft1 = details.offset.dx;
                            });
                          },
                          child: DetailCardWidget(
                            callback: callback1,
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
              CustomPaint(
                painter: EdgePainter(
                  pos1: pos1,
                  pos2: pos2,
                  // notifier: notifier,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class EdgePainter extends CustomPainter {
  Offset pos1, pos2;

  EdgePainter({required this.pos1, required this.pos2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawLine(pos1, pos2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
