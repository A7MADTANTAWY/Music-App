import 'package:audio_player/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AudioPlayer());
}

class AudioPlayer extends StatelessWidget {
  const AudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
