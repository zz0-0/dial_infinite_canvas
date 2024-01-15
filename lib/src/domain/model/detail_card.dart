import 'package:flutter/material.dart';
import 'package:aimed_infinite_canvas/src/domain/model/node.dart';

class DetailCard {
  DetailCard({
    required this.key,
    required this.title,
    required this.nodes,
  });

  final LocalKey key;
  final List<Node> nodes;
  final String title;
}
