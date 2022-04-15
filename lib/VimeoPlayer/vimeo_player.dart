import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///vimeo player for Flutter apps
///Flutter plugin based on the [webview_flutter] plugin
///[videoId] is the only required field to use this plugin
///
///
///
///
class VimeoPlayer extends StatelessWidget {
  final String videoId;

  ///constructor
  ///
  ///
  ///
  const VimeoPlayer({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: _videoPage(this.videoId),
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  ///web page containing iframe of the vimeo video
  ///
  ///
  ///
  ///
  String _videoPage(String videoId) {
    final html = '''
            <html>
              <head>
                <style>
                  body {
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
         
                <meta http-equiv="Content-Security-Policy" 
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; 
                img-src 'self' data:https://i.vimeocdn.com ; style-src * 'unsafe-inline';">
             </head>
             <body>
     
                <iframe src="https://player.vimeo.com/video/$videoId?autoplay=1&loop=1&autopause=1&autopause=0&muted=0"; allow="autoplay; fullscreen; picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;"></iframe>
             </body>
            </html>
            ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }
}
