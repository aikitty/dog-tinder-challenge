import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dog Tinder'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                    radius: 150.0,
                    backgroundImage: AssetImage('assets/carmelacrop.jpg')),
                SizedBox(
                    height: 20.0,
                    width: 100.0,
                    child: Divider(color: Colors.blueGrey[100])),
                Text('Leigh (& Carmela)',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey.withOpacity(.75),
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  'Product Eng',
                  style: TextStyle(
                      fontSize: 20.0, color: Colors.blueGrey.withOpacity(.4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
