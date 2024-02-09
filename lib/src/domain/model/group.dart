import 'package:flutter/material.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';

class Group {
  Group({
    required this.key,
    required this.position,
    required this.cards,
  });

  final GlobalKey key;
  Offset position;
  final Map<GlobalKey, InfoCard> cards;
}
