import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/domain/model/group.dart';

class GroupNotifier extends StateNotifier<Group> {
  GroupNotifier(super.state);

  void updatePosition(Offset offset) {
    state = state.copyWith(position: offset);
  }

  void addCard(GlobalKey key) {
    state.cards.add(key);
    state = state.copyWith(cards: state.cards);
  }

  void removeCard(GlobalKey key) {
    state.cards.remove(key);
    state = state.copyWith(cards: state.cards);
  }
}
