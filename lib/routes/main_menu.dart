import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({super.key});

  Widget cupertinoStyle(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
                child: const Text('Upload file'),
                onPressed:() => navigateUploading(context)
            ),
            CupertinoButton(
                child: const Text('Download file'),
                onPressed: () => navigateDownloading(context)
            )
          ],
        ),
      ),
    );
  }

  Widget materialStyle(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text('Upload file'),
                onPressed: () => navigateUploading(context)
            ),
            ElevatedButton(
                child: const Text('Download file'),
                onPressed: () => navigateDownloading(context)
            )
          ],
        ),
      ),
    );
  }

  void navigateUploading(BuildContext context) {
    Navigator.of(context).pushNamed('/upload');
  }

  void navigateDownloading(BuildContext context) {
    Navigator.of(context).pushNamed('/download');
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return materialStyle(context);
    } else {
      return cupertinoStyle(context);
    }
  }
}