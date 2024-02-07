import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/resizer.dart';

class DetailCard extends ConsumerStatefulWidget {
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

  const DetailCard({
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
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailCardState();
}

enum CardType {
  simple("Simple"),
  complex("Complex");

  const CardType(this.label);
  final String label;
}

class _DetailCardState extends ConsumerState<DetailCard> {
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
                .read(cardTypeProvider.notifier)
                .update((state) => state = value!),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: setChildByType(),
          )
        ],
      ),
    );
    return Stack(
      children: [
        Resizer(
          child: Draggable(
            feedback: sizedBox,
            onDragEnd: (details) {
              var positions = ref.read(cardPositionMapProvider);
              positions[widget.cardKey] = details.offset;

              ref.read(cardPositionMapProvider.notifier).update((state) {
                state = Map.from(positions);
                return state;
              });
            },
            child: sizedBox,
          ),
        ),
        Positioned(
          bottom: 100,
          right: 0,
          child: GestureDetector(
            onTapDown: (details) {
              if (notSetStarNode) {
                ref
                    .read(startKeyProvider.notifier)
                    .update((state) => widget.cardKey);
                ref
                    .read(notSetStartNodeProvider.notifier)
                    .update((state) => false);
              } else {
                ref
                    .read(endKeyProvider.notifier)
                    .update((state) => widget.cardKey);
                ref
                    .read(notSetStartNodeProvider.notifier)
                    .update((state) => true);
              }
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
      ],
    );
  }

  setChildByType() {
    switch (ref.watch(cardTypeProvider)) {
      case CardType.simple:
        return const Row(
          children: [
            Icon(Icons.abc),
            Text("data"),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.check_circle)))
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
}
