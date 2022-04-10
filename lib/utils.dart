import './sounds.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:get_storage/get_storage.dart';

final AudioPlayer player1 = AudioPlayer();

final box = GetStorage();

void readBox() {
  if (box.read('searchbar') == null) {
    box.write('searchbar', false);
    print('Box made');
  }
  print('Box already made');
}

void sliderreadBox() {
  if (box.read('slider1') == null || box.read('slider2') == null) {
    box.write('slider1', 1.0);
    box.write('slider2', 1.0);
  }
}

write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/my_file123.txt');
  await file.writeAsString(text);
}

Future<String> read() async {
  String text = '[{}]';
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file123.txt');
    text = await file.readAsString();
    saved = jsonDecode(text);
  } catch (e) {}
  return text;
}
