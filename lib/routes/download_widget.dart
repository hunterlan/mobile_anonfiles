import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_anonfiles/services/anonfiles_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadWidget extends StatefulWidget {
  const DownloadWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return DownloadState();
  }

}

class DownloadState extends State<DownloadWidget> {
  final _anonFilesService = AnonFilesService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _horizontalPadding = const EdgeInsets.symmetric(horizontal: 16);
  final _buttonFormPadding = const EdgeInsets.only(top: 16);
  final _downloadTextButton = const Text('Download');
  final String _hintText = 'Put your URL here';
  String _downloadUrl = '';


  void download() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status != PermissionStatus.granted) {
        return;
      }
    }
    _anonFilesService.download(_downloadUrl);
  }

  Widget materialStyle() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: _horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (value) => _downloadUrl = value,
                  decoration: InputDecoration(
                      hintText: _hintText
                  ),
                ),
                Padding(
                  padding: _buttonFormPadding,
                  child: (
                      ElevatedButton(
                        onPressed: download,
                        child: _downloadTextButton,
                      )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget cupertinoStyle() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: _horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoTextFormFieldRow(
              placeholder: _hintText,
              onChanged: (value) => _downloadUrl = value,
            ),
            Padding(
              padding: _buttonFormPadding,
              child: CupertinoButton(
                onPressed: download,
                child: _downloadTextButton,
              ),
            )
          ],
        ),
      ),
    );
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