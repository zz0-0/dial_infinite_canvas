import 'package:flutter/material.dart';

class DetailCard {
  DetailCard({
    required this.key,
    required this.position,
    required this.height,
    required this.width,
  });

  final LocalKey key;
  final Offset position;
  final double height;
  final double width;
}
