import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes/download_widget.dart';
import 'routes/failed_widget.dart';
import 'routes/main_menu.dart';
import 'routes/success_widget.dart';
import 'routes/upload_widget.dart';

void main() {
  runApp(MobileAnonFiles());
}

class MobileAnonFiles extends StatelessWidget {
  MobileAnonFiles({super.key});

  final _homeWidget = const MainMenuWidget();

  final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder> {
    '/upload': (BuildContext context) => const UploadWidget(),
    '/download': (BuildContext context) => const DownloadWidget(),
    '/success': (BuildContext context) => const SuccessWidget(),
    '/failed': (BuildContext context) => const FailedWidget()
  };

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return MaterialApp(
        home: _homeWidget,
        routes: _routes,
      );
    } else {
      return CupertinoApp(
        home: _homeWidget,
        routes: _routes,
      );
    }
  }
}