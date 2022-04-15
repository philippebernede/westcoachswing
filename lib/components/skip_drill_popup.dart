import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/objects/drill_list.dart';
import '/utilities/size_config.dart';
import 'workouts.dart';
import '/tabView.dart';
import '/screens/drill_screen.dart';

class SkipDrillPopup extends StatelessWidget {
  final int _dashboardIndex = 3;

  const SkipDrillPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ), //this right here
      child: SizedBox(
        height: SizeConfig.blockSizeVertical! * 20,
        width: SizeConfig.blockSizeHorizontal! * 60,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                  fit: FlexFit.loose,
                  child: Text('Are you sure you want to skip this drill ?')),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      final workout =
                          Provider.of<Workouts>(context, listen: false);
                      final drill =
                          Provider.of<DrillList>(context, listen: false);
                      int _nextDrillId =
                          Provider.of<Workouts>(context, listen: false)
                              .nextWorkout(context);
                      if (_nextDrillId == 0) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabView(
                                      index: _dashboardIndex,
                                    )));
                      } else {
                        drill.setSelectedDrillById = workout.workouts[workout
                            .selectedWorkoutKey]![workout.activeSelectionIndex];
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DrillScreen(drill.selectedDrill.id!)));
                      }
                    },
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.white)),
                  ),
                  RaisedButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
