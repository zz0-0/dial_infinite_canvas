import 'dart:math';

import 'package:dial_infinite_canvas/src/domain/model/overlap.dart';
import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/resizer.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

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
    final bool selected = ref.watch(cardSelectedProvider(widget.cardKey));
    final notSetStarNode = ref.watch(notSetStartNodeProvider);
    // card 1
    final column = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "data",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
              PopupMenuButton(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings'}.map((String value) {
                    return PopupMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: setChildByType(widget.cardKey),
          ),
        ],
      ),
    );

    // card with background image
    final column1 = Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://picsum.photos/250?image=9"),
            ),
          ),
        ),
        const Positioned(
          bottom: -4,
          left: -4,
          width: 200,
          height: 65,
          child: Card(
              // height: 20,
              // decoration: const BoxDecoration(color: Colors.white),
              ),
        ),
      ],

      // simple card with title and content
    );

    const column2 = Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "data",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          ReadMoreText(
            'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
          ),
        ],
      ),
    );

    final sizedBox = Card(
      shape: selected
          ? RoundedRectangleBorder(
              side: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            )
          : null,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          ref
              .read(cardSelectedProvider(widget.cardKey).notifier)
              .update((state) => true);
        },
        child: column2,
      ),
    );
    return Stack(
      children: [
        Resizer(
          cardKey: widget.cardKey,
          type: ResizeType.card,
          child: Draggable(
            feedback: sizedBox,
            onDragUpdate: (details) {},
            onDragEnd: (details) {
              updateCardPosition(details);
              detectOverlapping(details);
            },
            childWhenDragging: sizedBox,
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
          left: 190,
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

  void detectOverlapping(DraggableDetails details) {
    final Offset cardTopLeft = details.offset;
    final Offset cardBottomRight = cardTopLeft +
        Offset(
          ref.watch(cardWidthProvider(widget.cardKey)),
          ref.watch(cardHeightProvider(widget.cardKey)),
        );
    final layoutIds = ref.watch(groupLayoutProvider);
    for (final layoutId in layoutIds) {
      final groupKey = layoutId.id as GlobalKey;
      final groupTopLeft = ref.watch(groupProvider(groupKey)).position;

      final groupBottomRight = groupTopLeft +
          Offset(
            ref.watch(groupWidthProvider(groupKey)),
            ref.watch(groupHeightProvider(groupKey)),
          );
      final overlap = getOverlapPercent(
        cardTopLeft,
        cardBottomRight,
        groupTopLeft,
        groupBottomRight,
      );
      final x = overlap.xPer;
      final y = overlap.yPer;
      if (x == 1 && y == 1) {
        ref.read(groupProvider(groupKey).notifier).addCard(widget.cardKey);
      } else {
        ref.read(groupProvider(groupKey).notifier).removeCard(widget.cardKey);
      }
    }
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
    ref
        .read(cardProvider(widget.cardKey).notifier)
        .updatePosition(details.offset);

    final card = ref.watch(cardProvider(widget.cardKey));
    ref
        .read(nodeProvider(card.inputNode).notifier)
        .updatePosition(details.offset + const Offset(0, 100));
    ref
        .read(nodeProvider(card.outputNode).notifier)
        .updatePosition(details.offset + const Offset(200, 100));
  }

  Widget setChildByType(GlobalKey key) {
    switch (ref.watch(cardTypeProvider(key))) {
      case CardType.simple:
        return const Column();

      // const Row(
      //   children: [
      //     Icon(Icons.abc),
      //     Text("data"),
      //     Expanded(
      //       child: Align(
      //         alignment: Alignment.centerRight,
      //         child: Icon(Icons.check_circle),
      //       ),
      //     ),
      //   ],
      // );
      case CardType.complex:
        return const ListTile(
          title: Text("Title1"),
          subtitle: Text("SubTitle1"),
        );
      default:
    }
    return Container();
  }

  Overlap getOverlapPercent(
    Offset cardTopLeft,
    Offset cardBottomRight,
    Offset groupTopLeft,
    Offset groupBottomRight,
  ) {
    var xPer = 0.0;
    var yPer = 0.0;

    final int cardTopLeftDx = cardTopLeft.dx.toInt();
    final int cardBottomRightDx = cardBottomRight.dx.toInt();
    final int cardTopLeftDy = cardTopLeft.dy.toInt();
    final int cardBottomRightDy = cardBottomRight.dy.toInt();
    final int groupTopLeftDx = groupTopLeft.dx.toInt();
    final int groupBottomRightDx = groupBottomRight.dx.toInt();
    final int groupTopLeftDy = groupTopLeft.dy.toInt();
    final int groupBottomRightDy = groupBottomRight.dy.toInt();

    final cardX = [
      for (int i = cardTopLeftDx; i < cardBottomRightDx + 1; i++) i,
    ];
    final cardY = [
      for (int i = cardTopLeftDy; i < cardBottomRightDy + 1; i++) i,
    ];
    final groupX = [
      for (int i = groupTopLeftDx; i < groupBottomRightDx + 1; i++) i,
    ];
    final groupY = [
      for (int i = groupTopLeftDy; i < groupBottomRightDy + 1; i++) i,
    ];

    final xList = [cardX, groupX];
    final yList = [cardY, groupY];

    final xOverlap = xList
        .fold(xList.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .length;
    final xTotal = min(
          cardBottomRightDx - cardTopLeftDx,
          groupBottomRightDx - groupTopLeftDx,
        ) +
        1;
    final yOverlap = yList
        .fold(yList.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .length;
    final yTotal = min(
          cardBottomRightDy - cardTopLeftDy,
          groupBottomRightDy - groupTopLeftDy,
        ) +
        1;

    xPer = xOverlap / xTotal;
    yPer = yOverlap / yTotal;

    return Overlap(xPer: xPer, yPer: yPer);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }
}
