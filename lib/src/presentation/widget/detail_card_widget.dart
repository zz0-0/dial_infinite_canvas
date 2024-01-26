import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Point { start, end }

class DetailCardWidget extends ConsumerStatefulWidget {
  Function callback;
  // Point point;

  DetailCardWidget({
    super.key,
    required this.callback,
    // required this.point,
  });

  // get offsetGetter => null;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailCardWidgetState();
}

class _DetailCardWidgetState extends ConsumerState<DetailCardWidget> {
  // final ValueGetter<Offset> offsetGetter = (value) {};
  // late ValueGetter<Offset> offsetGetter;

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
