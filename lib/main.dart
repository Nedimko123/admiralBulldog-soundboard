import 'package:flutter/material.dart';
import './soundboard.dart';
//Storing saved list

void main() async {
//Storing saved list
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppStart());
}

class MyAppStart extends StatelessWidget {
  const MyAppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}
