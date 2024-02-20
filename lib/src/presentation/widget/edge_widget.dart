import 'package:flutter/material.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/domain/model/edge.dart';

class EdgeWidget extends ConsumerStatefulWidget {
  const EdgeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EdgeWidgetState();
}

class _EdgeWidgetState extends ConsumerState<EdgeWidget> {
  @override
  Widget build(BuildContext context) {
    executeAfterPaint();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.grab,
        onTap: () {
          print("Tapped");
        },
        child: CustomPaint(
          painter: EdgePainter(ref),
          size: const Size(100, 100),
        ),
      ),
    );
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