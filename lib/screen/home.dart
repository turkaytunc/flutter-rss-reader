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
  static const List<String> rssSample = [
    'https://rss.nytimes.com/services/xml/rss/nyt/World.xml',
    'https://www.espn.com/espn/rss/news',
    'https://feeds.npr.org/510312/podcast.xml',
    'https://feeds.a.dj.com/rss/RSSWorldNews.xml',
    'https://www.haberturk.com/rss'
  ];

  String feedUrl = rssSample[3];
  RssFeed _feed;
  bool isDark = false;

  // Rss bilgisini sunucudan al
  Future<RssFeed> loadFeed() async {
    try {
      Intl.defaultLocale = 'tr_TR';
      final response = await http.Client().get(feedUrl);
      return RssFeed.parse(response.body);
    } catch (e) {
      print('fetch error - Server Not Respond');
    }
    return null;
  }

  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        print('Parse Error - Empty Content');

        return;
      }

      // Veriyi guncelle
      updateRssFeed(result);
    });
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

  updateColorTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  void initState() {
    super.initState();

    load();
  }

  // WIDGETLAR

  // Rss Basligi
  title(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toString(),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.deepOrange, shadows: <Shadow>[
            Shadow(
              offset: Offset(0.25, 0.25),
              blurRadius: 0.5,
              color: Colors.deepOrangeAccent,
            ),
            Shadow(
              offset: Offset(0.25, 0.25),
              blurRadius: 0.5,
              color: Colors.deepOrangeAccent,
            ),
          ]),
          maxLines: 3,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  // rss yayin tarihi
  rssPubDate(pubDate) {
    String formattedDate = pubDate.toString().substring(0, 19);

    return Text(
      formattedDate,
      style: TextStyle(fontSize: 14.0, color: isDark ? Colors.white : Colors.black87),
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

  // Rss Header Container
  Widget feedHeader() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(bottom: 5.0, left: 5, right: 5),
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: Colors.grey[800]),
            borderRadius: BorderRadius.circular(5),
            color: isDark ? Colors.grey[800] : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton.icon(
              // Gece Modu Butonu
              onPressed: updateColorTheme,
              icon: Icon(
                isDark ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDark ? Colors.amber : Colors.black87,
              ),
              label: Text('${isDark ? "Gündüz Modu" : "Gece Modu"}'),
              color: isDark ? Colors.black54 : Colors.white70,
              textColor: isDark ? Colors.white70 : Colors.black87,
              elevation: 4,
            ),
            Text(
              "Link: " + _feed.link,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[800],
              ),
              maxLines: 2,
            ),
            Text(
              "Açıklama: " + _feed.description,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[800],
              ),
              maxLines: 3,
            ),
            Text(
              "Son Güncellenme: " + _feed.lastBuildDate,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.grey[800],
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  // List Item Container
  Widget feedList() {
    return Expanded(
      flex: 4,
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(5.0),
          itemCount: _feed.items.length,
          itemBuilder: (BuildContext context, int index) {
            RssItem item = _feed.items[index];
            return Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              margin: EdgeInsets.only(
                bottom: 10.0,
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey[600]),
                  borderRadius: BorderRadius.circular(5),
                  color: isDark ? Colors.grey[800] : Colors.white),
              child: ListTile(
                title: title(item.title),
                subtitle: rssPubDate(item.pubDate),
                trailing: Icon(
                  Icons.cast_rounded,
                  color: Colors.deepOrangeAccent,
                  size: 25.0,
                ),
                contentPadding: EdgeInsets.all(8.0),
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
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Güncelleniyor...", style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
              SizedBox(height: 20),
              SpinKitCircle(
                color: Colors.deepOrange,
                size: 50.0,
                duration: Duration(seconds: 1), // Animasyon Hizi
              ),
            ],
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
        title: Text(
          'Really Simple Syndication', // Gerçekten Basit Dağıtım
          style: TextStyle(color: isDark ? Colors.deepOrange : Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey[800] : Colors.deepOrange,
      ),
    );
  }
}
