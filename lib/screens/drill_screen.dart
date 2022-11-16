//import 'dart:html';
import '/utilities/size_config.dart';
import '/components/drill_list_listtile.dart';
import '/components/video_timer_renderer.dart';
import '/components/workouts.dart';
import '/objects/drill.dart';
import '/objects/drill_list.dart';
import '/tabView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrillScreen extends StatelessWidget {
  final int drillId;
  const DrillScreen(this.drillId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drillList = Provider.of<DrillList>(context);
//    int selectedDrill = drillList.getSelectedDrillId;
    Drill drill = drillList.drillById(drillId);
    final upcomingDrills = Provider.of<Workouts>(context, listen: false)
        .getUpcomingDrills(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            '${drill.name}',
            style: const TextStyle(color: Colors.black),
            softWrap: true,
          ),
          fit: BoxFit.fitWidth,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const TabView()),
                );
              }),
        ],
//        centerTitle: ,
//        actionsIconTheme: IconThemeData(color: Colors.white),
//        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
//        toolbarOpacity: 0.5,
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: SizeConfig.blockSizeVertical! * 100,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/whiteBrick.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//            TODO changer les seconds en minutes
                VideoTimerRenderer(
                    autoPlay: true,
                    shortVideoURL: drill.shortVideoURL,
                    videoURL: drill.videoURL,
                    duration: Duration(
                        minutes: int.parse(drill.duration!.substring(0, 2)),
                        seconds: int.parse(drill.duration!.substring(3, 5)))),
//            FittedBox(
//              fit: BoxFit.cover,
//              child: VideoPlayerScreen(
//                autoPlay: true,
//                videoURL: drillList.drillById(selectedDrill).shortVideoURL,
//              ),
//            ),
//            TimerWidget(
//              Duration(minutes: drill.duration),
//            ),

                const SizedBox(
                  height: 20.0,
                ),
                if (upcomingDrills.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Upcoming Drills :'),
                  ),
//   affichage des drills à venir
                ...upcomingDrills
                    .map((e) => DrillListTile(
                          drill: e,
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
