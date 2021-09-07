import 'package:flutter/material.dart';
import 'package:flutter_restaurant/home.dart';
import 'package:flutter_restaurant/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Restaurant',
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Prompt',
        primaryColor: ThemeColors.kPrimaryColor,
        accentColor: ThemeColors.kAccentColor,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
