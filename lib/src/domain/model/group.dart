import 'package:flutter/material.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';

class Group {
  Group({
    required this.key,
    required this.cards,
  });

  final LocalKey key;
  final List<InfoCard> cards;
}
