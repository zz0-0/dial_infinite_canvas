import 'package:dial_infinite_canvas/src/enum.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/group_widget.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LayoutIdNotifier extends StateNotifier<List<LayoutId>> {
  LayoutIdNotifier() : super([]);

  void addLayoutId(LayoutId layoutId) {
    state = [...state, layoutId];
  }

  void removeLayoutId(GlobalKey key) {
    state = [
      for (final layoutid in state)
        if (layoutid.key != key) layoutid,
    ];
  }

  LayoutId build(GlobalKey key, ResizeType type) {
    return LayoutId(
      id: key,
      child: type == ResizeType.group
          ? GroupWidget(
              groupKey: key,
            )
          : InfoCardWidget(
              cardKey: key,
            ),
    );
  }
}
