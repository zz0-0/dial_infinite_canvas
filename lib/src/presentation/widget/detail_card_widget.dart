import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';

class DetailCardWidget extends ConsumerStatefulWidget {
  final GlobalKey cardKey;
  const DetailCardWidget({
    super.key,
    required this.cardKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailCardWidgetState();
}

class _DetailCardWidgetState extends ConsumerState<DetailCardWidget> {
  @override
  Widget build(BuildContext context) {
    // var cardKey = ref.watch(cardKeyProvider);
    var notSetStarNode = ref.watch(notSetStartNodeProvider);
    const sizedBox = SizedBox(
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
    );
    return Stack(
      children: [
        Draggable(
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
        GestureDetector(
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
