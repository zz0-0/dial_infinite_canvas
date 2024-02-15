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
              // seperate consumer for reducing times to rebuild
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  // update provider after build, in the build would cause error
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
                  executeAfterPaint();
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

  Future<void> executeAfterPaint() async {
    await Future.delayed(Duration.zero);
    // save new edge
    var sourceCard = ref.watch(startKeyProvider);
    var targetCard = ref.watch(endKeyProvider);

    if (sourceCard != null && targetCard != null) {
      var sourceNode = ref.watch(cardProvider(sourceCard)).outputNode;
      var targetNode = ref.watch(cardProvider(targetCard)).inputNode;

      var connectedNodes = ref.watch(connectedNodeListProvider);
      connectedNodes.add(
        Edge(
          sourceCard: sourceCard,
          targetCard: targetCard,
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

  Future<void> executeAfterLayout() async {
    await Future.delayed(Duration.zero);
    // save the location of the group
    if (groupClone != null) {
      if (groupClone!.position != Offset.infinite) {
        if (ref.watch(groupProvider(groupClone!.key)) != groupClone) {
          ref
              .read(groupProvider(groupClone!.key).notifier)
              .updatePosition(groupClone!.position);
        }
      }
    }
    // print(groupClone!.position);

    // save the position of the card
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

    // paint lines on existing nodes
    if (node.isNotEmpty) {
      for (var n in node) {
        var sourceNode = ref.watch(cardProvider(n.sourceCard)).outputNode;
        var targetNode = ref.watch(cardProvider(n.targetCard)).inputNode;
        var source = ref.watch(nodeProvider(sourceNode)).position;
        var target = ref.watch(nodeProvider(targetNode)).position;
        if (source != Offset.infinite && target != Offset.infinite) {
          canvas.drawLine(source, target, paint);
        }
      }
    }

    // add line drawing with starting and ending nodes
    if (start != null && end != null) {
      var sourceNode = ref.watch(cardProvider(start)).outputNode;
      var targetNode = ref.watch(cardProvider(end)).inputNode;
      var source = ref.watch(nodeProvider(sourceNode)).position;
      var target = ref.watch(nodeProvider(targetNode)).position;
      if (source != Offset.infinite && target != Offset.infinite) {
        canvas.drawLine(source, target, paint);
      }
    }

    // add line drawing with only starting node
    if (start != null) {
      var sourceNode = ref.watch(cardProvider(start)).outputNode;
      var source = ref.watch(nodeProvider(sourceNode)).position;
      canvas.drawLine(source, Offset(mouseX, mouseY), paint);
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
    // obtain all keys based on groupLayoutProvider
    var groupLayout = ref.watch(groupLayoutProvider);
    for (var layoutId in groupLayout) {
      var key = layoutId.id;
      var group = ref.watch(groupProvider(key as GlobalKey));
      var position = group.position;
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (position != Offset.infinite) {
          // the existing layout is based on the saved location,
          // mainly to deal with the situation after dragging and dropping
          positionChild(key, position);
        } else {
          // add new cards, layout according to default positions,
          // and for each new card added, the default value increases
          positionChild(key, groupChildPosition);
          groupClone = group.copyWith(position: groupChildPosition);
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
          cardClone = card.copyWith(position: cardChildPosition);
          cardChildPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
