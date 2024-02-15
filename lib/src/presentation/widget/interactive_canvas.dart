import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
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
                      ...ref.watch(groupLayoutProvider),
                      ...ref.watch(cardLayoutProvider),
                    ],
                  );
                },
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  // executeAfterPaint();
                  return CustomPaint(painter: EdgePainter(ref));
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
    if (groupClone != null) {
      if (groupClone!.position != Offset.infinite) {
        if (ref.watch(groupProvider(groupClone!.key)) != groupClone) {
          ref
              .read(groupProvider(groupClone!.key).notifier)
              .updatePosition(groupClone!.position);
        }
      }
    }

    if (cardClone != null) {
      if (cardClone!.position != Offset.infinite) {
        if (ref.watch(cardProvider(cardClone!.key)) != cardClone) {
          ref
              .read(cardProvider(cardClone!.key).notifier)
              .updatePosition(cardClone!.position);
          var card = ref.watch(cardProvider(cardClone!.key));
          ref
              .read(nodeProvider(card.inputNode).notifier)
              .updatePosition(cardClone!.position + const Offset(0, 100));
          ref
              .read(nodeProvider(card.outputNode).notifier)
              .updatePosition(cardClone!.position + const Offset(200, 100));
        }
      }
    }
  }

  Future<void> executeAfterPaint() async {
    await Future.delayed(Duration.zero);

    // var sourceCard = ref.read(startKeyProvider);
    // var targetCard = ref.read(endKeyProvider);
    // var sourceNode = ref.read(cardPositionMapProvider)[sourceCard]?.outputNode;
    // var targetNode = ref.read(cardPositionMapProvider)[targetCard]?.inputNode;

    // if (sourceCard != null &&
    //     targetCard != null &&
    //     sourceNode != null &&
    //     targetNode != null) {
    //   var connectedNodes = ref.read(connectedNodeListProvider);
    //   connectedNodes.add(
    //     Edge(
    //       sourceCardKey: sourceCard,
    //       targetCardKey: targetCard,
    //       sourceNode: sourceNode,
    //       targetNode: targetNode,
    //     ),
    //   );
    //   ref.read(connectedNodeListProvider.notifier).update((state) {
    //     state = connectedNodes;
    //     return state;
    //   });

    //   ref.read(startKeyProvider.notifier).update((state) => null);
    //   ref.read(endKeyProvider.notifier).update((state) => null);
    // }
  }
}

class EdgePainter extends CustomPainter {
  WidgetRef ref;
  EdgePainter(this.ref);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    var node = ref.watch(connectedNodeListProvider);
    var start = ref.watch(startKeyProvider);
    var end = ref.watch(endKeyProvider);
    var mouseX = ref.watch(mouseXProvider);
    var mouseY = ref.watch(mouseYProvider);

    if (node.isNotEmpty) {
      for (var n in node) {
        var sourceNodeKey = ref.watch(cardProvider(n.sourceCardKey)).outputNode;
        var targetNodeKey = ref.watch(cardProvider(n.targetCardKey)).inputNode;
        var source = ref.watch(nodeProvider(sourceNodeKey)).position;
        var target = ref.watch(nodeProvider(targetNodeKey)).position;
        if (source != Offset.infinite && target != Offset.infinite) {
          canvas.drawLine(source, target, paint);
        }
      }
    }

    if (start != null && end != null) {
      var sourceNodeKey = ref.watch(cardProvider(start)).outputNode;
      var targetNodeKey = ref.watch(cardProvider(end)).inputNode;
      var source = ref.watch(nodeProvider(sourceNodeKey)).position;
      var target = ref.watch(nodeProvider(targetNodeKey)).position;
      if (source != Offset.infinite && target != Offset.infinite) {
        canvas.drawLine(source, target, paint);
      } else {
        canvas.drawLine(source, Offset(mouseX, mouseY), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

InfoCard? cardClone;
Group? groupClone;

class LayoutDelegate extends MultiChildLayoutDelegate {
  WidgetRef ref;
  LayoutDelegate(this.ref);
  Offset cardChildPosition = Offset.zero;
  Offset groupChildPosition = const Offset(250, 0);

  @override
  void performLayout(Size size) {
    var groupLayout = ref.watch(groupLayoutProvider);
    for (var layoutId in groupLayout) {
      var key = layoutId.id;
      var group = ref.watch(groupProvider(key as GlobalKey));
      var position = group.position;
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (position != Offset.infinite) {
          positionChild(key, position);
        } else {
          positionChild(key, groupChildPosition);
          groupClone = group;
          groupChildPosition += Offset(0, currentSize.height + 5);
        }
      }
    }

    var cardLayout = ref.watch(cardLayoutProvider);
    for (var layoutId in cardLayout) {
      var key = layoutId.id;
      var card = ref.watch(cardProvider(key as GlobalKey));
      var position = card.position;
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (position != Offset.infinite) {
          positionChild(key, position);
        } else {
          positionChild(key, cardChildPosition);

          cardClone = card;
          cardChildPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
