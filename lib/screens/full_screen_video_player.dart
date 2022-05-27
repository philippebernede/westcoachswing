import 'dart:async';

import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '/tabView.dart';

class FullScreenVideoPlayerScreen extends StatefulWidget {
  final bool autoPlay;
  final String videoURL;
  final MaterialPageRoute? nextPage;
  const FullScreenVideoPlayerScreen(
      {Key? key, required this.autoPlay, required this.videoURL, this.nextPage})
      : super(key: key);

  @override
  _FullScreenVideoPlayerScreenState createState() =>
      _FullScreenVideoPlayerScreenState();
}

class _FullScreenVideoPlayerScreenState
    extends State<FullScreenVideoPlayerScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool isTapped = false;
  bool hasStarted = false;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
//   TODO Changer pour récupérer sur network
    _controller =
        VideoPlayerController.asset('/assets/RPReplay_Final1605824031.MP4');
    // _controller = VideoPlayerController.network(widget.videoURL);

//    _controller = VideoPlayerController.network(
//      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller?.initialize();
    _controller!.addListener(checkVideo);
    // .then(
    //   (value) => {
    //     _controller!.addListener(
    //       () {
    //         //custom Listner
    //         setState(
    //           () {
    //             if ((_controller!.value.duration ==
    //                 _controller!.value.position)) {
    //               //checking the duration and position every time
    //               //Video Completed//
    //
    //               widget.nextPage;
    //             }
    //           },
    //         );
    //       },
    //     )
    //   },
    // );

    // Use the controller to loop the video.
    _controller?.setLooping(false);
    if (widget.autoPlay) {
      _controller?.play();
    }

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Row? controls() {
    if (!isTapped) {
      return null;
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.replay_10,
                color: Theme.of(context).colorScheme.secondary,
                size: 50.0,
              ),
              onPressed: () async {
                Duration? _currentPosition = await _controller!.position;
                _controller?.seekTo(_currentPosition! - Duration(seconds: 10));
              }),
          IconButton(
            icon: Icon(
              _controller!.value.isPlaying
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
              size: 70.0,
            ),
            onPressed: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
          ),
          IconButton(
              icon: Icon(
                Icons.forward_10,
                color: Theme.of(context).colorScheme.secondary,
                size: 50.0,
              ),
              onPressed: () async {
                Duration? _currentPosition = await _controller!.position;
                _controller!.seekTo(_currentPosition! + Duration(seconds: 10));
              }),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  isTapped = !isTapped;
//                  // If the video is playing, pause it.
//                  if (_controller.value.isPlaying) {
//                    _controller.pause();
//                  } else {
//                    // If the video is paused, play it.
//                    _controller.play();
//                  }
                });
              },
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    return SizedBox(
                      height: SizeConfig.blockSizeHorizontal! * 100,
//                      width: SizeConfig.blockSizeVertical * 100,
                      child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!)),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

//             Center(child: controls()),
//             if (isTapped)
//               Align(
//                   alignment: Alignment.bottomCenter,
//                   child: VideoProgressIndicator(_controller!,
//                       allowScrubbing: true)),
//             if (isTapped)
//               Positioned(
//                 left: 20.0,
//                 top: 20.0,
//                 child: IconButton(
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: Theme.of(context).colorScheme.secondary,
//                     ),
//                     onPressed: () {
// //    TODO fixing video placement when screen pops
//                       SystemChrome.setPreferredOrientations([
//                         DeviceOrientation.portraitUp,
//                         DeviceOrientation.portraitDown
//                       ]);
//                       Navigator.pop(context);
//                     }),
//               )
//          Container(
//            decoration: BoxDecoration(
//              color: Colors.blue,
//              borderRadius: BorderRadius.circular(70.0),
//            ),
//          ),
//          playPauseButton(),
//          FloatingActionButton(
//            backgroundColor: Colors.white,
//            onPressed: () {
//              // Wrap the play or pause in a call to `setState`. This ensures the
//              // correct icon is shown.
//              setState(() {
//                // If the video is playing, pause it.
//                if (_controller.value.isPlaying) {
//                  _controller.pause();
//                } else {
//                  // If the video is paused, play it.
//                  _controller.play();
//                }
//              });
//            },
//            // Display the correct icon depending on the state of the player.
//            child: Icon(
//              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//              color: Colors.black,
//            ),
//          ),
          ],
        ),
      ),
    );
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :

    if (_controller!.value.position >
            const Duration(seconds: 2, minutes: 0, hours: 0) &&
        !hasStarted) {
      hasStarted = true;
    }

    if (_controller!.value.position == _controller!.value.duration &&
        hasStarted) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabView()),
      );
    }
  }
}
