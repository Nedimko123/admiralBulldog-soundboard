import 'package:flutter/material.dart';
import 'package:kviz/savedSounds.dart';
import 'package:kviz/slider.dart';
import './soundboard.dart';
//Storing saved list
import 'package:get_storage/get_storage.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() async {
//Storing saved list
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyAppStart());
}

class MyAppStart extends StatefulWidget {
  const MyAppStart({Key? key}) : super(key: key);

  @override
  State<MyAppStart> createState() => _MyAppStartState();
}

class _MyAppStartState extends State<MyAppStart> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List screens = [
    const MyApp(),
    const SavedSounds(),
    const SoundSlider(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          colorSchemeSeed: Colors.lightGreen,
          brightness: Brightness.light,
          useMaterial3: true),
      darkTheme: ThemeData(
          colorSchemeSeed: Colors.lightGreen,
          useMaterial3: true,
          brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: _page,
          height: 58,
          backgroundColor: Colors.green.shade300,
          items: <Widget>[
            const Icon(
              Icons.play_arrow_rounded,
              size: 30,
              color: Colors.white,
            ),
            const Icon(
              Icons.favorite,
              size: 30,
              color: Colors.white,
            ),
            const Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
            //Handle button tap
          },
          color: Colors.green.shade400,
        ),
        body: screens[_page],
      ),
    );
  }
}
