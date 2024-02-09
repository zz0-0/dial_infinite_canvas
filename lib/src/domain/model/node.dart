import 'package:flutter/material.dart';

class Node {
  Node({
    required this.key,
    required this.position,
  });

  final GlobalKey key;
  Offset position;
}
