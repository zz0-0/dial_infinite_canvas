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
          updateGroupPosition(details);
        },
        child: dottedBorder,
      ),
    );
  }

  void updateGroupPosition(DraggableDetails details) {
    var groupPositions = ref.read(groupPositionMapProvider);
    var cardPositions = ref.read(cardPositionMapProvider);
    var group = groupPositions[widget.groupKey]!;
    var originialOffset = group.position;
    group.position = details.offset;
    var diffOffset = group.position - originialOffset;
    var cards = group.cards;

    if (cards.isNotEmpty) {
      for (var key in cards.keys) {
        cards[key]?.position += diffOffset;
        cardPositions[key]?.position += diffOffset;
      }
    }

    ref.read(groupPositionMapProvider.notifier).update((state) {
      state = Map.from(groupPositions);
      return state;
    });

    ref.read(cardPositionMapProvider.notifier).update((state) {
      state = Map.from(cardPositions);
      return state;
    });
  }
}
