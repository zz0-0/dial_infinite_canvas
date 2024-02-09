import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/provider.dart';
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
            onDragEnd: (details) {
              var positions = ref.read(cardPositionMapProvider);
              positions[widget.cardKey]?.position = details.offset;

              positions[widget.cardKey]?.inputNode.position =
                  details.offset + const Offset(0, 100);
              positions[widget.cardKey]?.outputNode.position =
                  details.offset + const Offset(200, 100);

              ref.read(cardPositionMapProvider.notifier).update((state) {
                state = Map.from(positions);
                return state;
              });
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
        ),
        Positioned(
          top: 100,
          right: 0,
          child: InkWell(
            mouseCursor: SystemMouseCursors.alias,
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
        ),
      ],
    );
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
