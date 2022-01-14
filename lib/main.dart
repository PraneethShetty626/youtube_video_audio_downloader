import 'package:flutter/material.dart';
import 'package:internetfiledownloader/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ////////////
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red,
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.red),
      home: Scaffold(
        appBar: AppBar(title: const Text("YDownloader")),
        body: const Home(),
      ),
    );
  }
}
