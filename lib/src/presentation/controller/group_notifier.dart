import 'package:dial_infinite_canvas/src/domain/model/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupNotifier extends StateNotifier<Group> {
  GroupNotifier(super.state);

  void updatePosition(Offset offset) {
    state = state.copyWith(position: offset);
  }

  void addCard(GlobalKey key) {
    final Set<GlobalKey> newCards = Set.from(state.cards);
    newCards.add(key);
    state = state.copyWith(cards: newCards);
  }

  void removeCard(GlobalKey key) {
    final Set<GlobalKey> newCards = Set.from(state.cards);
    newCards.remove(key);
    state = state.copyWith(cards: newCards);
  }
}
