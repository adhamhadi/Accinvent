import 'package:flutter/material.dart';
import 'package:barcode_scanner/screens/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accinvent pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.indigo.shade900,
      ),
      home: LoginPage(),
    );
  }
}



