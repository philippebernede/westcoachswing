import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/level_rater.dart';
import '/components/workouts.dart';
import '/objects/drill_list.dart';
import '/objects/execution_list.dart';
import '/objects/student_list.dart';
import '/screens/drill_screen.dart';
import '/tabView.dart';
import '/utilities/constants.dart';

class FinishedDrillPopup extends StatefulWidget {
  const FinishedDrillPopup({Key? key}) : super(key: key);

  @override
  _FinishedDrillPopupState createState() => _FinishedDrillPopupState();
}

class _FinishedDrillPopupState extends State<FinishedDrillPopup> {
  final _dashboardIndex = 3;
  final _directoryIndex = 1;
  final levelRates = kLevelRates;
  List<bool> levelSelections = [false, false, false];
  bool _isInit = true;
  int? _nextDrillId;
  int? _finishedDrillId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _finishedDrillId = Provider.of<DrillList>(context).getSelectedDrillId;
    if (_isInit) {
      _nextDrillId =
          Provider.of<Workouts>(context, listen: false).nextWorkout(context);
    }
    _isInit = false;
  }

  bool toggleSelection(bool selection, int index) {
    bool _isSelected = true;
    setState(() {
      levelSelections = [false, false, false];
      if (selection) {
        levelSelections[index] = true;
        _isSelected = true;
      }

      _isSelected = false;
    });
    return _isSelected;
  }

  Rex rexConverter() {
    switch (levelSelections.indexOf(true)) {
      case 0:
        {
          return Rex.Easy;
        }
      case 1:
        {
          return Rex.Perfect;
        }
      case 2:
        {
          return Rex.Difficult;
        }
      default:
        return Rex.Perfect;
    }
  }

  @override
  Widget build(BuildContext context) {
    final drill = Provider.of<DrillList>(context, listen: false);
    final executionList = Provider.of<ExecutionList>(context, listen: false);
    final workout = Provider.of<Workouts>(context, listen: false);
    final currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      primary: Theme.of(context).colorScheme.secondary,
    );
//    int nextDrillId = workout.nextWorkout(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                fit: FlexFit.loose,
                child: Text(
                    'Congratulations you finished this drill. Now help us personalize your experience by rating this drill. This drill was :'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: levelRates
                    .map((element) => LevelRater(
                        element,
                        levelSelections[levelRates.indexOf(element)],
                        levelRates.indexOf(element),
                        toggleSelection))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
//   si il n'y a plus d'exercices on renvoi sur la page de recherche / directory sinon on renvoi sur la page d'accueil
                          MaterialPageRoute(
                              builder: (context) => _nextDrillId == 0
                                  ? TabView(
                                      index: _directoryIndex,
                                    )
                                  : const TabView()));
                      executionList.addExecution(
                        Execution(
                          studentId: currentStudent.id,
                          dateTime: DateTime.now(),
                          rex: Rex.values[levelSelections.indexOf(true) == -1
                              ? 1
                              : levelSelections.indexOf(true)],
                          drillId: _finishedDrillId,
                        ),
                        context,
                      );
                    },
                    child: _nextDrillId == 0
                        ? const Text(
                            "Keep working",
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            "Stop practice",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {
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
                      executionList.addExecution(
                        Execution(
                          studentId: currentStudent.id,
                          dateTime: DateTime.now(),
                          rex: Rex.values[levelSelections.indexOf(true) == -1
                              ? 1
                              : levelSelections.indexOf(true)],
                          drillId: _finishedDrillId,
                        ),
                        context,
                      );
                    },
                    child: _nextDrillId == 0
                        ? const Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            "Next Drill",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
