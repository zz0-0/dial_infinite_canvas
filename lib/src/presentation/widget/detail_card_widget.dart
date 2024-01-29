import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCardWidget extends ConsumerStatefulWidget {
  final GlobalKey cardKey;
  final Function dragCallback;
  final Function tapCallback;

  const DetailCardWidget({
    super.key,
    required this.cardKey,
    required this.dragCallback,
    required this.tapCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailCardWidgetState();
}

class _DetailCardWidgetState extends ConsumerState<DetailCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Draggable(
          feedback: Container(),
          onDragEnd: (details) {
            widget.dragCallback(widget.cardKey, details.offset);
          },
          child: const SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Title"),
                        subtitle: Text("SubTitle"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTapDown: (details) {
            widget.tapCallback(widget.cardKey);
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
