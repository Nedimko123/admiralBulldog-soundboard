import 'package:flutter/material.dart';
import 'utils.dart';

class SoundSlider extends StatefulWidget {
  const SoundSlider({Key? key}) : super(key: key);

  @override
  State<SoundSlider> createState() => _SoundSliderState();
}

class _SoundSliderState extends State<SoundSlider> {
  @override
  void initState() {
    readBox();
    sliderreadBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 176, 142),
        title: const Text('Options'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            height: 50,
          ),
          const Text(
            'Change volume',
            style: TextStyle(fontSize: 30),
          ),
          Slider(
            min: 0,
            max: 1,
            value: box.read('slider1') as double,
            onChanged: (value) {
              setState(() {
                box.write('slider1', value);
                player1.setVolume(box.read('slider1'));
              });
            },
            divisions: 10,
            label: "${box.read('slider1')}",
          ),
          const Text(
            'Change pitch',
            style: const TextStyle(fontSize: 30),
          ),
          Slider(
            min: 0.4,
            max: 2,
            value: box.read('slider2') as double,
            divisions: 20,
            label: "${box.read('slider2')}",
            onChanged: (value) {
              setState(() {
                box.write('slider2', value);
                player1.setPitch(box.read('slider2'));
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                box.write('slider1', 1.0);
                box.write('slider2', 1.0);
                player1.setPitch(box.read('slider1'));
                player1.setVolume(box.read('slider2'));
              });
            },
            child: Text(
              'Reset sliders',
              style: const TextStyle(fontSize: 30),
            ),
          ),
          Container(
            height: 20,
          ),
          Text('Search bar visibility', style: const TextStyle(fontSize: 30)),
          Switch(
              value: box.read('searchbar'),
              activeColor: Colors.red.shade200,
              onChanged: (value) {
                if (box.read('searchbar') == true) {
                  setState(() {
                    box.write('searchbar', false);
                  });
                } else {
                  setState(() {
                    box.write('searchbar', true);
                  });
                }
              }),
        ],
      )),
    );
  }
}
