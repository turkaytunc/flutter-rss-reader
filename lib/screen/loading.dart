import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void handleSpinner() async {
    await Future.delayed(Duration(seconds: 5), () => {print('Yükleniyor...')});

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
      appBar: AppBar(
        title: Text(
          'Dünyanın En İyi RSS Okuyucusu',
          style: TextStyle(color: Colors.deepOrange),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: SpinKitWave(
                color: Colors.deepOrange,
                size: 50.0,
                duration: Duration(seconds: 1), // Animation speed
              )),
          SizedBox(height: 20),
          Text("Yükleniyor...", style: TextStyle(fontSize: 18, color: Colors.grey[800]),),
        ],
      ),
    );
  }
}
