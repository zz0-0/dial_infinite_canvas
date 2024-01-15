import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/domain/model/edge.dart';

class EdgeRenderer extends ConsumerStatefulWidget {
  const EdgeRenderer({
    super.key,
    required this.edges,
  });

  final List<Edge> edges;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EdgeRendererState();
}

class _EdgeRendererState extends ConsumerState<EdgeRenderer> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint();
  }
}
