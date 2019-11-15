import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'generated/seti.dart';

void main() => runApp(MyApp());

const title = 'Seti icons for Flutter';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _input = 'main.dart';
  double _size = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          InkWell(
            child: SetiIcon('.html', size: 32),
            onTap: () {
              html.window.open('https://github.com/pd4d10/seti-flutter', '');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (v) {
                _input = v;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'File name',
                labelText: 'Input file name here',
              ),
            ),
            Slider(
              value: _size,
              onChanged: (v) {
                setState(() {
                  _size = v;
                });
              },
              max: 300,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[SetiIcon(_input, size: _size)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
