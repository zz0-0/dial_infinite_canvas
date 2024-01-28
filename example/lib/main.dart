import 'package:flutter/material.dart';
import 'package:aimed_infinite_canvas/aimed_infinite_canvas.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: InfiniteCanvas(),
      ),
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}

// ListenableBuilder(
//   listenable: controller,
//   builder: (context, child) {
//     final viewport = Offset.zero & constraints.biggest;
//     final r = Rect.fromPoints(
//             controller.toScene(viewport.topLeft),
//             controller.toScene(viewport.bottomRight))
//         .translate(-cx, -cy);

//     return Text(
//       '${r.topLeft}\n${r.size}\ntop:$cardtop,left:$cardleft',
//     );
//   },
// ),