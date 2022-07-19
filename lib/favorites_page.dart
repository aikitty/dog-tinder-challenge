import 'package:flutter/material.dart';
import 'dog.dart';
import 'consts.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage(this.favoriteDogs, {Key? key}) : super(key: key);

  final Map<String, Dog> favoriteDogs;

  List<Widget> _getTextWidget() {
    List<Widget> favoriteDogWidgetList = <Widget>[];

    favoriteDogs.forEach((k, v) {
      var dogWidget = Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              height: 150,
              width: 150,
              child: Image.network(
                v.getImageUrl(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              v.name,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              v.breed,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              "${kProfiles[v.personalityIndex]["personality"]}",
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ]);

      favoriteDogWidgetList.add(dogWidget);
    });

    if (favoriteDogWidgetList.isEmpty) {
      favoriteDogWidgetList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.heart_broken_rounded,
                color: Colors.blueGrey,
                size: 100.0,
              ),
              Text(
                'No dogs favorited yet!',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blueGrey.withOpacity(.75),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return favoriteDogWidgetList;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Favorites'),
        ),
        body: ListView(children: _getTextWidget()));
  }
}
