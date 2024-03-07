import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Group extends Equatable {
  const Group({
    required this.key,
    required this.position,
    required this.cards,
  });

  final GlobalKey key;
  final Offset position;
  final Set<GlobalKey> cards;

  Group copyWith({GlobalKey? key, Offset? position, Set<GlobalKey>? cards}) {
    return Group(
      key: key ?? this.key,
      position: position ?? this.position,
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [key, position, cards];
}
