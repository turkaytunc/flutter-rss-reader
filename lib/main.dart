import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/screen/home.dart';
import 'package:flutter_rss_reader/screen/loading.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
      '/': (context) => Loading(),
      '/home': (context) => HomeScreen(),
      }
  ));
}


