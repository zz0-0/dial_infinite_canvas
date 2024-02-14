import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dial_infinite_canvas/src/domain/model/edge.dart';
import 'package:dial_infinite_canvas/src/domain/model/group.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/info_card_widget.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/group_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/layout_id_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/info_card_notifier.dart';

// default
final menuLeftPositionProvider = StateProvider<double>((ref) => 10);
final menuBottomPositionProvider = StateProvider<double>((ref) => 10);
final canvasHeightProvider = StateProvider<double>((ref) => 1000.0);
final canvasWidthProvider = StateProvider<double>((ref) => 1000.0);
final divisionsProvider = StateProvider<int>((ref) => 2);
final subdivisionsProvider = StateProvider<int>((ref) => 2);
final cardHeightProvider =
    StateProvider.family<double, GlobalKey>((ref, key) => 200);
final cardWidthProvider =
    StateProvider.family<double, GlobalKey>((ref, id) => 200);
final groupHeightProvider =
    StateProvider.family<double, GlobalKey>((ref, key) => 600);
final groupWidthProvider =
    StateProvider.family<double, GlobalKey>((ref, id) => 600);

// paint
final startKeyProvider = StateProvider<GlobalKey?>((ref) => null);
final endKeyProvider = StateProvider<GlobalKey?>((ref) => null);
final notSetStartNodeProvider = StateProvider<bool>((ref) => true);
final connectedNodeListProvider = StateProvider<List<Edge>>((ref) => []);
final mouseXProvider = StateProvider((ref) => 0.0);
final mouseYProvider = StateProvider((ref) => 0.0);
// final edgePainterProvider = Provider(
//   (ref) => EdgePainter(
//     node: ref.watch(connectedNodeListProvider),
//     start: ref.watch(startKeyProvider),
//     end: ref.watch(endKeyProvider),
//     cardPositions: ref.watch(cardPositionMapProvider),
//     mouseX: ref.watch(mouseXProvider),
//     mouseY: ref.watch(mouseYProvider),
//   ),
// );

// drag and drop
final cardLayoutProvider =
    StateNotifierProvider<LayoutIdNotifier, List<LayoutId>>(
        (ref) => LayoutIdNotifier());
final cardProvider =
    StateNotifierProvider.family<InfoCardNotifier, InfoCard, GlobalKey>(
        (ref, key) {
  var key1 = GlobalKey();
  var key2 = GlobalKey();
  return InfoCardNotifier(
    InfoCard(
      key: key,
      position: Offset.infinite,
      height: ref.watch(cardHeightProvider(key)),
      width: ref.watch(cardWidthProvider(key)),
      inputNode: key1,
      outputNode: key2,
    ),
  );
});

final groupLayoutProvider =
    StateNotifierProvider<LayoutIdNotifier, List<LayoutId>>(
        (ref) => LayoutIdNotifier());
final groupProvider =
    StateNotifierProvider.family<GroupNotifier, Group, GlobalKey>((ref, key) {
  return GroupNotifier(
    Group(
      key: key,
      position: Offset.infinite,
      cards: const <GlobalKey>{},
    ),
  );
});

// scale
final scaleProvider = StateProvider((ref) => 1.0);
final transformationControllerProvider = Provider((ref) {
  var scale = ref.watch(scaleProvider);
  TransformationController transformationController =
      TransformationController();
  transformationController.value.scale(scale);
  return transformationController;
});

// detail card info
final cardTypeProvider =
    StateProvider.family<CardType, GlobalKey>((ref, id) => CardType.simple);
