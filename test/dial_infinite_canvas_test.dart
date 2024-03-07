import 'package:dial_infinite_canvas/dial_infinite_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("InfiniteCanvas showed", (widgetTester) async {
    await widgetTester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: InfiniteCanvas(),
      ),
    );
  });
}
