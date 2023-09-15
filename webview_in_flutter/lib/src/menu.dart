import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Menu extends StatelessWidget {
  final WebViewController controller;

  const Menu({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            await controller.loadRequest(Uri.parse('https://youtube.com'));
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Navigate to YouTube'),
        ),
      ],
    );
  }
}

enum _MenuOptions {
  navigationDelegate,
}
