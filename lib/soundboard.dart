import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import './sounds.dart';

import './savedSounds.dart';
//Sharing files
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
//Storing saved list
import 'utils.dart';
//Scrolling
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:get/get.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Storing data and Loading it

  //

  List searchList = soundBoard;
  // final alreadySaved = false;
  final TextEditingController _textEditingController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  @override
  void initState() {
    read();
    readBox();
    sliderreadBox();

    player1.setVolume(box.read('slider1') as double);
    player1.setPitch(box.read('slider2') as double);
    super.initState();
  }

  void scrollToIndex(int index) {
    try {
      itemScrollController.scrollTo(
          index: index,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    } catch (e) {
      itemScrollController.scrollTo(
          index: 0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    }
  }

  checker(String check) {
    bool truefalse = false;
    for (var map in saved) {
      if (map["title"] == check) {
        // your list of map contains key "title" which has value yep2
        truefalse = true;
      } else {}
    }
    return truefalse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            box.read('searchbar')
                ? SizedBox(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.green[400]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchList = [];
                                  for (var map in soundBoard) {
                                    if (map["title"]!
                                        .contains(value.toLowerCase())) {
                                      // your list of map contains key "title" which has value yep2
                                      searchList.add(map);
                                    }
                                  }
                                });
                              },
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search a specific sound!'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 50,
                  )
                : Container(
                    height: 0,
                  ),
            Expanded(
              child: StreamBuilder<Object>(
                  stream: Stream.fromFuture(read()),
                  builder: (context, snapshot) {
                    return ScrollablePositionedList.separated(
                        itemScrollController: itemScrollController,
                        addAutomaticKeepAlives: false,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onLongPress: () async {
                                      String nigma =
                                          searchList[index]['link'].toString();
                                      final bytes = await rootBundle
                                          .load('assets/' + nigma);
                                      final list = bytes.buffer.asUint8List();

                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final file =
                                          await File('${tempDir.path}/' + nigma)
                                              .create();
                                      file.writeAsBytesSync(list);
                                      Share.shareFiles(['${file.path}']);
                                    },
                                    leading:
                                        const Icon(Icons.play_arrow_rounded),
                                    trailing: IconButton(
                                        color: Colors.red,
                                        onPressed: () async {
                                          if (checker(
                                              (searchList[index]['title']))) {
                                            setState(() {
                                              saved.removeWhere(((element) =>
                                                  element['title'] ==
                                                  searchList[index]['title']));
                                              write(jsonEncode(saved));
                                            });
                                          } else {
                                            setState(() {
                                              saved.add(searchList[index]);
                                              write(jsonEncode(saved));
                                            });
                                          }
                                        },
                                        icon: checker(
                                                (searchList[index]['title']))
                                            ? const Icon(Icons.favorite)
                                            : const Icon(
                                                Icons.favorite_border)),
                                    title: Text(
                                        searchList[index]['title'].toString()),
                                    onTap: () async {
                                      Get.closeCurrentSnackbar();
                                      var duration = await player1.setAsset(
                                          'assets/' +
                                              searchList[index]['link']
                                                  .toString());
                                      Get.snackbar('Playing:',
                                          '${searchList[index]['title']}',
                                          duration: duration,
                                          backgroundColor: Colors.lightGreen
                                              .withOpacity(0.5),
                                          animationDuration:
                                              Duration(milliseconds: 570),
                                          mainButton: TextButton(
                                            onPressed: () {
                                              player1.stop();
                                              Get.closeCurrentSnackbar();
                                            },
                                            child: const Text(
                                              'STOP',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ));
                                      player1.play();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: searchList.length);
                  }),
            ),
          ],
        ),
        //  Column(
        //   children: [
        //     ElevatedButton(
        //         onPressed: () async {
        //           await player1.setUrl(
        //               'https://admiralbullbot.github.io/playsounds/files/new/archbalanced.ogg');
        //           player1.play();
        //         },
        //         child: Text('Fus Ro Dah')),
        //   ],
        // ),
        appBar: AppBar(
            actions: [
              PopupMenuButton(
                  onSelected: (value) {
                    if (value == 2) {
                      scrollToIndex(0);
                    } else if (value == 3) {
                      scrollToIndex(7);
                    } else if (value == 4) {
                      scrollToIndex(41);
                    } else if (value == 5) {
                      scrollToIndex(189);
                    } else if (value == 6) {
                      scrollToIndex(221);
                    } else if (value == 7) {
                      scrollToIndex(237);
                    } else if (value == 8) {
                      scrollToIndex(247);
                    } else if (value == 9) {
                      scrollToIndex(305);
                    } else if (value == 10) {
                      scrollToIndex(326);
                    } else if (value == 11) {
                      scrollToIndex(353);
                    } else if (value == 12) {
                      scrollToIndex(371);
                    } else if (value == 13) {
                      scrollToIndex(383);
                    } else if (value == 14) {
                      scrollToIndex(396);
                    } else if (value == 15) {
                      scrollToIndex(427);
                    } else if (value == 16) {
                      scrollToIndex(463);
                    } else if (value == 17) {
                      scrollToIndex(473);
                    } else if (value == 18) {
                      scrollToIndex(491);
                    } else if (value == 19) {
                      scrollToIndex(532);
                    } else if (value == 20) {
                      scrollToIndex(535);
                    }
                  },
                  itemBuilder: ((context) => [
                        const PopupMenuItem(
                          child: Text('Arch The Racist'),
                          value: 2,
                        ),
                        const PopupMenuItem(
                          child: const Text('Bulldogs stream'),
                          value: 3,
                        ),
                        const PopupMenuItem(
                          child: const Text('Bulldogs voice'),
                          value: 4,
                        ),
                        const PopupMenuItem(
                          child: const Text('Dota'),
                          value: 5,
                        ),
                        const PopupMenuItem(
                          child: const Text('Dr. Disrespect'),
                          value: 6,
                        ),
                        const PopupMenuItem(
                          child: const Text('Gaben'),
                          value: 7,
                        ),
                        const PopupMenuItem(
                          child: const Text('Gachimuchi'),
                          value: 8,
                        ),
                        const PopupMenuItem(
                          child: const Text('Online video'),
                          value: 9,
                        ),
                        const PopupMenuItem(
                          child: const Text('Raeyei'),
                          value: 10,
                        ),
                        const PopupMenuItem(
                          child: const Text('Songs'),
                          value: 11,
                        ),
                        const PopupMenuItem(
                          child: const Text('Spider-Man'),
                          value: 12,
                        ),
                        const PopupMenuItem(
                          child: const Text('Trump'),
                          value: 13,
                        ),
                        const PopupMenuItem(
                          child: const Text('Twitch'),
                          value: 14,
                        ),
                        const PopupMenuItem(
                          child: const Text('Ugandan'),
                          value: 15,
                        ),
                        const PopupMenuItem(
                          child: const Text('Unreal Tournament'),
                          value: 16,
                        ),
                        const PopupMenuItem(
                          child: const Text('Video Games'),
                          value: 17,
                        ),
                        const PopupMenuItem(
                          child: const Text('Weeb'),
                          value: 18,
                        ),
                        const PopupMenuItem(
                          child: const Text('YouTube megacucks'),
                          value: 19,
                        ),
                        const PopupMenuItem(
                          child: const Text('Other'),
                          value: 20,
                        ),
                      ]))
            ],
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 39, 176, 142),
            title: const Text('Admiralbulldog Soundboard')));
  }
}
