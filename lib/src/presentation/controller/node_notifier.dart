import 'package:dial_infinite_canvas/src/domain/model/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodeNotifier extends StateNotifier<Node> {
  NodeNotifier(super.state);

  void updatePosition(Offset offset) {
    state = state.copyWith(position: offset);
  }
}
