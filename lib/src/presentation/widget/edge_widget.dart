import 'package:dial_infinite_canvas/src/domain/model/edge.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EdgeWidget extends ConsumerStatefulWidget {
  const EdgeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EdgeWidgetState();
}

bool drawArc = false;

class _EdgeWidgetState extends ConsumerState<EdgeWidget> {
  @override
  Widget build(BuildContext context) {
    executeAfterPaint();
    return GestureDetector(
      onTap: () {},
      onLongPress: () {
        setState(() {
          drawArc = true;
        });
      },
      child: CustomPaint(
        painter: EdgePainter(ref),
        child: Container(),
      ),
    );
  }

  Future<void> executeAfterPaint() async {
    await Future.delayed(Duration.zero);
    // save new edge
    final sourceCard = ref.watch(startKeyProvider);
    final targetCard = ref.watch(endKeyProvider);

    if (sourceCard != null && targetCard != null) {
      ref.watch(cardProvider(sourceCard));
      ref.watch(cardProvider(targetCard));

      final sourceNode = ref.watch(cardProvider(sourceCard)).outputNode;
      final targetNode = ref.watch(cardProvider(targetCard)).inputNode;

      final connectedNodes = ref.watch(connectedNodeListProvider);
      connectedNodes.add(
        Edge(
          sourceCard: sourceCard,
          targetCard: targetCard,
          sourceNode: sourceNode,
          targetNode: targetNode,
        ),
      );
      ref.read(connectedNodeListProvider.notifier).update((state) {
        return connectedNodes;
      });

      ref.read(startKeyProvider.notifier).update((state) => null);
      ref.read(endKeyProvider.notifier).update((state) => null);
    }
  }
}

class EdgePainter extends CustomPainter {
  WidgetRef ref;
  EdgePainter(this.ref);
  Path p = Path();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;

    final node = ref.watch(connectedNodeListProvider);
    final start = ref.watch(startKeyProvider);
    final end = ref.watch(endKeyProvider);
    final mouseX = ref.watch(mouseXProvider);
    final mouseY = ref.watch(mouseYProvider);

    // paint lines on existing nodes
    if (node.isNotEmpty) {
      for (final n in node) {
        final sourceNode = ref.watch(cardProvider(n.sourceCard)).outputNode;
        final targetNode = ref.watch(cardProvider(n.targetCard)).inputNode;
        final source = ref.watch(nodeProvider(sourceNode)).position;
        final target = ref.watch(nodeProvider(targetNode)).position;
        if (source != Offset.infinite && target != Offset.infinite) {
          if (!drawArc) {
            p.moveTo(source.dx, source.dy);
            p.lineTo(target.dx, target.dy);
            p.close();
            canvas.drawPath(p, paint);
            final Rect rect = Offset.zero & Size(size.width, size.height);
            canvas.drawRect(rect, paint);
          }
        }
      }
    }

    // add line drawing with starting and ending nodes
    if (start != null && end != null) {
      final sourceNode = ref.watch(cardProvider(start)).outputNode;
      final targetNode = ref.watch(cardProvider(end)).inputNode;
      final source = ref.watch(nodeProvider(sourceNode)).position;
      final target = ref.watch(nodeProvider(targetNode)).position;
      if (source != Offset.infinite && target != Offset.infinite) {
        // canvas.drawLine(source, target, paint);
        p.moveTo(source.dx, source.dy);
        p.lineTo(target.dx, target.dy);
        p.close();
        canvas.drawPath(p, paint);
      }
    }

    // add line drawing with only starting node
    if (start != null) {
      final sourceNode = ref.watch(cardProvider(start)).outputNode;
      final source = ref.watch(nodeProvider(sourceNode)).position;
      // canvas.drawLine(source, Offset(mouseX, mouseY), paint);
      p.moveTo(source.dx, source.dy);
      p.lineTo(mouseX, mouseY);
      p.close();
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    return p.contains(position);
  }
}
