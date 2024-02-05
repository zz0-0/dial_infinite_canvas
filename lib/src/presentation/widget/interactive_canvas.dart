import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';

var newCardPositions = {};

class InteractiveCanvas extends ConsumerStatefulWidget {
  const InteractiveCanvas({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InteractiveCanvasState();
}

class _InteractiveCanvasState extends ConsumerState<InteractiveCanvas> {
  // executeAfterBuild(WidgetRef ref) {
  //   print(newCardPositions);
  //   ref.read(cardPositionMapProvider.notifier).update((state) {
  //     state = Map.from(newCardPositions);
  //     return state;
  //   });
  // }
  double x = 0.0;
  double y = 0.0;

  @override
  Widget build(BuildContext context) {
    double cx = 1000.0;
    double cy = 1000.0;

    // Future.delayed(Duration.zero, () => executeAfterBuild(ref));

    return MouseRegion(
      onHover: updateMouseLocation,
      child: InteractiveViewer(
        transformationController: ref.watch(transformationControllerProvider),
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
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return CustomMultiChildLayout(
                    delegate: DetailCardWidgetsDelegate(ref),
                    children: [
                      ...ref.watch(detailCardListProvider),
                    ],
                  );
                },
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return CustomPaint(painter: ref.watch(edgePainterProvider));
                  // EdgePainter(
                  //   node: ref.watch(connectedNodeListProvider),
                  //   start: ref.watch(startKeyProvider),
                  //   end: ref.watch(endKeyProvider),
                  //   cardPositions: ref.watch(cardPositionMapProvider),
                  //   // ref: ref,
                  // ),
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
    // x = details.position.dx;
    // y = details.position.dy;
  }
}

class EdgePainter extends CustomPainter {
  List<(GlobalKey, GlobalKey)> node;
  GlobalKey? start;
  GlobalKey? end;
  Map<GlobalKey, Offset> cardPositions;
  double mouseX;
  double mouseY;
  // WidgetRef ref;

  EdgePainter(
      {required this.node,
      required this.start,
      required this.end,
      required this.cardPositions,
      required this.mouseX,
      required this.mouseY
      // required this.ref,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    // var node = ref.watch(connectedNodeListProvider);
    // var start = ref.watch(startKeyProvider);
    // var end = ref.watch(endKeyProvider);
    // var cardPositions = ref.watch(cardPositionMapProvider);

    if (node.isNotEmpty) {
      for (var i in node) {
        if (cardPositions[i.$1] != Offset.infinite &&
            cardPositions[i.$2] != Offset.infinite) {
          canvas.drawLine(cardPositions[i.$1]!, cardPositions[i.$2]!, paint);
        }
      }
    }

    if (start != null) {
      if (end != null) {
        if (cardPositions[start] != Offset.infinite &&
            cardPositions[end] != Offset.infinite) {
          canvas.drawLine(cardPositions[start]!, cardPositions[end]!, paint);
          node.add((start!, end!));
          // var nodeValue = ref.read(connectedNodeListProvider);
          // nodeValue.add((start, end));
          // ref.read(connectedNodeListProvider.notifier).update((state) {
          //   state = nodeValue.toList();
          //   return state;
          // });
          start = null;
          end = null;
        }
      } else {
        canvas.drawLine(cardPositions[start]!, Offset(mouseX, mouseY), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DetailCardWidgetsDelegate extends MultiChildLayoutDelegate {
  Offset childPosition = Offset.zero;
  WidgetRef ref;
  DetailCardWidgetsDelegate(this.ref);

  @override
  void performLayout(Size size) {
    var cardPositions = ref.watch(cardPositionMapProvider);
    for (var key in cardPositions.keys) {
      if (hasChild(key)) {
        final Size currentSize = layoutChild(
            key, BoxConstraints(maxWidth: size.width, maxHeight: size.height));
        if (cardPositions[key] != Offset.infinite) {
          positionChild(key, cardPositions[key]!);
          newCardPositions[key] = cardPositions[key]!;
        } else {
          positionChild(key, childPosition);
          newCardPositions[key] = childPosition;
          childPosition += Offset(0, currentSize.height + 5);
        }
      }
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}