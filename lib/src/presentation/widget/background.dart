import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Background extends ConsumerWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GridPaper(
      divisions: 2,
      subdivisions: 2,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
