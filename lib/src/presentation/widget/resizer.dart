import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';

enum ResizeDirection {
  // top("TOP"),
  bottom("BOTTOM"),
  // left("LEFT"),
  right("RIGHT"),
  bottomRight("BOTTOMRIGHT");

  const ResizeDirection(this.label);
  final String label;
}

class Resizer extends ConsumerStatefulWidget {
  const Resizer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResizerState();
}

const ballDiameter = 30.0;

class _ResizerState extends ConsumerState<Resizer> {
  double top = 0.0, left = 0.0, bottom = 0.0, right = 0.0;
  late double width, height;
  bool dragTop = false, dragBottom = false, dragLeft = false, dragRight = false;
  double initX = 0.0, initY = 0.0;

  @override
  Widget build(BuildContext context) {
    width = ref.watch(cardWidthProvider);
    height = ref.watch(cardHeightProvider);

    // bottom = height - 10;
    bool isHovering = false;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // if (dragBottom ||
          //     dragRight ||
          //     !(dragTop && dragBottom && dragLeft && dragRight))
          Positioned(
            top: top,
            left: left,
            // right: right,
            // bottom: bottom,
            child: SizedBox(
              width: width,
              height: height,
              child: widget.child,
            ),
          ),
          // if (dragTop || dragLeft)
          // Positioned(
          //   bottom: bottom,
          //   right: right,
          //   child: SizedBox(
          //     width: width,
          //     height: height,
          //     child: widget.child,
          //   ),
          // ),
          // 左
          // Positioned(
          //   top: top,
          //   left: left,
          //   height: height,
          //   width: 20,
          //   child: GestureDetector(
          //     child: Text("qqqqqq"),
          //     onPanStart: (details) => startDrag(details, ResizeDirection.left),
          //     onPanUpdate: (details) =>
          //         updateDrag(details, ResizeDirection.left),
          //   ),
          // ),
          // 上
          // Positioned(
          //   top: top,
          //   left: left,
          //   height: 20,
          //   width: width,
          //   child: GestureDetector(
          //     child: Text("wwwwww"),
          //     onPanStart: (details) => startDrag(details, ResizeDirection.top),
          //     onPanUpdate: (details) =>
          //         updateDrag(details, ResizeDirection.top),
          //   ),
          // ),
          // 右
          Positioned(
            top: top,
            left: left + width - 20,
            height: height - 20,
            width: 20,
            child: InkWell(
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
    // switch (direction) {
    // case ResizeDirection.top:
    //   dragTop = true;
    //   print(initX);
    //   break;
    // case ResizeDirection.bottom:
    //   dragBottom = true;
    //   break;
    // case ResizeDirection.left:
    //   dragLeft = true;
    //   break;
    // case ResizeDirection.right:
    //   dragRight = true;
    //   break;
    // default:
    // }
  }

  void updateDrag(DragUpdateDetails details, ResizeDirection direction) {
    switch (direction) {
      // case ResizeDirection.top:
      //   var dy = details.globalPosition.dy - initY;
      //   var newHeight = height + dy;
      //   print("init:$initY");
      //   print("after:$dy");
      //   setState(() {
      //     height = newHeight;
      //     // top = top + newHeight;
      //   });
      //   initY = details.globalPosition.dy;
      //   break;
      case ResizeDirection.bottom:
        var dy = details.globalPosition.dy - initY;
        var newHeight = height + dy;
        setState(() {
          height = newHeight;
        });
        initY = details.globalPosition.dy;
        break;
      // case ResizeDirection.left:
      //   var dx = details.globalPosition.dx - initX;
      //   var newWidth = width + dx;
      //   setState(() {
      //     width = newWidth > 0 ? newWidth : 0;
      //   });
      //   initX = details.globalPosition.dx;
      //   break;
      case ResizeDirection.right:
        var dx = details.globalPosition.dx - initX;
        var newWidth = width + dx;
        setState(() {
          width = newWidth;
        });
        initX = details.globalPosition.dx;
        break;
      case ResizeDirection.bottomRight:
        var dx = details.globalPosition.dx - initX;
        var dy = details.globalPosition.dy - initY;
        var newWidth = width + dx;
        var newHeight = height + dy;
        setState(() {
          width = newWidth;
          height = newHeight;
        });
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
        break;
      default:
    }
  }
}
