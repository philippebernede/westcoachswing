import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:westcoachswing/VimeoPlayer/vimeo_player.dart';

class VimeoTest extends StatefulWidget {
  VimeoTest({Key? key, required this.fullscreen, required this.videoID})
      : super(key: key);
  final bool? fullscreen;
  final String videoID;
  @override
  _VimeoTestState createState() => _VimeoTestState();
}

class _VimeoTestState extends State<VimeoTest> {
  @override
  void initState() {
    super.initState();
    if (widget.fullscreen == true) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft
      ]);
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
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            VimeoPlayer(
              videoId: widget.videoID,
            ),
            if (widget.fullscreen == true)
              Positioned(
                left: 20.0,
                top: 20.0,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
//    TODO fixing video placement when screen pops
                    SystemChrome.setPreferredOrientations(
                      [
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ],
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _VimeoTestState();
}
