import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:westcoachswing/screens/full_screen_video_player.dart';
import 'package:westcoachswing/utilities/constants.dart';
import '/components/received_notification.dart';
import '/objects/drill.dart';
import '/objects/execution_list.dart';
import '/objects/student_list.dart';
import '/tabView.dart';
import '/components/workouts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//TODO Remettre les notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

late NotificationAppLaunchDetails notificationAppLaunchDetails;

class MoreInfo extends StatefulWidget {
  final String studentId;
  const MoreInfo(this.studentId);
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  String? dropdownLevelValue;
  String? dropdownRoleValue;
  int? selectedRadio;
  int? selectedRadioLevel;
  bool reminderIsOn = true;
  List<bool> _selectedDays = List.generate(7, (_) => false);
  late TimeOfDay time;
  bool isChanged = false;
  String? stringHour;
  String? stringMin;
  bool isSaving = false;
  TextStyle textStyleHighlight = const TextStyle(
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.teal,
        offset: Offset(-5.0, 5.0),
      ),
    ],
  );
  TextStyle textStyleClassic = const TextStyle();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    TODO récupérer l'information de l'étudiant
    time = TimeOfDay.now();
    stringHour = time.hour.toString();
    stringMin = time.minute.toString();
//    selectedRadio = student.role.index;
//  TODO Remettre en uncomment les 3 lignes ci-dessous
//     //    FOR Setting up Local notifications
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  //TODO Remettre les notifications
//   //--------------------------Functions for Local Notifications------------------------
  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TabView(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TabView()),
      );
    });
  }

//  ---------------------------------------LOCAL NOTIFICATION ADD---------------------------------------
  tz.TZDateTime _nextInstanceOfDayTime(TimeOfDay timeOfDay, int day) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, timeOfDay.hour, timeOfDay.minute);
    while (scheduledDate.weekday != day + 1) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

//  -------------------------------------------LOCAL NOTIFICATION ADD END--------------------------------
  Future<void> _setWeeklyAtDayAndTimeNotification(
      TimeOfDay timeOfDay, List<bool> days, ctx) async {
//    StudentList studentList = Provider.of<StudentList>(ctx, listen: false);

//    Future.forEach(days, (element)   =>
    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
//        const AndroidNotificationDetails androidPlatformChannelSpecifics =
//            AndroidNotificationDetails('show weekly channel id',
//                'show weekly channel name', 'show weekly description',
//                importance: Importance.max,
//                priority: Priority.high,
//                showWhen: false);
//        const IOSNotificationDetails iOSPlatformChannelSpecifics =
//            IOSNotificationDetails();
//        const NotificationDetails platformChannelSpecifics =
//            NotificationDetails(
//                android: androidPlatformChannelSpecifics,
//                iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.zonedSchedule(
            i + 1,
            'It\'s time to practice',
            'Check out what we have planned for you today',
            _nextInstanceOfDayTime(timeOfDay, i),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'weekly notification channel id',
                  'weekly notification channel name',
                  channelDescription: 'weekly notificationdescription'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
//        await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
//            i + 1,
//            'It\s time to practice',
//            'Check out what we have planned for you today',
//            Day(i + 1 == 8 ? 1 : i + 1),
//            time,
//            platformChannelSpecifics);
//        print('hours : ${timeOfDay.hour} minutes : ${timeOfDay.minute}');
//
//        print(Day(i + 2 == 8 ? 1 : i + 2).value);
      }
    }
//
// //  saving notifications to firebase already done in save info
// //    try {
// //      await Firestore.instance
// //          .collection('students')
// //          .document(widget.studentId)
// //          .setData({
// //        'Notifications Day': days,
// //        'Notifications Time':
// //            time.hour.toString() + ':' + time.minute.toString(),
// //      });
// ////      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saved')));
// //    } catch (err) {
// ////      Scaffold.of(ctx).showSnackBar(SnackBar(
// ////          content: Text(
// ////              'Something went wrong. Please try again later or report the problem')));
// //      print(err);
// //    }
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }
// //-------------------------------End of the functions for local Notifications-----------------------
//TODO This is the end of what I need to uncomment

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val!;
    });
  }

  setSelectedRadioLevel(int? val) {
    setState(() {
      selectedRadioLevel = val!;
    });
  }

  _setTime() async {
    TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!);
        });
    if (t != null) {
      setState(() {
        time = t;
        stringHour = time.hour.toString();
        stringMin = time.minute.toString();
      });
    }
  }

//  TODO adding SnackBar once saving process is done
//  TODO set up the notifications
  saveInfo(StudentList studentList) async {
//    Student student = studentList.currentStudent;
    studentList.setRole = Role.values[selectedRadio!];
    studentList.setNotificationsDay = _selectedDays;
    studentList.setCategory = selectedRadioLevel!;
//    if (time.minute < 10) {
//      stringMin = '0$stringMin';
//    }
    studentList.setNotificationsTime = '${time.hour}:${time.minute}';
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .update({
        'Role': Role.values[selectedRadio!].toString(),
        'Notification Days': _selectedDays,
        'Notification Time': '${time.hour}:${time.minute}',
        'Category': selectedRadioLevel,
      });
//      await studentList.initStudent();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentList = Provider.of<StudentList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('More information'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/whiteBrick.jpg"),
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Thank You for signing up! You are one step away from accessing your personal West Coach Swing',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                    'In order to personalize your experience we just need a few more informations. All selections can be changed later on.'),
                const SizedBox(
                  height: 10.0,
                ),
                const Text('Please select the role(s) you want to practice in'),
                const SizedBox(
                  height: 10.0,
                ),
                roleDrop(),
                //roleRow(),
                const SizedBox(
                  height: 20.0,
                ),
                const Text('Please select your level (can be changed later)'),
                const SizedBox(
                  height: 10.0,
                ),
                levelDrop(),
                //levelRow(),
                const SizedBox(
                  height: 20.0,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: const Text('Enable Practice Reminders'),
                  trailing: Switch(
                      value: reminderIsOn,
                      onChanged: (_) {
                        isChanged = true;
                        setState(() {
                          reminderIsOn = !reminderIsOn;
                        });
                      }),
                ),
                reminderIsOn ? dayTimeButtons() : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    child: const Text('Save & Continue to Next Step'),
                    onPressed: () {
//    vérifie que l'on a bien sélectionné un rôle pour l'application
                      if (selectedRadio == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text('Please select a Role'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                        return;
                      }
//   vérifie que l'on a bien sélectionné un niveau pour l'application
                      if (selectedRadioLevel == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text('Please select your Level'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                        return;
                      }

                      saveInfo(studentList);
                      //TODO petite ligne à remettre en uncomment
                      _setWeeklyAtDayAndTimeNotification(
                          time, _selectedDays, context);
                      Future<void> studentInit = studentList
                          .initStudent(context)
                          .then((_) =>
                              Provider.of<Workouts>(context, listen: false)
                                  .todaysWorkout2(context, true));
                      Future<void> executionList =
                          Provider.of<ExecutionList>(context, listen: false)
                              .getStudentsExecutions();
                      Future.wait([studentInit, executionList]).then(
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
//                            CountDownTransitionScreen(drill),
                                const FullScreenVideoPlayerScreen(
                              autoPlay: true,
                              videoURL:
                                  "https://www.googleapis.com/drive/v3/files/1GoMIV8MwkO7OFv2B9TKTS0klQowEwgft?alt=media&key=AIzaSyA0Tl505CBLuuK2goq6rGKCatWwkd_uSQM",
                              // nextPage: MaterialPageRoute(
                              //   builder: (context) => FutureBuilder(
                              //     future:
                              //         Future.wait([studentInit, executionList]),
                              //     builder: (BuildContext context,
                              //         AsyncSnapshot<void> snapshot) {
                              //       if (snapshot.connectionState ==
                              //           ConnectionState.done) {
                              //         return const TabView();
                              //       } else {
                              //         return const Center(
                              //             child: CircularProgressIndicator(
                              //                 backgroundColor: Colors.pink));
                              //       }
                              //     },
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column dayTimeButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Text('Set your practice time and days :'),
        const SizedBox(
          height: 5.0,
        ),
        //---------------------------------------------------------BEGINNING OF NEW LAYOUT FOR TIME ------------------------------------------------------------------------------------
        TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
//                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    time.format(context),
                    style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            onPressed: () {
              isChanged = true;
              _setTime();
            }),
//---------------------------------------------------------END OF NEW LAYOUT OF TIME------------------------------------------------------------------------------------
// Text('Set your practice days :'),
        const SizedBox(
          height: 5.0,
        ),
        ToggleButtons(
          children: const <Widget>[
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
          isSelected: _selectedDays,
          fillColor: Theme.of(context).colorScheme.secondary,
          selectedColor: Colors.white,
          onPressed: (int index) {
            isChanged = true;
            setState(() {
              _selectedDays[index] = !_selectedDays[index];
            });
          },
        ),
      ],
    );
  }

  Row roleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Leader',
              style: selectedRadio == 0 ? textStyleHighlight : textStyleClassic,
            ),
            Radio(
                value: 0,
                groupValue: selectedRadio,
                onChanged: (int? val) {
                  setSelectedRadio(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Follower',
              style: selectedRadio == 1 ? textStyleHighlight : textStyleClassic,
            ),
            Radio(
                value: 1,
                groupValue: selectedRadio,
                onChanged: (int? val) {
                  setSelectedRadio(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Both',
              style: selectedRadio == 2 ? textStyleHighlight : textStyleClassic,
            ),
            Radio(
                value: 2,
                groupValue: selectedRadio,
                onChanged: (int? val) {
                  setSelectedRadio(val);
                })
          ],
        )
      ],
    );
  }

  Container roleDrop() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xffd3dde4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: const Text('Select a role'),
            value: dropdownRoleValue,
            iconEnabledColor: Colors.teal,
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(
                () {
                  int val = 0;
                  dropdownRoleValue = newValue!;
                  switch (newValue) {
                    case 'Leader':
                      {
                        val = 0;
                      }
                      break;
                    case 'Follower':
                      {
                        val = 1;
                      }
                      break;
                    case 'Both':
                      {
                        val = 2;
                      }
                      break;
                    default:
                      {
                        val = 1;
                      }
                      break;
                  }
                  setSelectedRadio(val);
                },
              );
            },
            items: <String>[
              'Follower',
              'Leader',
              'Both',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Container levelDrop() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xffd3dde4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            iconEnabledColor: Colors.teal,
            hint: const Text('Select a level'),
            value: dropdownLevelValue,
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                int val = 0;
                dropdownLevelValue = newValue!;
                switch (newValue) {
                  case 'Newcomer':
                    {
                      val = 0;
                    }
                    break;
                  case 'Novice':
                    {
                      val = 1;
                    }
                    break;
                  case 'Intermediate':
                    {
                      val = 2;
                    }
                    break;
                  case 'Advanced':
                    {
                      val = 3;
                    }
                    break;
                  case 'All Star / Champions':
                    {
                      val = 4;
                    }
                    break;
                  default:
                    {
                      val = 0;
                    }
                    break;
                }
                setSelectedRadioLevel(val);
              });
            },
            items: <String>[
              'Newcomer',
              'Novice',
              'Intermediate',
              'Advanced',
              'All Star / Champions',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row levelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Newcomer',
              style: selectedRadioLevel == 0
                  ? textStyleHighlight
                  : textStyleClassic,
            ),
            Radio(
                value: 0,
                groupValue: selectedRadioLevel,
                onChanged: (int? val) {
                  setSelectedRadioLevel(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Novice',
              style: selectedRadioLevel == 1
                  ? textStyleHighlight
                  : textStyleClassic,
            ),
            Radio(
                value: 1,
                groupValue: selectedRadioLevel,
                onChanged: (int? val) {
                  setSelectedRadioLevel(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Intermediate',
              style: selectedRadioLevel == 2
                  ? textStyleHighlight
                  : textStyleClassic,
            ),
            Radio(
                value: 2,
                groupValue: selectedRadioLevel,
                onChanged: (int? val) {
                  setSelectedRadioLevel(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'Advanced',
              style: selectedRadioLevel == 3
                  ? textStyleHighlight
                  : textStyleClassic,
            ),
            Radio(
                value: 3,
                groupValue: selectedRadioLevel,
                onChanged: (int? val) {
                  setSelectedRadioLevel(val);
                })
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              'AllStar/Champion',
              style: selectedRadioLevel == 4
                  ? textStyleHighlight
                  : textStyleClassic,
            ),
            Radio(
                value: 4,
                groupValue: selectedRadioLevel,
                onChanged: (int? val) {
                  setSelectedRadioLevel(val);
                }),
          ],
        ),
      ],
    );
  }
}
