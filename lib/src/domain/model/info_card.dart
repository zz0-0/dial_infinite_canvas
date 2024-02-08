import 'package:flutter/material.dart';
import 'package:aimed_infinite_canvas/src/domain/model/node.dart';

class InfoCard {
  InfoCard({
    required this.key,
    required this.position,
    required this.height,
    required this.width,
    required this.inputNode,
    required this.outputNode,
  });

  final GlobalKey key;
  Offset position;
  double height;
  double width;
  Node inputNode;
  Node outputNode;
}
