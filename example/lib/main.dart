import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'package:media_picker_builder_example/picker/picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'picker/gallery_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Picker Demo'),
        ),
        body: Center(
          child: RaisedButton(
            child: const Text("Albums"),
            onPressed: () {
              _checkPermission().then((granted) {
                if (!granted) return;

                // To build your own custom picker use this api
              //  MediaPickerBuilder.getAlbums(
              //    withImages: true,
              //    withVideos: true,
              //  ).then((albums) {
              //    print(albums.first.);
              //  });
              // GalleryWidget(mediaFiles: null)

                // If you are happy with the example picker then you use this!
                _buildPicker();
              });
            },
          ),
        ),
      ),
    );
  }

  _buildPicker() {
    showModalBottomSheet<Set<MediaFile>>(
      context: navigatorKey.currentState.overlay.context,
      builder: (BuildContext context) {
        return PickerWidget(
          withImages: true,
          withVideos: true,
          onDone: (Set<MediaFile> selectedFiles) {
            print(selectedFiles.first.path);
            Navigator.pop(context);
          },
          onCancel: () {
            print("Cancelled");
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<bool> _checkPermission() async {
    final permissionStorageGroup =
        Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
    Map<PermissionGroup, PermissionStatus> res =
        await PermissionHandler().requestPermissions([
      permissionStorageGroup,
    ]);
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }
}
