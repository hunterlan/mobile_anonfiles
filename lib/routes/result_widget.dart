import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_anonfiles/models/anonfiles_url.dart';
import 'package:mobile_anonfiles/models/result_widget_arguments.dart';

import '../models/anonfiles_response.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends State<ResultWidget> {
  List<AnonFilesResponse> _filesResponse = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    extractArgs();
    super.didChangeDependencies();
  }

  void extractArgs() {
    final args = ModalRoute.of(context)!.settings.arguments as ResultWidgetArguments;
    setState(() {
      _filesResponse = args.fileResponses;
    });
  }

  Widget buildPopupMenuButton(AnonFilesUrl urls) {
    return PopupMenuButton(
        onSelected: (urlType) async {
          switch (urlType) {
            case 'short':
              await Clipboard.setData(ClipboardData(text: urls.short));
              break;
            case 'full':
              await Clipboard.setData(ClipboardData(text: urls.full));
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(value: 'short', child: Text('Copy short url'),),
            const PopupMenuItem(value: 'full', child: Text('Copy full url'),)
          ];
        }
    );
  }

  Widget listItemBuilder(BuildContext context, int index) {
    final item = _filesResponse.elementAt(index);
    final backgroundColor = (item.error == null ? Colors.green : Colors.red);
    final listText = Text(item.file.path.split('/').last);

    if (Platform.isAndroid) {
      return Card(
        child: ListTile(
          tileColor: backgroundColor,
          title: listText,
          trailing: item.error == null ? buildPopupMenuButton(item.data!.urls) : null,
        ),
      );
    } else {
      return CupertinoListTile(
          title: listText
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: ListView.builder(
            itemCount: _filesResponse.length,
            itemBuilder: (context, index) => listItemBuilder(context, index)
        ),
      );
    } else {
      return CupertinoPageScaffold(
        child: ListView.builder(
            itemCount: _filesResponse.length,
            itemBuilder: (context, index) => listItemBuilder(context, index)
        ),
      );
    }
  }
}