import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import './sounds.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class SavedSounds extends StatefulWidget {
  const SavedSounds({Key? key}) : super(key: key);

  @override
  State<SavedSounds> createState() => _SavedSoundsState();
}

final AudioPlayer player = AudioPlayer();

class _SavedSoundsState extends State<SavedSounds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
            addAutomaticKeepAlives: false,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onLongPress: () async {
                          String nigma = saved[index]['link'].toString();
                          final bytes =
                              await rootBundle.load('assets/' + nigma);
                          final list = bytes.buffer.asUint8List();

                          final tempDir = await getTemporaryDirectory();
                          final file =
                              await File('${tempDir.path}/' + nigma).create();
                          file.writeAsBytesSync(list);
                          Share.shareFiles(['${file.path}']);
                        },
                        leading: const Icon(Icons.play_arrow_rounded),
                        trailing: IconButton(
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                saved.remove(saved[index]);
                                write(jsonEncode(saved));
                              });
                            },
                            icon: const Icon(Icons.favorite)),
                        title: Text(saved[index]['title'].toString()),
                        onTap: () async {
                          await player.setAsset(
                              'assets/' + saved[index]['link'].toString());
                          player.play();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: saved.length),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 39, 176, 142),
            title: const Text('Favourite sounds')));
  }
}
