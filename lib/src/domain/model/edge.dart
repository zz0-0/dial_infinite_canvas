import 'package:flutter/material.dart';
import 'package:aimed_infinite_canvas/src/domain/model/node.dart';

class Edge {
  Edge({
    required this.sourceCardKey,
    required this.targetCardKey,
    required this.sourceNode,
    required this.targetNode,
  });

  final GlobalKey sourceCardKey;
  final GlobalKey targetCardKey;

  final Node sourceNode;
  final Node targetNode;
}
