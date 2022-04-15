import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:westcoachswing/VimeoPlayer/vimeo_player.dart';

class VimeoTest extends StatefulWidget {
  VimeoTest({Key? key, required this.fullscreen, required this.videoID})
      : super(key: key);
  bool? fullscreen;
  String videoID;
  @override
  _VimeoTestState createState() => _VimeoTestState();
}

class _VimeoTestState extends State<VimeoTest> {
  @override
  void initState() {
    if (widget.fullscreen == true) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.dispose();
  }

  // String videoId = '566655660?hdcedfb952c';
  // String videoId = '542405610?hd6d4459bc1';
  // String videoId = '70591644';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: VimeoPlayer(
          videoId: widget.videoID,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
