import 'package:flutter/foundation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '/components/collection_renderer.dart';
import '/components/exo_list_video_view.dart';
import '/components/workouts.dart';
import '/objects/student_list.dart';
import '/utilities/constants.dart';
import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool soloWorkout = true;

//  var _isInit = true;

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    if (_isInit) {
//      Provider.of<DrillList>(context, listen: false).initDrills();
//    }
//    _isInit = false;
//  }
//
//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//
//    if (_isInit) {
//      Provider.of<DrillList>(context, listen: false).initDrills();
//    }
//    _isInit = false;
//    super.didChangeDependencies();
//  }

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentList>(context);

    return Container(
//      decoration: kBackgroundContainer,
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(children: [
              Text(
                DateFormat(' EEEE ').format(DateTime.now()).toUpperCase(),
                style: kWelcomeDay,
              ),
              const Spacer(),
              soloCoupleSwitch(context),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '${student.studentsFirstName},\nThis practice has been created just for you',
                style: kWelcomePhrase,
              ),
            ),
          ),

          const ExoListVideoView(),
//          Container(
//            height: SizeConfig.blockSizeVertical * 65,
//            width: SizeConfig.blockSizeHorizontal * 80,
//            color: Colors.red,
//            child: ListView.builder(
//              physics: BouncingScrollPhysics(),
//              scrollDirection: Axis.horizontal,
//              itemCount: 3,
//              itemBuilder: (context, index) {
//                return Column(
//                  children: <Widget>[
//                    Container(
//                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
//                      child: Card(
//                        borderOnForeground: true,
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(30.0)),
//                        elevation: 7.0,
//                        shadowColor: Colors.black,
//                        child: Stack(
//                          children: <Widget>[
//                            ClipRRect(
//                              borderRadius: BorderRadius.circular(30.0),
//                              child: Container(
////                    color: Colors.red,
//                                height: SizeConfig.blockSizeVertical * 60,
//                                width: SizeConfig.blockSizeHorizontal * 80,
//                                child: FittedBox(
//                                    alignment: Alignment.center,
//                                    fit: BoxFit.cover,
//                                    child: Text('Text')
////                                    Image.network(
////                                        'http://drive.google.com/uc?export=view&id=15k7tZHq2HON4ednE6PB3Miz8FiGS7htz')
////                                  CachedNetworkImage(
////                                    imageUrl: drillList
////                                        .drillById(workout.workouts[index][0])
////                                        .imageLink,
////                                    placeholder: (context, url) => Center(
////                                      child: Container(
////                                        height: 5.0,
////                                        width: 5.0,
////                                        child: Text('loading...'),
////                                      ),
////                                    ),
////                                    errorWidget: (context, url, error) =>
////                                        Container(
////                                      height: 30.0,
////                                      width: 30.0,
////                                      child: Center(
////                                        child: Icon(
////                                          Icons.error,
////                                          size: 0.9,
////                                        ),
////                                      ),
////                                    ),
//                                    ),
////                          CardImageDrillChoice(),
//                              ),
//                            ),
////                            ),
//                            Positioned(
//                              bottom: 10.0,
//                              left: 25.0,
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(20)),
//                                  color: Theme.of(context)
//                                      .accentColor
//                                      .withOpacity(0.9),
//                                ),
//                                child: Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text(
//                                        'nameList[index]',
//                                        style: TextStyle(color: Colors.white),
//                                      ),
//                                      Text(
//                                        '~xx min',
//                                        style: TextStyle(color: Colors.white),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ],
//                );
//              },
//            ),
//          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            'Checkout our different Collections',
            style: kWelcomePhrase,
          ),
          const SizedBox(
            height: 10.0,
          ),
          const CollectionRenderer(
            isScrollable: false,
          ),
        ],
      ),
    );
  }

  PlatformAlertDialog errorDialog(BuildContext context) {
    return PlatformAlertDialog(
      title: kLogoNoir,
      content: const Text(
          'Sadly we have no drill corresponding to your selection right now'),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Row soloCoupleSwitch(BuildContext context) {
    final workout = Provider.of<Workouts>(context, listen: false);
    workout.soloCoupleSwitch == null
        ? soloWorkout = true
        : soloWorkout = workout.soloCoupleSwitch!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Couple'),
        Switch(
          activeColor: Colors.teal,
          inactiveThumbColor: Colors.teal,
          inactiveTrackColor: Colors.teal.withOpacity(0.5),
          value: soloWorkout,
          onChanged: (_) {
            setState(
              () {
                soloWorkout = !soloWorkout;
                workout.soloCoupleSwitch = soloWorkout;
                soloWorkout
                    ? workout.workoutList = workout.soloWorkouts
                    : showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => coupleDialog(context));
              },
            );
          },
        ),
        const Text('Solo'),
        const SizedBox(
          width: 5.0,
        )
      ],
    );
  }

  Dialog coupleDialog(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      primary: Theme.of(context).colorScheme.secondary,
    );
    final workout = Provider.of<Workouts>(context, listen: false);
    Map<int, List<int>> workoutChecker;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ), //this right here
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Flexible(
                fit: FlexFit.loose,
                child: Text(
                    'Great you are practicing with a partner. What is the skill you want to work on ?')),
            const SizedBox(
              height: 10.0,
            ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 5.0,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workout.todaysCoupleWorkout(context, 'technique');
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Technique',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workout.todaysCoupleWorkout(context, 'musicality');
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Musicality',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workoutChecker =
                        workout.todaysCoupleWorkout(context, 'styling');
                    if (listEquals(workoutChecker[3], [11111])) {
                      //TODO réinitialiser la switch à Solo
                      Navigator.pop(context);
                      setState(() {
                        soloWorkout = !soloWorkout;
                      });
                      showDialog(
                          context: context,
                          builder: (_) => errorDialog(context));
                      //  TODO ajouter la demande de reinitialisation des executions si ils ont déjà fait tous les drills
                    } else {
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Styling',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workout.todaysCoupleWorkout(context, 'partneringSkill');
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Partnering Skills',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workout.todaysCoupleWorkout(context, 'personalSkill');
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Personal Skills',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    workout.todaysCoupleWorkout(context, 'random');
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Mix it up',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
