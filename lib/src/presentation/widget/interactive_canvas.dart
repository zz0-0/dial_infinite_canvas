import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:dial_infinite_canvas/src/domain/model/edge.dart';
import 'package:dial_infinite_canvas/src/domain/model/group.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/background.dart';

class InteractiveCanvas extends ConsumerStatefulWidget {
  const InteractiveCanvas({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InteractiveCanvasState();
}

class _InteractiveCanvasState extends ConsumerState<InteractiveCanvas> {
  @override
  Widget build(BuildContext context) {
    var canvasWidth = ref.watch(canvasWidthProvider);
    var canvasHeight = ref.watch(canvasHeightProvider);

    return MouseRegion(
      onHover: updateMouseLocation,
      child: InteractiveViewer(
        transformationController: ref.watch(transformationControllerProvider),
        boundaryMargin: const EdgeInsets.all(0),
        clipBehavior: Clip.none,
        constrained: false,
        child: SizedBox(
          width: 2 * canvasWidth,
          height: 2 * canvasHeight,
          child: Stack(
            children: [
              const Background(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  executeAfterLayout();
                  return CustomMultiChildLayout(
                    delegate: LayoutDelegate(ref),
                    children: [
                      ...ref.watch(infoCardWidgetListProvider),
                      ...ref.watch(groupWidgetListProvider),
                    ],
                  );
                },
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  executeAfterPaint();
                  return CustomPaint(painter: ref.watch(edgePainterProvider));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateMouseLocation(PointerEvent details) {
    ref
        .read(mouseXProvider.notifier)
        .update((state) => state = details.position.dx);
    ref
        .read(mouseYProvider.notifier)
        .update((state) => state = details.position.dy);
  }

  Future<void> executeAfterLayout() async {
    await Future.delayed(Duration.zero);
    if (cardPositionsClone.isNotEmpty) {
      if (ref.read(cardPositionMapProvider) != cardPositionsClone) {
        ref.read(cardPositionMapProvider.notifier).update((state) {
          state = cardPositionsClone;
          return state;
        });
      }
    }

    if (groupPositionsClone.isNotEmpty) {
      if (ref.read(groupPositionMapProvider) != groupPositionsClone) {
        ref.read(groupPositionMapProvider.notifier).update((state) {
          state = groupPositionsClone;
          return state;
        });
      }
    }
  }

  Future<void> executeAfterPaint() async {
    await Future.delayed(Duration.zero);

    var sourceCard = ref.read(startKeyProvider);
    var targetCard = ref.read(endKeyProvider);
    var sourceNode = ref.read(cardPositionMapProvider)[sourceCard]?.outputNode;
    var targetNode = ref.read(cardPositionMapProvider)[targetCard]?.inputNode;

    if (sourceCard != null &&
        targetCard != null &&
        sourceNode != null &&
        targetNode != null) {
      var connectedNodes = ref.read(connectedNodeListProvider);
      connectedNodes.add(
        Edge(
          sourceCardKey: sourceCard,
          targetCardKey: targetCard,
          sourceNode: sourceNode,
          targetNode: targetNode,
        ),
      );
      ref.read(connectedNodeListProvider.notifier).update((state) {
        state = connectedNodes;
        return state;
      });

      ref.read(startKeyProvider.notifier).update((state) => null);
      ref.read(endKeyProvider.notifier).update((state) => null);
    }
  }
}

class EdgePainter extends CustomPainter {
  List<Edge> node;
  GlobalKey? start;
  GlobalKey? end;
  Map<GlobalKey, InfoCard> cardPositions;
  double mouseX;
  double mouseY;

  EdgePainter({
    required this.node,
    required this.start,
    required this.end,
    required this.cardPositions,
    required this.mouseX,
    required this.mouseY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    if (node.isNotEmpty) {
      for (var n in node) {
        var source = cardPositions[n.sourceCardKey]?.outputNode.position;
        var target = cardPositions[n.targetCardKey]?.inputNode.position;
        if (source != Offset.infinite && target != Offset.infinite) {
          canvas.drawLine(source!, target!, paint);
        }
      }
    }

    if (start != null) {
      if (end != null) {
        var source = cardPositions[start]?.outputNode.position;
        var target = cardPositions[end]?.outputNode.position;
        if (source != Offset.infinite && target != Offset.infinite) {
          canvas.drawLine(source!, target!, paint);
        }
      } else {
        var source = cardPositions[start]?.outputNode.position;
        canvas.drawLine(source!, Offset(mouseX, mouseY), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Map<GlobalKey, InfoCard> cardPositionsClone = {};
Map<GlobalKey, Group> groupPositionsClone = {};

class LayoutDelegate extends MultiChildLayoutDelegate {
  WidgetRef ref;
  LayoutDelegate(this.ref);
  Offset cardChildPosition = Offset.zero;
  Offset groupChildPosition = const Offset(250, 0);

  @override
  void performLayout(Size size) {
    var cardPositions = ref.watch(cardPositionMapProvider);
    for (var key in cardPositions.keys) {
      var position = cardPositions[key]?.position;
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (position != Offset.infinite) {
          positionChild(key, position!);
          // in case there are some cards has been dragged to other place,
          // the default childPosition will check every occupied spot to avoid overlap with each other,
          // childPosition needs to be an empty spot
          for (var card in cardPositions.values) {
            if (card.position == cardChildPosition) {
              cardChildPosition += Offset(0, currentSize.height + 5);
            }
          }
        } else {
          positionChild(key, cardChildPosition);
          cardPositions[key]?.position = cardChildPosition;
          cardPositions[key]?.inputNode.position =
              cardChildPosition + const Offset(0, 100);
          cardPositions[key]?.outputNode.position =
              cardChildPosition + const Offset(200, 100);
          cardPositionsClone[key] = cardPositions[key]!;
          cardChildPosition += Offset(0, currentSize.height + 5);
        }
      }
    }

    var groupPositions = ref.watch(groupPositionMapProvider);
    for (var key in groupPositions.keys) {
      var position = groupPositions[key]?.position;
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (position != Offset.infinite) {
          positionChild(key, position!);
          for (var group in groupPositions.values) {
            if (group.position == groupChildPosition) {
              groupChildPosition += Offset(0, currentSize.height + 5);
            }
          }
        } else {
          positionChild(key, groupChildPosition);
          groupPositions[key]?.position = groupChildPosition;
          groupPositionsClone[key] = groupPositions[key]!;
          groupChildPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
