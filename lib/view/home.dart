import 'package:flutter/material.dart';

import 'contentList.dart';
import 'categoryList.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String json = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: CategoryList(),
      // body: ContentList(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.redAccent,
      centerTitle: true,
      backgroundColor: Color.fromRGBO(176, 0, 0, 1.0),
      title: getTitle(),
    );
  }

  Container getTitle() {
    return Container(width: 85, child: getLogo());
  }

  Image getLogo() {
    return const Image(
        fit: BoxFit.fitWidth, image: AssetImage('assets/images/logo.jpg'));
  }
}
