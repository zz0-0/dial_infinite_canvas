import 'package:aimed_infinite_canvas/src/domain/model/node.dart';

class Edge {
  Edge({
    required this.sourceNode,
    required this.targetNode,
  });

  final Node sourceNode;
  final Node targetNode;
}
