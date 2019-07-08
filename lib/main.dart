import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String _artist;
  String _title;
  String _comment;
  TextEditingController artistTEC = TextEditingController();
  TextEditingController titleTEC = TextEditingController();
  TextEditingController commentTEC = TextEditingController();

  Directory _appDocumentsDirectory;
  Map<String, String> filesPaths;

  Future<void> _readTag() async {
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

    artistTEC.text = _artist;
    titleTEC.text = _title;
    commentTEC.text = _comment;
  }

  void _requestStoragePermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print(permission);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      print(permissions);
    }
  }

  void _requestAppDocumentsDirectory() async {
    _appDocumentsDirectory = await getApplicationDocumentsDirectory();
//    print(_appDocumentsDirectory.path);

    List<String> fileList = <String>[];
    var musicDirectory = Directory("storage/emulated/0/");
    List<FileSystemEntity> files =
        await musicDirectory.list(recursive: true, followLinks: false).toList();
//        .listen((FileSystemEntity entity) {
//      if (entity.path != null) {
//        try {
//          fileList.add(entity.path);
////          print(entity.path);
//        } catch (e) {}
//      }
//    });
    files.forEach((FileSystemEntity entity) {
      if (entity.path.isNotEmpty &&
          entity != null &&
          !entity.path.contains("data") &&
          entity.path.contains("mp3")) {
        print(entity);
      }
    });
  }

  Future<void> _writeToTag() async {
//    var d = await DefaultAssetBundle.of(context).load('data/mp3.mp3');
//
//    TagProcessor tp = TagProcessor();
//    var l = await tp.getTagsFromByteData(d, [TagType.id3v2]);
//    final tag = Tag()
//      ..tags = {
//        'title': 'foo',
//        'artist': 'bar',
//        'comment': 'lol it is a comment',
//      };
//    var bytes = rootBundle.load('data/mp3.mp3');
//    List<int> newByteArrayWithTags = await tp.putTagsToByteArray(bytes, [tag]);
  }

  @override
  void initState() {
    _requestStoragePermission();
//    _getAllmp3Files();
    super.initState();
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
            TextField(
              controller: artistTEC,
              decoration: InputDecoration(hintText: "Artist"),
            ),
            TextField(
              controller: titleTEC,
              decoration: InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: commentTEC,
              decoration: InputDecoration(hintText: "Comment"),
            ),
            Image.memory(_imageData),
            MaterialButton(
              onPressed: _requestAppDocumentsDirectory,
              child: Text("Write to mp3"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _readTag,
        tooltip: 'read tag',
        label: Text('read tag'),
        icon: Icon(Icons.cached),
      ),
    );
  }
}
