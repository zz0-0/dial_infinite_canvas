import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Resizer extends ConsumerStatefulWidget {
  const Resizer({
    super.key,
    required this.cardKey,
    required this.type,
    required this.child,
  });

  final GlobalKey cardKey;
  final ResizeType type;
  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResizerState();
}

class _ResizerState extends ConsumerState<Resizer> {
  double top = 0.0;
  double left = 0.0;
  double bottom = 0.0;
  double right = 0.0;
  late double width;
  late double height;
  double initX = 0.0;
  double initY = 0.0;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case ResizeType.card:
        width = ref.watch(cardWidthProvider(widget.cardKey));
        height = ref.watch(cardHeightProvider(widget.cardKey));
      case ResizeType.group:
        width = ref.watch(groupWidthProvider(widget.cardKey));
        height = ref.watch(groupHeightProvider(widget.cardKey));
      default:
    }

    return Stack(
      children: [
        Positioned.fromRect(
          rect: Rect.fromLTWH(left, top, width, height),
          child: widget.child,
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
                    updateDrag(details, ResizeDirection.right, widget.type),
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
                    updateDrag(details, ResizeDirection.bottom, widget.type),
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
                onPanUpdate: (details) => updateDrag(
                  details,
                  ResizeDirection.bottomRight,
                  widget.type,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void startDrag(DragStartDetails details, ResizeDirection direction) {
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
  }

  void updateDrag(
    DragUpdateDetails details,
    ResizeDirection direction,
    ResizeType type,
  ) {
    late StateProvider<double> heightProvider;
    late StateProvider<double> widthProvider;
    switch (type) {
      case ResizeType.card:
        heightProvider = cardHeightProvider(widget.cardKey);
        widthProvider = cardWidthProvider(widget.cardKey);
      case ResizeType.group:
        heightProvider = groupHeightProvider(widget.cardKey);
        widthProvider = groupWidthProvider(widget.cardKey);
      default:
    }

    switch (direction) {
      case ResizeDirection.bottom:
        final dy = details.globalPosition.dy - initY;
        final newHeight = height + dy;
        ref.read(heightProvider.notifier).update((state) => newHeight);
        initY = details.globalPosition.dy;
      case ResizeDirection.right:
        final dx = details.globalPosition.dx - initX;
        final newWidth = width + dx;
        ref.read(widthProvider.notifier).update((state) => newWidth);
        initX = details.globalPosition.dx;
      case ResizeDirection.bottomRight:
        final dx = details.globalPosition.dx - initX;
        final dy = details.globalPosition.dy - initY;
        final newWidth = width + dx;
        final newHeight = height + dy;
        ref.read(heightProvider.notifier).update((state) => newHeight);
        ref.read(widthProvider.notifier).update((state) => newWidth);
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
      default:
    }
  }
}
