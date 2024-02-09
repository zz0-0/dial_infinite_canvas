import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';

enum ResizeDirection {
  bottom("BOTTOM"),
  right("RIGHT"),
  bottomRight("BOTTOMRIGHT");

  const ResizeDirection(this.label);
  final String label;
}

class Resizer extends ConsumerStatefulWidget {
  const Resizer({
    super.key,
    required this.cardKey,
    required this.child,
  });

  final GlobalKey cardKey;
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResizerState();
}

class _ResizerState extends ConsumerState<Resizer> {
  double top = 0.0, left = 0.0, bottom = 0.0, right = 0.0;
  late double width, height;
  double initX = 0.0, initY = 0.0;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    width = ref.watch(cardWidthProvider(widget.cardKey));
    height = ref.watch(cardHeightProvider(widget.cardKey));

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: top,
            left: left,
            child: SizedBox(
              width: width,
              height: height,
              child: widget.child,
            ),
          ),
          // 右
          Positioned(
            top: top,
            left: left + width - 20,
            height: height - 20,
            width: 20,
            child: InkWell(
              mouseCursor: SystemMouseCursors.resizeRight,
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isHovering = value;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                decoration: BoxDecoration(
                  color: isHovering ? Colors.green : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onPanStart: (details) =>
                      startDrag(details, ResizeDirection.right),
                  onPanUpdate: (details) =>
                      updateDrag(details, ResizeDirection.right),
                ),
              ),
            ),
          ),
          // 下
          Positioned(
            top: top + height - 20,
            left: left,
            height: 20,
            width: width - 20,
            child: InkWell(
              mouseCursor: SystemMouseCursors.resizeDown,
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isHovering = value;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                decoration: BoxDecoration(
                  color: isHovering ? Colors.green : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onPanStart: (details) =>
                      startDrag(details, ResizeDirection.bottom),
                  onPanUpdate: (details) =>
                      updateDrag(details, ResizeDirection.bottom),
                ),
              ),
            ),
          ),
          // 右下
          Positioned(
            top: top + height - 20,
            left: left + width - 20,
            height: 20,
            width: 20,
            child: InkWell(
              mouseCursor: SystemMouseCursors.resizeDownRight,
              onTap: () {},
              onHover: (value) {
                setState(() {
                  isHovering = value;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                decoration: BoxDecoration(
                  color: isHovering ? Colors.green : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GestureDetector(
                  onPanStart: (details) =>
                      startDrag(details, ResizeDirection.bottomRight),
                  onPanUpdate: (details) =>
                      updateDrag(details, ResizeDirection.bottomRight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startDrag(DragStartDetails details, ResizeDirection direction) {
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
  }

  void updateDrag(DragUpdateDetails details, ResizeDirection direction) {
    switch (direction) {
      case ResizeDirection.bottom:
        var dy = details.globalPosition.dy - initY;
        var newHeight = height + dy;
        ref
            .read(cardHeightProvider(widget.cardKey).notifier)
            .update((state) => newHeight);
        initY = details.globalPosition.dy;
        break;
      case ResizeDirection.right:
        var dx = details.globalPosition.dx - initX;
        var newWidth = width + dx;
        ref
            .read(cardWidthProvider(widget.cardKey).notifier)
            .update((state) => newWidth);
        initX = details.globalPosition.dx;
        break;
      case ResizeDirection.bottomRight:
        var dx = details.globalPosition.dx - initX;
        var dy = details.globalPosition.dy - initY;
        var newWidth = width + dx;
        var newHeight = height + dy;
        ref
            .read(cardHeightProvider(widget.cardKey).notifier)
            .update((state) => newHeight);
        ref
            .read(cardWidthProvider(widget.cardKey).notifier)
            .update((state) => newWidth);
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
        break;
      default:
    }
  }
}
