import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void handleSpinner() async {
    await Future.delayed(Duration(seconds: 2), () => {print('Loading...')});

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    handleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Loading..'),);
  }
}
