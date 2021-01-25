import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/constants/constant.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';

import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const String FEED_URL = 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml';
  RssFeed _feed;

  Future<RssFeed> loadFeed() async {
    try {
      Intl.defaultLocale = 'tr_TR';
      final response = await http.Client().get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      print('fetch error');
    }
    return null;
  }

  // Rss icerigi bos mu kontrol et
  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  // Rss Guncelle
  updateRssFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        print('Fetch Error');

        return;
      }

      // Veriyi guncelle
      updateRssFeed(result);

    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Body'),
      appBar: AppBar(
        title: Text('Really Simple Syndication'), // Gerçekten Basit Dağıtım
        centerTitle: true,
      ),
    );
  }
}
