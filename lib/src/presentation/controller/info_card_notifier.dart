import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';

class InfoCardNotifier extends StateNotifier<InfoCard> {
  InfoCardNotifier(super.state);

  void updatePosition(Offset offset) {
    state = state.copyWith(position: offset);
  }

  void inputNode() {}

  void outputNode() {}
}
