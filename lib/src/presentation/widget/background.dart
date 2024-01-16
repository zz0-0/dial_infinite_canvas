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
    return Container(
      width: 200,
      height: 200,
      child: const GridPaper(
        divisions: 2,
        subdivisions: 2,
      ),
    );
  }
}
