import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/resizer.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final height = ref.watch(groupHeightProvider(widget.groupKey));
    final width = ref.watch(groupWidthProvider(widget.groupKey));
    final dottedBorder = DottedBorder(
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
          updateGroupPosition(details);
        },
        child: dottedBorder,
      ),
    );
  }

  void updateGroupPosition(DraggableDetails details) {
    final oldPosition = ref.watch(groupProvider(widget.groupKey)).position;
    final diff = details.offset - oldPosition;
    ref
        .read(groupProvider(widget.groupKey).notifier)
        .updatePosition(details.offset);
    final cards = ref.watch(groupProvider(widget.groupKey)).cards;
    for (final card in cards) {
      final position = ref.read(cardProvider(card)).position;
      ref.read(cardProvider(card).notifier).updatePosition(position + diff);
    }
  }
}
