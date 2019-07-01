import 'dart:async';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dart tag reader demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'dart tag reader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List _imageData = Uint8List(0);
  String _artist = "";
  String _title = "";
  String _comment = "";

  Future _readTag() async {
    var d = await DefaultAssetBundle.of(context).load('data/mp3.mp3');

    TagProcessor tp = TagProcessor();
    var l = await tp.getTagsFromByteData(d, [TagType.id3v2]);

    AttachedPicture ai = l[0].tags['APIC'];

    setState(() {
      _artist = l[0].tags['artist'];
      _title = l[0].tags['title'];
      _comment = l[0].tags['comment'];
      _imageData = Uint8List.fromList(ai.imageData);
    });
    print('Artist: $_artist\nTitle: $_title\nComment: $_comment\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Artist: $_artist\nTitle: $_title\nComment: $_comment\n'),
            Image.memory(_imageData),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readTag,
        tooltip: 'read tag',
        child: Icon(Icons.cached),
      ),
    );
  }
}
