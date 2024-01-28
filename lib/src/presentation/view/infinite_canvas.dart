import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/menu.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';

Offset start = Offset.infinite;
Offset end = Offset.infinite;

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  double cx = 1000.0;
  double cy = 1000.0;

  bool notSetStartPosition = true;
  var detailCardWidgets = <LayoutId>[];

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

  createDetailCardWidget() {
    final GlobalKey key = GlobalKey();
    var positionWidget = LayoutId(
      id: key,
      child: Draggable(
        feedback: DetailCardWidget(callback: checkCallbackStatus),
        onDragEnd: (details) {
          setState(
            () {
              // var renderBox =
              //     key.currentContext?.findRenderObject() as RenderBox;
              // var position = renderBox.localToGlobal(Offset.zero);
              // print(position);
              // if (notSetStartPosition) {
              //   start = position;
              // } else {
              //   end = position;
              // }
            },
          );
        },
        child: DetailCardWidget(callback: checkCallbackStatus),
      ),
    );

    setState(
      () {
        detailCardWidgets.add(positionWidget);
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
                      Background(),
                      CustomMultiChildLayout(
                        delegate: DetailCardWidgetsDelegate(detailCardWidgets),
                        children: [
                          ...detailCardWidgets,
                        ],
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
              CustomPaint(
                painter: EdgePainter(pos1: start, pos2: end),
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
    if (pos1 != Offset.infinite && pos1 != Offset.infinite) {
      final paint = Paint()..color = Colors.blue;
      canvas.drawLine(pos1, pos2, paint);
      start = Offset.infinite;
      end = Offset.infinite;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DetailCardWidgetsDelegate extends MultiChildLayoutDelegate {
  late List<GlobalKey> layoutIds;

  DetailCardWidgetsDelegate(List<LayoutId> list) {
    layoutIds = getLayoutId(list);
  }

  Offset childPosition = Offset.zero;

  @override
  void performLayout(Size size) {
    for (GlobalKey id in layoutIds) {
      if (hasChild(id)) {
        final Size currentSize = layoutChild(
            id, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        positionChild(id, childPosition);
        childPosition += Offset(0, currentSize.height + 5);
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;

  List<GlobalKey> getLayoutId(List<LayoutId> list) {
    return list.map((e) => e.id as GlobalKey).toList();
  }
}
