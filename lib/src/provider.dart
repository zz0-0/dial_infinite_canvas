import 'package:dial_infinite_canvas/src/domain/model/edge.dart';
import 'package:dial_infinite_canvas/src/domain/model/group.dart';
import 'package:dial_infinite_canvas/src/domain/model/info_card.dart';
import 'package:dial_infinite_canvas/src/domain/model/node.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/group_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/info_card_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/layout_id_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/controller/node_notifier.dart';
import 'package:dial_infinite_canvas/src/presentation/widget/info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// default
final menuLeftPositionProvider = StateProvider<double>((ref) => 10);
final menuBottomPositionProvider = StateProvider<double>((ref) => 10);
final canvasHeightProvider = StateProvider<double>((ref) => 1000.0);
final canvasWidthProvider = StateProvider<double>((ref) => 1000.0);
final divisionsProvider = StateProvider<int>((ref) => 2);
final subdivisionsProvider = StateProvider<int>((ref) => 2);

// resize
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
final connectedNodeListProvider = StateProvider<Set<Edge>>((ref) => <Edge>{});
final mouseXProvider = StateProvider((ref) => 0.0);
final mouseYProvider = StateProvider((ref) => 0.0);
final nodeProvider =
    StateNotifierProvider.family<NodeNotifier, Node, GlobalKey>((ref, key) {
  return NodeNotifier(Node(key: key, position: Offset.infinite));
});

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
      height: 0,
      width: 0,
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

// card border
final cardSelectedProvider =
    StateProvider.family<bool, GlobalKey>((ref, key) => false);
