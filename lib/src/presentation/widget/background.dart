import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Background extends ConsumerWidget {
  Background({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridPaper(
      divisions: 2,
      subdivisions: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
