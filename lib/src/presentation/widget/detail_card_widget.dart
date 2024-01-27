import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailCardWidget extends ConsumerStatefulWidget {
  Function callback;

  DetailCardWidget({
    super.key,
    required this.callback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailCardWidgetState();
}

class _DetailCardWidgetState extends ConsumerState<DetailCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text("Title"),
              subtitle: Text("SubTitle"),
            ),
            GestureDetector(
              onTapDown: (details) {
                widget.callback(details.globalPosition);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
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
