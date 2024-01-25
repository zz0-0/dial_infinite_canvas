import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/background.dart';

class InfiniteCanvas extends ConsumerStatefulWidget {
  const InfiniteCanvas({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends ConsumerState<InfiniteCanvas> {
  ValueNotifier<double> _valueNotifier = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(double.infinity),
            onInteractionStart: (details) {},
            onInteractionUpdate: (details) {},
            onInteractionEnd: (details) {},
            clipBehavior: Clip.none,
            child: CustomPaint(
              painter: BackgroundPainter(valueNotifier: _valueNotifier),
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    const Background(),
                    const Draggable(
                      feedback: Card(
                        child: Text("data1"),
                      ),
                      child: Card(
                        child: Text("data"),
                      ),
                    ),
                    DragTarget(
                      builder: (BuildContext context, List<dynamic> accepted,
                          List<dynamic> rejected) {
                        return const Card(
                          child: Text("data"),
                        );
                      },
                      onWillAccept: (data) {
                        return data == 'red';
                      },
                      onAccept: (data) {},
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  ValueNotifier<double> valueNotifier;

  BackgroundPainter({required this.valueNotifier})
      : super(repaint: valueNotifier) {}

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
