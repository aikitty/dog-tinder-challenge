import 'dart:math';

import 'package:dogtinder/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'actions.dart' as actions;
import 'favorites_page.dart';
import 'about_page.dart';
import 'consts.dart';
import 'dog.dart';

List<String> dogBreeds = ["All Breeds"];
String breedDropdownValue = "All Breeds";
List<DropdownMenuItem<String>> dogSubBreeds = [];
String subbreedDropdownValue = "All Sub-Breeds";

// todo list
// - fix loading screen
// - finish sub-breed filter
// - MAJOR clean up and refactoring....

// outstanding issues
// - occasional gesture detector issues...
// - maybe add a skip button?
// - try paging (ie, load multiple images at a time, then load a new batch when user reaches end)
// - animate photo between transitions
// - refactoring... so much refactoring
// - caching dog breed list
// - other UX stuff: add loading indication between dogs, text looks like it's not anti-aliased?, find out why there's a big space between profile/favorites icons

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
          textTheme: GoogleFonts.openSansTextTheme()),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool swipeIconVisible = false;
  bool profileIconVisible = true;
  Map<String, Dog> seenDogs = {};
  var currentDog = Dog();
  List<String> currentFilterUnseenImageUrls = [];
  bool isLastDogInFilter = false;

  void _getSubBreedDropdrownList() async {
    var subBreeds = await actions.getDogSubBreeds('mastiff');

    // dogSubBreeds = subBreeds.map((String items) {
    //   return DropdownMenuItem(
    //     value: items,
    //     child: Text(items),
    //   );
    // }).toList();
    dogSubBreeds = [];
    List<String> p = [
      "All Sub-Breeds",
    ];
    p.addAll(subBreeds);
    dogSubBreeds = p.map((String items) {
      return DropdownMenuItem(value: items, child: Text(items));
    }).toList();
  }

  Future<String> _getNextImageUrl(
      String? newBreedDropdownValue, bool isOnLastDog) async {
    String url = currentDog.getImageUrl();

    if ((newBreedDropdownValue == null &&
            (breedDropdownValue.isEmpty ||
                breedDropdownValue == "All Breeds")) ||
        newBreedDropdownValue == "All Breeds") {
      url = await actions.getRandomImage();
      currentFilterUnseenImageUrls = [];
      isLastDogInFilter = false;
    } else {
      if (!isLastDogInFilter) {
        if ((currentFilterUnseenImageUrls.isEmpty && !isLastDogInFilter) ||
            (newBreedDropdownValue != null &&
                newBreedDropdownValue != breedDropdownValue)) {
          var fulllist =
              await actions.getImagesByBreed(newBreedDropdownValue.toString());

          if (fulllist.isNotEmpty) {
            currentFilterUnseenImageUrls = [
              fulllist[0],
              fulllist[1],
              fulllist[2],
              fulllist[3],
              fulllist[4],
              fulllist[5]
            ];
          }
        }

        if (!isLastDogInFilter && currentFilterUnseenImageUrls.isNotEmpty) {
          url = currentFilterUnseenImageUrls[
              currentFilterUnseenImageUrls.length == 1
                  ? 0
                  : Random().nextInt(currentFilterUnseenImageUrls.length - 1)];

          currentFilterUnseenImageUrls.remove(url);
        }
      }
    }

    return url;
  }

  // todo: this is kind of messy since it sets state 3 times, there may be a
  // cleaner way of achieving this...
  void _updateDogData(IconData? newIcon, Status status,
      String? newBreedDropdownValue, bool isOnLastDog) async {
    //todo - make API call for subbreed, for testing use mastiff

    String url = await _getNextImageUrl(newBreedDropdownValue, isOnLastDog);

    setState(() {
      profileIconVisible = false;
      swipeIconVisible = true;

      if (newBreedDropdownValue != null) {
        breedDropdownValue = newBreedDropdownValue;
      }

      // Save the current dog's profile data in the list
      if (!isLastDogInFilter) {
        currentDog.status = status;
        currentDog.icon = newIcon;
        seenDogs[currentDog.getImageUrl()] = currentDog;
      }
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
          // Set up a new dog profile
          if (!isLastDogInFilter) {
            currentDog = Dog();
            currentDog.setImageUrl(url);
          }

          isLastDogInFilter = breedDropdownValue != "All Breeds" &&
              currentFilterUnseenImageUrls.isEmpty;
          profileIconVisible = true;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      actions.getDogBreeds().then((val) {
        val.forEach((key, value) {
          dogBreeds.add(key);
        });
      });

      actions.getRandomImage().then(
        (val) {
          setState(() {
            // Set up the first dog
            currentDog = Dog();
            currentDog.setImageUrl(val);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentDog.getImageUrl() == "") {
      return const Text('loading');
    } else {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          // todo: figure out this swipe animation
          //_controller.forward();
          // Process swipe
          if (details.velocity.pixelsPerSecond.dx > 0.0) {
            _updateDogData(Icons.favorite_rounded, Status.liked, null, false);
          } else if (details.velocity.pixelsPerSecond.dx < 0.0) {
            _updateDogData(
                Icons.heart_broken_rounded, Status.disliked, null, false);
          }

          if (isLastDogInFilter) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Last Dog Reached'),
                content: Text(
                    'You\'ve seen all profiles for the $breedDropdownValue breed. Would you like to clear the filter and see a random dog?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'No'),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Yes!');
                      _updateDogData(null, Status.none, 'All Breeds', true);
                    },
                    child: const Text('Yes!'),
                  ),
                ],
              ),
            );
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
              ButtonBar(buttonPadding: const EdgeInsets.all(0.0), children: [
                SizedBox(
                  width: 115,
                  child: DropdownButton(
                    value: breedDropdownValue,
                    isExpanded: true,
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                    items: dogBreeds.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? newValue) {
                      _getSubBreedDropdrownList();
                      _updateDogData(null, Status.skipped, newValue, false);
                    },
                  ),
                ),
                if (dogSubBreeds.length > 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 0.0, 0.0, 0.0),
                    child: SizedBox(
                      width: 115,
                      child: DropdownButton(
                        value: subbreedDropdownValue,
                        isExpanded: true,
                        style: const TextStyle(
                            color: Colors.blueGrey, fontSize: 15.0),
                        items: dogSubBreeds,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? newValue) {
                          //_updateDogData(null, Status.skipped, newValue, false);
                        },
                      ),
                    ),
                  ),
                if (dogSubBreeds.length <= 1)
                  const Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 0.0, 0.0, 0.0),
                    child: SizedBox(
                      width: 105,
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    var favoriteDogs = <String, Dog>{};

                    seenDogs.forEach((key, value) {
                      if (value.status == Status.liked) {
                        favoriteDogs[key] = value;
                      }
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesPage(favoriteDogs),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.favorite_outline,
                    size: 15,
                    color: Colors.red,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: Colors.blueGrey,
                    )),
              ]),
              SlideTransition(
                position: _offsetAnimation,
                child: Stack(
                  alignment: Alignment.bottomRight,
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
                                currentDog.getImageUrl(),
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
                            currentDog.icon,
                            color: Colors.red,
                            size: 300,
                          ),
                        ),
                      ],
                    ),
                    if (profileIconVisible &&
                        currentDog.icon != null &&
                        seenDogs.containsKey(currentDog.getImageUrl()))
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            primary: Colors.red,
                          ),
                          onPressed: () {},
                          child: Icon(
                            currentDog.icon,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                currentDog.name,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blueGrey.shade100,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  kProfiles[currentDog.personalityIndex]["profile"],
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
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
