import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/domain/model/detail_card.dart';

class CardRenderer extends ConsumerStatefulWidget {
  const CardRenderer({
    super.key,
    required this.cards,
  });

  final List<DetailCard> cards;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardRendererState();
}

class _CardRendererState extends ConsumerState<CardRenderer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
