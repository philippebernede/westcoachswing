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
  final String loop;

  ///constructor
  ///
  ///
  ///
  const VimeoPlayer({
    Key? key,
    required this.videoId,
    required this.loop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WebView webView = WebView();
    // WebSettings webSettings = webView.getSettings();
    // webSettings.setJavaScriptEnabled(true);
    // webSettings.setAllowFileAccess(true);
    // webSettings.setAppCacheEnabled(true);
    // webSettings.setMediaPlaybackRequiresUserGesture(false);
    return WebView(
      initialUrl: _videoPage(videoId,loop),
      javascriptMode: JavascriptMode.unrestricted,gestureNavigationEnabled: false,initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,allowsInlineMediaPlayback: true,
    );
  }

  ///web page containing iframe of the vimeo video
  ///
  ///
  ///
  ///
  String _videoPage(String videoId,String loop) {
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
     
                <iframe src="https://player.vimeo.com/video/$videoId?autoplay=1&loop=$loop&autopause=1&autopause=0&muted=0"; allow="autoplay; fullscreen; picture-in-picture" allowfullscreen style="position:absolute;top:0;left:0;width:100%;height:100%;"></iframe>
             </body>
            </html>
            ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }
}
