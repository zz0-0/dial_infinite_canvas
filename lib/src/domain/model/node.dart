import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Node extends Equatable {
  const Node({
    required this.key,
    required this.position,
  });

  final GlobalKey key;
  final Offset position;

  Node copyWith({GlobalKey? key, Offset? position}) {
    return Node(key: key ?? this.key, position: position ?? this.position);
  }

  @override
  List<Object?> get props => [key, position];
}
