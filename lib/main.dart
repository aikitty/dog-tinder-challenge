// https://dog.ceo/dog-api

import 'package:dogtinder/consts.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'actions.dart' as actions;
import 'consts.dart';

// notes to self
// - try paging (ie, load multiple images at a time, then load a new batch when user reaches end)
// - icons with animation (ie, a heart that fades/transitions when user swipes right)

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Tinder',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Tinder for Dogs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageUrl = "";
  String dogName = "random name";
  int personalityIndex = Random().nextInt(9);

  // note to self - you were troubleshooting why the non-image profile data flashes/updates multiple times on swipe

  void _updateDogData() async {
    var url = await actions.getRandomImage();
    setState(() {
      imageUrl = url;
      personalityIndex = Random().nextInt(9);
      print('set state');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        _updateDogData();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: FutureBuilder<String>(
            future: actions.getRandomImage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                // todo: make loading pretty...
                return (const Text('loading...'));
              } else {
                imageUrl = snapshot.data.toString();
                personalityIndex = Random().nextInt(9);

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        dogName,
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.blueGrey.shade100,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial'),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          kProfiles[personalityIndex]["profile"],
                          style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial'),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
