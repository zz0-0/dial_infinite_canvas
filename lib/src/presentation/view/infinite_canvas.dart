import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

Offset start = Offset.infinite;
Offset end = Offset.infinite;
var positions = <(Offset, Offset)>[];
var detailCardWidgets = <LayoutId>[];
Map<GlobalKey, Offset> cardPositions = HashMap();

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  double cx = 1000.0;
  double cy = 1000.0;

  bool notSetStartPosition = true;

  checkCallbackStatus(pos) {
    if (notSetStartPosition) {
      setEdgeStartPositionCallback(pos);
    } else {
      setEdgeEndPositionCallback(pos);
    }
  }

  setEdgeStartPositionCallback(pos) {
    setState(() {
      start = pos;
      notSetStartPosition = false;
    });
  }

  setEdgeEndPositionCallback(pos) {
    setState(() {
      end = pos;
      notSetStartPosition = true;
    });
  }

  setDragEnd(GlobalKey key, Offset offset) {
    setState(() {
      cardPositions[key] = offset;
    });
  }

  createDetailCardWidget() {
    final GlobalKey key = GlobalKey();
    var positionWidget = LayoutId(
      id: key,
      child: Draggable(
        feedback: DetailCardWidget(callback: checkCallbackStatus),
        onDragEnd: (details) {
          setDragEnd(key, details.offset);
        },
        child: DetailCardWidget(callback: checkCallbackStatus),
      ),
    );

    setState(
      () {
        detailCardWidgets.add(positionWidget);
        cardPositions[key] = Offset.infinite;
      },
    );
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
                      const Background(),
                      CustomMultiChildLayout(
                        delegate: DetailCardWidgetsDelegate(),
                        children: [
                          ...detailCardWidgets,
                        ],
                      ),
                      CustomPaint(
                        painter: EdgePainter(pos1: start, pos2: end),
                      ),
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
    if (positions.isNotEmpty) {
      for (var i in positions) {
        if (i.$1 != Offset.infinite && i.$2 != Offset.infinite) {
          canvas.drawLine(i.$1, i.$2, paint);
        }
      }
    }

    if (pos1 != Offset.infinite && pos2 != Offset.infinite) {
      canvas.drawLine(pos1, pos2, paint);
      positions.add((pos1, pos2));
      start = Offset.infinite;
      end = Offset.infinite;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DetailCardWidgetsDelegate extends MultiChildLayoutDelegate {
  Offset childPosition = Offset.zero;

  @override
  void performLayout(Size size) {
    for (var id in cardPositions.keys) {
      if (hasChild(id)) {
        final Size currentSize = layoutChild(
            id, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (cardPositions[id] != Offset.infinite) {
          positionChild(id, cardPositions[id]!);
        } else {
          positionChild(id, childPosition);
          childPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
