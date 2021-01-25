import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rss_reader/constants/constant.dart';



class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void handleSpinner() async {
    await Future.delayed(Duration(seconds: 1), () => {print('Yukleniyor...')});

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    handleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dünyanın En İyi RSS Okuyucusu'),centerTitle: true,backgroundColor: appColors['bgColor'],),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 200, top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SpinKitWave(
                  color: appColors['spinColor'],
                  size: 50.0,
                  duration: Duration(seconds: 1), // Animasyon Hizi
                )),
            SizedBox(height: 20),
            Text("Yükleniyor..."),
          ],
        ),
      ),
    );
  }
}
