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


  // Rss Basligi
  title(title) {
    return Text(
      title.toString(),
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.red),
      maxLines: 3,
    );
  }

  // rss yayin tarihi
  rssPubDate(pubDate) {
    return Text(
      pubDate.toString(),
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.green),
    );
  }

  // Rss icerigini okumak icin yonlendirme yap: url_launcher
  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
  }

 Widget feedHeader(){
   return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red, // border color
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Link: " + _feed.link,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.red),
              maxLines: 2,
            ),
            Text(
              "Açıklama: " + _feed.description,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.red),
              maxLines: 3,
            ),
            Text(
              "Son Güncellenme: " + _feed.lastBuildDate,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.red),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }


 Widget feedList(){
    return Expanded(
      flex: 3,
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(5.0),
          itemCount: _feed.items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _feed.items[index];
            return Container(
              margin: EdgeInsets.only(
                bottom: 10.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red, // border color
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: title(item.title),
                subtitle: rssPubDate(item.pubDate),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.red,
                  size: 30.0,
                ),
                contentPadding: EdgeInsets.all(5.0),
                onTap: () => openFeed(item.link),
              ),
            );
          },
        ),
      ),
    );
  }

  list() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      feedHeader(),
      feedList(),
    ]);
  }

  body() {
    return isFeedEmpty()
        ? Center(
      child: SpinKitCircle(
        color: appColors['spinColor'],
        size: 50.0,
        duration: Duration(seconds: 1), // Animasyon Hizi
      ),
    )
        : RefreshIndicator(
      child: list(),
      onRefresh: () => load(),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: AppBar(
        title: Text('Really Simple Syndication'), // Gerçekten Basit Dağıtım
        centerTitle: true,
      ),
    );
  }
}
