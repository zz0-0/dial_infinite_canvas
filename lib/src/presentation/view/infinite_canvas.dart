import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
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
  late Offset pos1 = Offset.infinite;
  late Offset pos2 = Offset.infinite;

  var detailCardWidgets = <Positioned>[];

  double cardtop = 50;
  double cardleft = 50;

  setEdgeStartPositionCallback(pos) {
    setState(() {
      pos1 = pos;
    });
  }

  setEdgeEndPositionCallback(pos) {
    setState(() {
      pos2 = pos;
    });
  }

  void createDetailCardWidget() {
    final GlobalKey _key = GlobalKey();

    setState(() {
      detailCardWidgets.add(
        Positioned(
          key: _key,
          top: cardtop,
          left: cardleft,
          child: Draggable(
            feedback: DetailCardWidget(
              callback: setEdgeStartPositionCallback,
            ),
            onDragEnd: (details) {
              setState(
                () {
                  pos1 = pos1.translate(details.offset.dx - cardleft,
                      details.offset.dy - cardtop);
                  cardtop = details.offset.dy;
                  cardleft = details.offset.dx;
                },
              );
            },
            child: DetailCardWidget(
              callback: setEdgeStartPositionCallback,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
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
                      Background(),
                      ...detailCardWidgets,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Menu(
                  callback: createDetailCardWidget,
                ),
              ),
              // CustomPaint(
              //   painter: EdgePainter(
              //     pos1: pos1,
              //     pos2: pos2,
              //     // notifier: notifier,
              //   ),
              // )
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
