import 'package:flutter/material.dart';
import 'package:rest_test/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REST API Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
    );
  }
}
