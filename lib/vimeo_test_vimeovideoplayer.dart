import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoTest extends StatefulWidget {
  const VimeoTest({Key? key}) : super(key: key);

  @override
  _VimeoTestState createState() => _VimeoTestState();
}

class _VimeoTestState extends State<VimeoTest> {
  @override
  final String _vimeoVideoUrl = 'https://vimeo.com/542405610/d6d4459bc1';
  // String videoId = '542405610?hd6d4459bc1';
  // String videoId = '70591644';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is a test'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              child: VimeoVideoPlayer(
                url: _vimeoVideoUrl,
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
