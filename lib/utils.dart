import './sounds.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

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
