import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Background extends ConsumerStatefulWidget {
  const Background({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BackgroundState();
}

class _BackgroundState extends ConsumerState<Background> {
  @override
  Widget build(BuildContext context) {
    return const GridPaper(
      divisions: 2,
      subdivisions: 2,
    );
  }
}
