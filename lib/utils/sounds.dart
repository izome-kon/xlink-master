import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';

class Sounds {
  static void loadSound() async {
    List<String> soundsNames = [
      "Button-click-sound.mp3",
      "Button-click-sound-effect.mp3",
      "Box-drop-sound-effect.mp3",
      "Electric-spark-sound-effect.mp3",
      "Error-beep-sound-effect.mp3",
      "Error-sound.mp3"
    ];
    for (int i = 0; i < soundsNames.length; i++) {
      final ByteData data =
          await rootBundle.load('assets/audios/${soundsNames[i]}');
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/${soundsNames[i]}');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      mp3Uri.add(tempFile.uri.toString());
    }
  }

  static List<String> mp3Uri = [];

  static void playSound(int i) {
    AudioPlayer player = AudioPlayer();
    player.stop();
    player.play(mp3Uri[i]);
    //
  }
}
