import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';
import 'package:aimed_infinite_canvas/src/domain/model/info_card.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';

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
                    delegate: InfoCardWidgetWidgetsDelegate(ref),
                    children: [
                      ...ref.watch(infoCardWidgetListProvider),
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
  }

  Future<void> executeAfterPaint() async {
    await Future.delayed(Duration.zero);
  }
}

class EdgePainter extends CustomPainter {
  List<(GlobalKey, GlobalKey)> node;
  GlobalKey? start;
  GlobalKey? end;
  // Map<GlobalKey, Offset> nodePositions;
  double mouseX;
  double mouseY;

  EdgePainter({
    required this.node,
    required this.start,
    required this.end,
    // required this.nodePositions,
    required this.mouseX,
    required this.mouseY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    // if (node.isNotEmpty) {
    //   for (var i in node) {
    //     if (nodePositions[i.$1] != Offset.infinite &&
    //         nodePositions[i.$2] != Offset.infinite) {
    //       canvas.drawLine(nodePositions[i.$1]!, nodePositions[i.$2]!, paint);
    //     }
    //   }
    // }

    // if (start != null) {
    //   if (end != null) {
    //     if (nodePositions[start] != Offset.infinite &&
    //         nodePositions[end] != Offset.infinite) {
    //       canvas.drawLine(nodePositions[start]!, nodePositions[end]!, paint);
    //       node.add((start!, end!));
    //       start = null;
    //       end = null;
    //     }
    //   } else {
    //     canvas.drawLine(nodePositions[start]!, Offset(mouseX, mouseY), paint);
    //   }
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Map<GlobalKey, InfoCard> cardPositionsClone = {};

class InfoCardWidgetWidgetsDelegate extends MultiChildLayoutDelegate {
  WidgetRef ref;
  InfoCardWidgetWidgetsDelegate(this.ref);
  Offset childPosition = Offset.zero;

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
            if (card.position == childPosition) {
              childPosition += Offset(0, currentSize.height + 5);
            }
          }
        } else {
          positionChild(key, childPosition);
          cardPositions[key]?.position = childPosition;
          cardPositionsClone[key] = cardPositions[key]!;
          childPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
