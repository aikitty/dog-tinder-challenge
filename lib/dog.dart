import 'dart:math';
import 'package:flutter/material.dart';

import 'consts.dart';
import 'consts_dog_names.dart';

class Dog {
  String _imageUrl = "";
  Status status = Status.none;
  int personalityIndex = 0;
  String name = "";
  String breed = "";
  IconData? icon;

  Dog() {
    personalityIndex = Random().nextInt(9);
    name = kDogNames[Random().nextInt(kDogNames.length - 1)];
  }

  String getImageUrl() {
    return _imageUrl;
  }

  void setImageUrl(String url) {
    _imageUrl = url;

    RegExp exp = RegExp(r'(?<=breeds\/)([a-z|-]*)');
    RegExpMatch? match = exp.firstMatch(_imageUrl);
    breed = match![0] ?? "";
  }
}
