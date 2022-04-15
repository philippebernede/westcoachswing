import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/workouts.dart';
import '/objects/drill_list.dart';
import '/screens/drill_presentation_screen.dart';
import '/utilities/size_config.dart';

class ExoListVideoView extends StatelessWidget {
  const ExoListVideoView({Key? key}) : super(key: key);

//  final PageController pageController = PageController(viewportFraction: 0.9);
  @override
  Widget build(BuildContext context) {
    final workout = Provider.of<Workouts>(context);
    final drillList = Provider.of<DrillList>(context);
    final workoutDurations = workout.getWorkoutDurations(drillList);
//   TODO fixing problem of name called on null when we call this function at the start of the app
// TODO on pourrait changer les noms des pratiques si on veut mais pas obligé
    final List<String> nameList = [
//      workout.getSingleDrillName(context),
      'Single Drill',
      'Short Practice',
      'Longer Practice'
    ];
    return SizedBox(
      height: SizeConfig.blockSizeVertical! * 65,
      width: SizeConfig.blockSizeHorizontal! * 80,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
//                lorsqu'on clique ca renvoi sur la page de presentation du workout avec la liste des différents drills à venir
            onTap: () {
              workout.selectedWorkout(index, context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrillPresentationScreen(
                            workout.workouts[index]![0],
                            workout.workouts[index],
                            nameList[index],
                          )));
            },
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Card(
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    elevation: 7.0,
                    shadowColor: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: SizedBox(
//                    color: Colors.red,
                            height: SizeConfig.blockSizeVertical! * 60,
                            width: SizeConfig.blockSizeHorizontal! * 80,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              child: Image.asset(
                                drillList
                                    .drillById(workout.workouts[index]![0])
                                    .imageLink!,
                                errorBuilder: (context, url, error) =>
                                    const SizedBox(
                                  width: 30.0,
                                  height: 30.0,
                                  child: Center(
                                    child: Icon(
                                      Icons.error,
                                      size: 0.9,
                                    ),
                                  ),
                                ),
                              ),
//                                    Image.network(
//                                        'http://drive.google.com/uc?export=view&id=15k7tZHq2HON4ednE6PB3Miz8FiGS7htz')
//                                   CachedNetworkImage(
//                                 imageUrl: drillList
//                                     .drillById(workout.workouts[index]![0])
//                                     .imageLink!,
// //                                    placeholder: (context, url) => Center(
// //                                      child: Container(
// //                                        height: 5.0,
// //                                        width: 5.0,
// //                                        child: Text('loading...'),
// //                                      ),
// //                                    ),
// //                                    errorWidget: (context, url, error) =>
// //                                        Container(
// //                                      height: 30.0,
// //                                      width: 30.0,
// //                                      child: Center(
// //                                        child: Icon(
// //                                          Icons.error,
// //                                          size: 0.9,
// //                                        ),
// //                                      ),
// //                                    ),
//                               ),
//                          CardImageDrillChoice(),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 25.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    nameList[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '~${workoutDurations[index]} min',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
