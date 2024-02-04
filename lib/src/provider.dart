import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/detail_card_widget.dart';
import 'package:aimed_infinite_canvas/src/presentation/widget/interactive_canvas_widget.dart';

final cardKeyProvider = StateProvider<GlobalKey?>((ref) => null);
final startKeyProvider = StateProvider<GlobalKey?>((ref) => null);
final endKeyProvider = StateProvider<GlobalKey?>((ref) => null);
final notSetStartNodeProvider = StateProvider<bool>((ref) => true);
final connectedNodeListProvider =
    StateProvider<List<(GlobalKey, GlobalKey)>>((ref) => []);
final detailCardWidgetListProvider = StateProvider<List<LayoutId>>((ref) => []);
final cardPositionMapProvider =
    StateProvider<Map<GlobalKey, Offset>>((ref) => {});
final edgePainterProvider = Provider(
  (ref) => EdgePainter(
    node: ref.watch(connectedNodeListProvider),
    start: ref.watch(startKeyProvider),
    end: ref.watch(endKeyProvider),
    cardPositions: ref.watch(cardPositionMapProvider),
  ),
);
final scaleProvider = StateProvider((ref) => 1.0);
final transformationControllerProvider = Provider((ref) {
  var scale = ref.watch(scaleProvider);
  TransformationController transformationController =
      TransformationController();
  transformationController.value.scale(scale);
  return transformationController;
});
final cardTypeProvider = StateProvider((ref) => CardType.simple);

// class MyParameter extends Equatable{

// }

// final edgePainterProvider = Provider.family<>((ref, ) {});