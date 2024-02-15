import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Edge extends Equatable {
  const Edge({
    required this.sourceCard,
    required this.targetCard,
    required this.sourceNode,
    required this.targetNode,
  });

  final GlobalKey sourceCard;
  final GlobalKey targetCard;

  final GlobalKey sourceNode;
  final GlobalKey targetNode;

  @override
  List<Object?> get props => [sourceCard, targetCard, sourceNode, targetNode];
}
