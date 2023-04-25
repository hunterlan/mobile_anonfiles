import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_anonfiles/models/result_widget_arguments.dart';
import 'package:mobile_anonfiles/services/anonfiles_service.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return UploadState();
  }
}

class UploadState extends State<UploadWidget> {
  List<PlatformFile> _userFiles = List<PlatformFile>.empty(growable: true);

  final textPickFiles = const Text('Pick files');
  final textUploadFiles = const Text('Upload files');
  final _anonFilesService = AnonFilesService();

  Widget materialStyle() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload file'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: pickFile,
                    child: textPickFiles
                ),
                ElevatedButton(
                    onPressed: _userFiles.isEmpty ? null : upload,
                    child: textUploadFiles
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget cupertinoStyle() {
    return CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CupertinoButton(
                      onPressed: pickFile,
                      child: textPickFiles
                  ),
                  CupertinoButton(
                      onPressed: _userFiles.isEmpty ? null : upload,
                      child: textUploadFiles
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;

    setState(() {
      _userFiles = result.files;
    });
  }

  Future<void> upload() async {
    var responses = await _anonFilesService.upload(_userFiles);
    if (mounted) {
      Navigator.pushNamed(context, '/result', arguments: ResultWidgetArguments(fileResponses: responses));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return materialStyle();
    } else {
      return cupertinoStyle();
    }
  }
}