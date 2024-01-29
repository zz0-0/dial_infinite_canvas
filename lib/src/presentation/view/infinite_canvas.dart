import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

GlobalKey? start;
GlobalKey? end;
var nodes = <(GlobalKey, GlobalKey)>[];
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

  bool notSetStartKey = true;

  checkCallbackStatus(key) {
    if (notSetStartKey) {
      setEdgeStartKeyCallback(key);
    } else {
      setEdgeEndKeyCallback(key);
    }
  }

  setEdgeStartKeyCallback(key) {
    setState(() {
      start = key;
      notSetStartKey = false;
    });
  }

  setEdgeEndKeyCallback(key) {
    setState(() {
      end = key;
      notSetStartKey = true;
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
        feedback: DetailCardWidget(cardKey: key, callback: checkCallbackStatus),
        onDragEnd: (details) {
          setDragEnd(key, details.offset);
        },
        child: DetailCardWidget(cardKey: key, callback: checkCallbackStatus),
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
                        painter: EdgePainter(key1: start, key2: end),
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
  GlobalKey? key1, key2;

  EdgePainter({required this.key1, required this.key2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    if (nodes.isNotEmpty) {
      for (var i in nodes) {
        if (cardPositions[i.$1] != Offset.infinite &&
            cardPositions[i.$2] != Offset.infinite) {
          canvas.drawLine(cardPositions[i.$1]!, cardPositions[i.$2]!, paint);
        }
      }
    }

    if (key1 != null && key2 != null) {
      if (cardPositions[key1] != Offset.infinite &&
          cardPositions[key2] != Offset.infinite) {
        canvas.drawLine(cardPositions[key1]!, cardPositions[key2]!, paint);
        nodes.add((key1!, key2!));
        start = null;
        end = null;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DetailCardWidgetsDelegate extends MultiChildLayoutDelegate {
  Offset childPosition = Offset.zero;

  @override
  void performLayout(Size size) {
    for (var key in cardPositions.keys) {
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (cardPositions[key] != Offset.infinite) {
          positionChild(key, cardPositions[key]!);
        } else {
          positionChild(key, childPosition);
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
