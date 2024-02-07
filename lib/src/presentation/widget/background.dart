import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimed_infinite_canvas/src/provider.dart';

class Background extends ConsumerWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var divisions = ref.watch(divisionsProvider);
    var subdivisions = ref.watch(subdivisionsProvider);

    return GridPaper(
      divisions: divisions,
      subdivisions: subdivisions,
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
