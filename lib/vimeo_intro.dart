import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:westcoachswing/VimeoPlayer/vimeo_player.dart';
import 'package:westcoachswing/screens/root_page.dart';

class VimeoIntro extends StatefulWidget {
  VimeoIntro({Key? key, required this.fullscreen, required this.videoID})
      : super(key: key);
  final bool? fullscreen;
  final String videoID;
  @override
  _VimeoIntroState createState() => _VimeoIntroState();
}

class _VimeoIntroState extends State<VimeoIntro> {
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
              loop: "0",
            ),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.withOpacity(0.5)),
                label: const Text("Skip Video"),
                onPressed: () {
                  SystemChrome.setPreferredOrientations(
                    [
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                    ],
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RootPage()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_right_alt_outlined,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _VimeoIntroState();
}
