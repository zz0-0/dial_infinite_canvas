import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCardWidget extends ConsumerStatefulWidget {
  final GlobalKey cardKey;
  final Function callback;

  const DetailCardWidget({
    super.key,
    required this.cardKey,
    required this.callback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailCardWidgetState();
}

class _DetailCardWidgetState extends ConsumerState<DetailCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Card(
        child: Column(
          children: [
            const ListTile(
              title: Text("Title"),
              subtitle: Text("SubTitle"),
            ),
            GestureDetector(
              onTapDown: (details) {
                widget.callback(widget.cardKey);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
