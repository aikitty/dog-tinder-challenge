// https://dog.ceo/dog-api

import 'package:dogtinder/consts.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'actions.dart' as actions;
import 'consts.dart';

String imageUrl = "";

// todo list
// - try paging (ie, load multiple images at a time, then load a new batch when user reaches end)
// - show icon on dogs already liked? filter out already seen?
// - animate photo between transitions to look like card getting thrown one way
// - fix loading screen
// - save list of liked dogs

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
  String dogName = "random name";
  var personalityIndex = Random().nextInt(9);
  bool swipeIconVisible = false;
  IconData? icon;

  // todo: this is kind of messy since it sets state 3 times, there may be a
  // cleaner way of achieving this...
  void _updateDogData(IconData newIcon) async {
    var url = await actions.getRandomImage();

    setState(() {
      icon = newIcon;
      swipeIconVisible = true;
    });

    // Delay for icon animation
    Future.delayed(
        const Duration(
            milliseconds: kAnimationDuration + kAnimationDelayIncrement), () {
      setState(() {
        swipeIconVisible = false;
      });

      Future.delayed(const Duration(milliseconds: kAnimationDelayIncrement * 4),
          () {
        setState(() {
          imageUrl = url;
          personalityIndex = Random().nextInt(9);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      actions.getRandomImage().then(
        (val) {
          setState(() {
            imageUrl = val;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == "") {
      return const Text('loading');
    } else {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          // Process swipe right
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            _updateDogData(Icons.favorite);
          } else if (details.velocity.pixelsPerSecond.dx < 0.0) {
            _updateDogData(Icons.heart_broken);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: SizedBox(
                        height: 540,
                        width: 378,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: swipeIconVisible ? .8 : 0.0,
                    duration: const Duration(
                      milliseconds: kAnimationDuration,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.red,
                      size: 300,
                    ),
                  ),
                ],
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
          )),
        ),
      );
    }
  }
}
