import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aimed_infinite_canvas/aimed_infinite_canvas.dart';

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
