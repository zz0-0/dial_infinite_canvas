import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/resizer.dart';

class GroupWidget extends ConsumerStatefulWidget {
  const GroupWidget({
    super.key,
    required this.groupKey,
  });

  final GlobalKey groupKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends ConsumerState<GroupWidget> {
  @override
  Widget build(BuildContext context) {
    var height = ref.watch(groupHeightProvider(widget.groupKey));
    var width = ref.watch(groupWidthProvider(widget.groupKey));
    var dottedBorder = DottedBorder(
      color: Colors.white,
      strokeWidth: 3,
      dashPattern: const [10, 6],
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
    return Resizer(
      cardKey: widget.groupKey,
      type: ResizeType.group,
      child: Draggable(
        feedback: dottedBorder,
        onDragEnd: (details) {
          var positions = ref.read(groupPositionMapProvider);
          positions[widget.groupKey]?.position = details.offset;

          ref.read(groupPositionMapProvider.notifier).update((state) {
            state = Map.from(positions);
            return state;
          });
        },
        child: dottedBorder,
      ),
    );
  }
}
