import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:dial_infinite_canvas/src/domain/model/overlap.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/resizer.dart';

class InfoCardWidget extends ConsumerStatefulWidget {
  final GlobalKey cardKey;
  final Function? onCardDragBegin;
  final Function? onCardDragging;
  final Function? onCardDragEnd;
  final Function? onCardClick;
  final Function? onCardDoubleClick;
  final Function? onCardLongPressed;
  final Function? onCardMouseEnter;
  final Function? onCardMouseLeave;
  final Function? onCardMouseMoveInside;

  const InfoCardWidget({
    this.onCardDragBegin,
    this.onCardDragging,
    this.onCardDragEnd,
    this.onCardClick,
    this.onCardDoubleClick,
    this.onCardLongPressed,
    this.onCardMouseEnter,
    this.onCardMouseLeave,
    this.onCardMouseMoveInside,
    super.key,
    required this.cardKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoCardWidgetState();
}

enum CardType {
  simple("Simple"),
  complex("Complex");

  const CardType(this.label);
  final String label;
}

class _InfoCardWidgetState extends ConsumerState<InfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    var notSetStarNode = ref.watch(notSetStartNodeProvider);
    var sizedBox = Card(
      child: Column(
        children: [
          DropdownMenu(
            enableSearch: false,
            initialSelection: CardType.simple,
            dropdownMenuEntries: CardType.values.map(
              (e) {
                return DropdownMenuEntry<CardType>(value: e, label: e.label);
              },
            ).toList(),
            onSelected: (value) => ref
                .read(cardTypeProvider(widget.cardKey).notifier)
                .update((state) => state = value!),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: setChildByType(widget.cardKey),
          )
        ],
      ),
    );
    return Stack(
      children: [
        Resizer(
          cardKey: widget.cardKey,
          type: ResizeType.card,
          child: Draggable(
            feedback: sizedBox,
            onDragUpdate: (details) {
              detectOverlapping(details);
            },
            onDragEnd: (details) {
              updateCardPosition(details);
            },
            child: sizedBox,
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          child: InkWell(
            mouseCursor: SystemMouseCursors.alias,
            child: GestureDetector(
              onTapDown: (details) {
                updateNodeKey(notSetStarNode);
              },
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 0,
          child: InkWell(
            mouseCursor: SystemMouseCursors.alias,
            child: GestureDetector(
              onTapDown: (details) {
                updateNodeKey(notSetStarNode);
              },
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void detectOverlapping(DragUpdateDetails details) {
    // Offset cardTopLeft = details.globalPosition;
    // Offset cardBottomRight = cardTopLeft +
    //     Offset(ref.read(cardWidthProvider(widget.cardKey)),
    //         ref.read(cardHeightProvider(widget.cardKey)));
    // var groups = ref.read(groupPositionMapProvider);
    // for (var key in groups.keys) {
    //   var groupTopLeft = groups[key]?.position;
    //   var groupBottomRight = groupTopLeft! +
    //       Offset(ref.read(groupWidthProvider(key)),
    //           ref.read(groupHeightProvider(key)));
    //   var overlap = getOverlapPercent(
    //       cardTopLeft, cardBottomRight, groupTopLeft, groupBottomRight);
    //   var x = overlap.xPer;
    //   var y = overlap.yPer;
    //   if (x == 1 && y == 1) {
    //     ref.read(groupPositionMapProvider.notifier).update((state) {
    //       groups[key]?.cards[widget.cardKey] =
    //           ref.read(cardPositionMapProvider)[widget.cardKey]!;
    //       state = groups;
    //       return state;
    //     });
    //   }
    // }
  }

  void updateNodeKey(bool notSetStarNode) {
    if (notSetStarNode) {
      ref.read(startKeyProvider.notifier).update((state) => widget.cardKey);
      ref.read(notSetStartNodeProvider.notifier).update((state) => false);
    } else {
      ref.read(endKeyProvider.notifier).update((state) => widget.cardKey);
      ref.read(notSetStartNodeProvider.notifier).update((state) => true);
    }
  }

  void updateCardPosition(DraggableDetails details) {
    // var positions = ref.read(cardPositionMapProvider);
    // positions[widget.cardKey]?.position = details.offset;

    // positions[widget.cardKey]?.inputNode.position =
    //     details.offset + const Offset(0, 100);
    // positions[widget.cardKey]?.outputNode.position =
    //     details.offset + const Offset(200, 100);

    // ref.read(cardPositionMapProvider.notifier).update((state) {
    //   state = Map.from(positions);
    //   return state;
    // });
  }

  setChildByType(GlobalKey key) {
    switch (ref.watch(cardTypeProvider(key))) {
      case CardType.simple:
        return const Row(
          children: [
            Icon(Icons.abc),
            Text("data"),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.check_circle),
              ),
            ),
          ],
        );
      case CardType.complex:
        return const ListTile(
          title: Text("Title1"),
          subtitle: Text("SubTitle1"),
        );
      default:
    }
  }

  Overlap getOverlapPercent(Offset cardTopLeft, Offset cardBottomRight,
      Offset groupTopLeft, Offset groupBottomRight) {
    var xPer = 0.0;
    var yPer = 0.0;

    int cardTopLeftDx = cardTopLeft.dx.toInt();
    int cardBottomRightDx = cardBottomRight.dx.toInt();
    int cardTopLeftDy = cardTopLeft.dy.toInt();
    int cardBottomRightDy = cardBottomRight.dy.toInt();
    int groupTopLeftDx = groupTopLeft.dx.toInt();
    int groupBottomRightDx = groupBottomRight.dx.toInt();
    int groupTopLeftDy = groupTopLeft.dy.toInt();
    int groupBottomRightDy = groupBottomRight.dy.toInt();

    var cardX = [for (int i = cardTopLeftDx; i < cardBottomRightDx + 1; i++) i];
    var cardY = [for (int i = cardTopLeftDy; i < cardBottomRightDy + 1; i++) i];
    var groupX = [
      for (int i = groupTopLeftDx; i < groupBottomRightDx + 1; i++) i
    ];
    var groupY = [
      for (int i = groupTopLeftDy; i < groupBottomRightDy + 1; i++) i
    ];

    var xList = [cardX, groupX];
    var yList = [cardY, groupY];

    var xOverlap = xList
        .fold(xList.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .length;
    var xTotal = min(cardBottomRightDx - cardTopLeftDx,
            groupBottomRightDx - groupTopLeftDx) +
        1;
    var yOverlap = yList
        .fold(yList.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .length;
    var yTotal = min(cardBottomRightDy - cardTopLeftDy,
            groupBottomRightDy - groupTopLeftDy) +
        1;

    xPer = xOverlap / xTotal;
    yPer = yOverlap / yTotal;

    return Overlap(xPer: xPer, yPer: yPer);
  }
}
