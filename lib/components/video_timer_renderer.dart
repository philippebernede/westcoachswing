import '/components/skip_drill_popup.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wakelock/wakelock.dart';

import '/vimeo_test.dart';
import '/components/finished_drill_popup.dart';
import '/utilities/constants.dart';
import '/utilities/size_config.dart';
import 'skip_drill_popup.dart';

class VideoTimerRenderer extends StatefulWidget {
  final bool? autoPlay;
  final String? shortVideoURL;
  final String? videoURL;
  final Duration? duration;
//  final VideoPlayerController controller;
  const VideoTimerRenderer({
    Key? key,
    @required this.autoPlay,
    @required this.shortVideoURL,
    @required this.videoURL,
    @required this.duration,
  }) : super(key: key);

  @override
  _VideoTimerRendererState createState() => _VideoTimerRendererState();
}

class _VideoTimerRendererState extends State<VideoTimerRenderer>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  // Future<void>? _initializeVideoPlayerFuture;
  AnimationController? timerController;

  @override
  void initState() {
    final assetsAudioPlayer = AssetsAudioPlayer();
//-----SCREEN--------
//    Screen.keepOn(true);
//--------VIDEO----------
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

//    _videoController = VideoPlayerController.asset(widget.shortVideoURL);
    _videoController = VideoPlayerController.network(widget.shortVideoURL!);

//    _videoController = VideoPlayerController.network(
//      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//    );

    // Initialize the controller and store the Future for later use.
    // _initializeVideoPlayerFuture = _videoController!.initialize();

    // Use the controller to loop the video.
    _videoController!.setLooping(true);
    if (widget.autoPlay!) {
      _videoController!.play();
    }

//------TIMER--------
    timerController = AnimationController(
      value: 1.0,
      vsync: this,
      duration: widget.duration,
    );
    timerController!.addListener(() {
// si le timer s'arrête on met la video en pause, on joue le son et on ouvre la boite de dialogue,
      if (timerController!.isDismissed) {
        _videoController!.pause();
        assetsAudioPlayer.open(
          Audio('assets/audio/alert_bell_ping_wooden.mp3'),
        );
        assetsAudioPlayer.play();
//        Navigator.pop(context);
        _showDialog();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
//-----SCREEN--------
//    Screen.keepOn(false);
//-----VIDEO-------
    // Ensure disposing of the VideoPlayerController to free up resources.
    _videoController!.dispose();
//    TODO certainement a remettre
//     SystemChrome.setPreferredOrientations([
// //      DeviceOrientation.landscapeRight,
// //      DeviceOrientation.landscapeLeft,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ],
//     );

//-----TIMER-------
    timerController!.removeListener(() {});
    timerController!.dispose();
    super.dispose();
  }

//---------------------------------------FONCTIONS POUR LA VIDEO-------------------------------------------------------------
  CircleAvatar playPauseButton() {
    if (_videoController!.value.isPlaying) {
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
      );
    } else {
      // If the video is paused, play it.

      return const CircleAvatar(
        backgroundColor: Colors.white60,
        child: Icon(
          Icons.pause,
          color: Colors.black,
        ),
      );
    }
  }

//---------------------------------------FONCTIONS POUR LE TIMER-------------------------------------------------------------
  String get timerString {
    Duration duration = timerController!.duration! * timerController!.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  _showDialog() {
    showDialog(context: context, builder: (_) => const FinishedDrillPopup());
  }

//---------------------------------BOITE DE DIALOGUE POUR SKIP DRILL-------------------------------------------------------------------------
  _showDialogSkip() {
    showDialog(context: context, builder: (_) => const SkipDrillPopup());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.cover,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.blockSizeHorizontal! * 100,
                width: SizeConfig.blockSizeVertical! * 100,
                //TODO ancienne integration de la video
                // child: Align(
                //   alignment: Alignment.center,
                //   heightFactor: 1,
                //   widthFactor: 1,
                //   child: AspectRatio(
                //     aspectRatio: _videoController!.value.aspectRatio,
                //     child: VideoPlayer(_videoController!),
                //   ),
                // ),
                //Nouvelle partie pour la video
                child: VimeoTest(
                    fullscreen: false, videoID: widget.shortVideoURL!),
              ),
              // Positioned(bottom: 20.0, right: 20.0, child: playPauseButton()),
            ],
          ),
        ),
//------------------------------------------------TIMER PART--------------------------------------------------------------

        AnimatedBuilder(
          animation: timerController!,
          builder: (context, child) {
            final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              primary: Theme.of(context).colorScheme.secondary,
            );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                      animation: timerController!,
                      builder: (BuildContext context, Widget? child) {
                        return Text(
                          timerString,
                          style: const TextStyle(
                              fontSize: 80.0, color: Colors.teal),
                        );
                      }),
                  const SizedBox(
                    height: 5.00,
                  ),
                  AnimatedBuilder(
                    animation: timerController!,
                    builder: (context, child) {
                      final ButtonStyle raisedButtonStyle =
                          ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            side: BorderSide(color: Colors.teal)),
                        primary: Colors.white,
                      );
                      final ButtonStyle raisedButtonIcon =
                          ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        primary: Theme.of(context).colorScheme.secondary,
                        onPrimary: Theme.of(context).colorScheme.secondary,
                      );
                      //// disabledColor Theme.of(context).colorScheme.secondary,);
//                      controller.isDismissed ? _showDialog() : Text('');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: raisedButtonIcon,
                            onPressed: () {
                              if (timerController!.isAnimating) {
                                setState(() {
                                  Wakelock.disable();
                                  timerController!.stop();
                                });
                              } else {
                                setState(() {
                                  Wakelock.enable();
                                  timerController!.reverse(
                                      from: timerController!.value == 0.0
                                          ? 1.0
                                          : timerController!.value);
                                });
                              }
                            },
                            icon: Icon(
                              timerController!.isAnimating
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Text(
                                timerController!.isAnimating
                                    ? "Pause Practice"
                                    : "Start Practice",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    height: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.teal, width: 1.0),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  _showDialogSkip();
                                }),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.teal, width: 1.0),
                              shape: BoxShape.circle,
                            ),
                            // decoration: ShapeDecoration(
                            //   color:
                            //       Theme.of(context).colorScheme.secondary,
                            //   shape: const CircleBorder(
                            //       side: BorderSide(
                            //     color: Colors.teal,
                            //   )),
                            // ),
                            child: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  setState(() {
                                    timerController!.stop();
                                    timerController!.value = 1.0;
                                  });
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Not sure about what to do ?',
                    style: kActionTextStyle,
                  ),
                  const Text(
                    'Simply check out the full drill breakdown just below',
                    style: kActionTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const IconButton(
                    iconSize: 40.0,
                    onPressed: null,
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                  ),
                  ElevatedButton(
                    style: raisedButtonStyle,
                    // color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      setState(() {
                        timerController!.stop();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              //     // VimeoPlayer(id: widget.videoURL!),
                              // const VimeoPlayer(id: '395212534', autoPlay: true)
                              VimeoTest(
                                  fullscreen: true, videoID: widget.videoURL!),
                          //     FullScreenVideoPlayerScreen(
                          //   autoPlay: true,
                          //   videoURL: widget.videoURL!,
                          // ),
                        ),
                      );
                    },
                    child: const Text(
                      "Full drill breakdown HERE",
                      style: TextStyle(color: Colors.white),
                      // style: kActionButtonTextStyle,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
