import 'package:westcoachswing/utilities/size_config.dart';

import '/tabView.dart';
import '/objects/drill.dart';
import '/objects/student.dart';
import '/objects/student_list.dart';
import '/components/received_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

//------------------------------------------------NOTIFICATION----------------------------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

late NotificationAppLaunchDetails notificationAppLaunchDetails;

//------------------------------------------------NOTIFICATION END ----------------------------------------

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _form = GlobalKey<FormState>();
  final _formRole = GlobalKey<FormState>();
  final _formLevel = GlobalKey<FormState>();
  Student student = Student();
  List<bool>? _selectedDays = List.generate(7, (_) => false);
  bool? reminderIsOn;
  String? dropdownLevelValue;
  String? dropdownRoleValue;
  int? selectedRadioRole;
  int? selectedRadioLevel;
  bool isChanged = false;
  bool isSet = false;
  TimeOfDay? time;
  String? stringHour;
  String? stringMin;
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

  void _saveForm(StudentList studentList, ctx) async {
    FocusScope.of(context).unfocus();
//    print('selectedRadio : $selectedRadio student.role: ${student.role}');
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    _formRole.currentState!.save();
    _formLevel.currentState!.save();

    student.role = Role.values[selectedRadioRole!];
    student.id = studentList.currentStudent.id;
    student.category = selectedRadioLevel!;
    student.notificationDays = _selectedDays;
    student.notificationTime = '${time!.hour}:${time!.minute}';

    // print('selectedRadio : $selectedRadioRole student.role: ${student.role}');

    try {
      await flutterLocalNotificationsPlugin.cancelAll();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannel('weekly notification channel id');
      _setWeeklyAtDayAndTimeNotification(time!, _selectedDays!, context);
      await studentList.updateStudentProfile(student);
      ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Changes have been saved')));
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text(
              'Something went wrong. Please try again later or report the problem')));
    }
  }

//------------------------------------------------NOTIFICATION----------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//  TODO Remettre en uncomment les 3 lignes ci-dessous
//     //    FOR Setting up Local notifications
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

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
    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
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
      }
    }
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }
// //-------------------------------End of the functions for local Notifications-----------------------

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isSet) {
      selectedRadioRole = Provider.of<StudentList>(context, listen: false)
          .currentStudent
          .role!
          .index;
      selectedRadioLevel = Provider.of<StudentList>(context, listen: false)
          .currentStudent
          .category;
      dropdownRoleValue = Provider.of<StudentList>(context, listen: false)
          .currentStudent
          .role!
          .name;
      dropdownLevelValue = Provider.of<StudentList>(context, listen: false)
          .studentsLevelName(selectedRadioLevel!);
      // time.hour=Provider.of<StudentList>(context, listen: false)
      //     .currentStudent.notificationTime
      String stringTime = Provider.of<StudentList>(context, listen: false)
          .currentStudent
          .notificationTime!;
      _selectedDays = Provider.of<StudentList>(context, listen: false)
          .currentStudent
          .notificationDays;
      time = TimeOfDay(
          hour: int.parse(stringTime.split(":")[0]),
          minute: int.parse(stringTime.split(":")[1]));
      Provider.of<StudentList>(context, listen: false)
                  .currentStudent
                  .notificationDays ==
              [false, false, false, false, false, false, false]
          ? reminderIsOn = false
          : reminderIsOn = true;
    }
    isSet = true;
  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    student.notificationDays==[false,false,false,false,false,false,false] ? reminderIsOn=false : reminderIsOn=true;
//    super.initState();
// ////    TODO récupérer l'information de l'étudiant
// //    selectedRadio = student.role.index;
//  }

  setSelectedRadioRole(int val) {
    setState(() {
      isChanged = true;
      selectedRadioRole = val;
    });
  }

  setSelectedRadioLevel(int val) {
    setState(() {
      isChanged = true;
      selectedRadioLevel = val;
    });
  }

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final studentList = Provider.of<StudentList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                icon: const Icon(
                  Icons.save,
                ),
                onPressed: () {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Changes have been saved')));
                  if (isChanged) _saveForm(studentList, context);
                }),
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Container(
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'First Name',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      TextFormField(
                        initialValue: studentList.currentStudent.firstName,
//                        readOnly: _firstNameReadOnly,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
//                          suffixIcon: IconButton(
//                              icon: Icon(Icons.edit),
//                              onPressed: () {
//                                isChanged = true;
//                                setState(() {
//                                  _firstNameReadOnly
//                                      ? _firstNameReadOnly = false
//                                      : _firstNameReadOnly = true;
//                                });
//
//                                print('button pressed');
//                              }),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (_) {
                          isChanged = true;
                        },
                        onSaved: (String? value) {
                          student.firstName = value!;
//                      TODO ajouter la méthode pour modifier le prénom de l'étudiant
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field can\'t be empty.';
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Last Name'),
                      ),
                      TextFormField(
                        initialValue: studentList.currentStudent.lastName,
//                        readOnly: _lastNameReadOnly,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
//                          suffixIcon: IconButton(
//                              icon: Icon(Icons.edit),
//                              onPressed: () {
//                                isChanged = true;
//                                setState(() {
//                                  _lastNameReadOnly
//                                      ? _lastNameReadOnly = false
//                                      : _lastNameReadOnly = true;
//                                });
//                                print('button pressed');
//                              }),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (_) {
                          isChanged = true;
                        },
                        onSaved: (String? value) {
                          student.lastName = value!;
//                      TODO ajouter la méthode pour modifier le nom de l'étudiant
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field can\'t be empty.';
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Email (this field can not be changed)'),
                      ),
                      TextFormField(
                        initialValue: studentList.currentStudent.email,
                        readOnly: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
//                          suffixIcon: IconButton(
//                              icon: Icon(Icons.edit),
//                              onPressed: () {
//                                isChanged = true;
//                                setState(
//                                  () {
//                                    _emailReadOnly
//                                        ? _emailReadOnly = false
//                                        : _emailReadOnly = true;
//                                  },
//                                );
//                                print('button pressed');
//                              }),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      roleDrop(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      levelDrop(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0.0),
                        title: const Text('Enable Practice Reminders'),
                        trailing: Switch(
                            value: reminderIsOn!,
                            onChanged: (_) {
                              isChanged = true;
                              setState(() {
                                reminderIsOn = !reminderIsOn!;
                              });
                            }),
                      ),
                      reminderIsOn! ? dayTimeButtons() : Container(),
                    ],
                  ),
                ),
              ),
              // FlatButton(
              //     color: Colors.white,
              //     onPressed: () async {
              //       await signOut();
              //       Navigator.pushReplacement(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => AuthenticationScreen()));
              //     },
              //     child: Text(
              //       'Log out',
              //       style: TextStyle(
              //           decoration: TextDecoration.underline, color: Colors.red),
              //     )),
            ],
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
        FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 2.0, color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
//                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    time!.format(context),
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     Card(
        //       shape: RoundedRectangleBorder(
        //           side: BorderSide(
        //               width: 2.0, color: Theme.of(context).accentColor),
        //           borderRadius: BorderRadius.circular(8.0)),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //             time!.hour > 9 ? '${stringHour!.substring(0, 1)}' : '0'),
        //       ),
        //     ),
        //     Card(
        //       shape: RoundedRectangleBorder(
        //           side: BorderSide(
        //               width: 2.0, color: Theme.of(context).accentColor),
        //           borderRadius: BorderRadius.circular(8.0)),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(time!.hour > 9
        //             ? '${stringHour!.substring(1, 2)}'
        //             : '$stringHour'),
        //       ),
        //     ),
        //     Text(' : '),
        //     Card(
        //       shape: RoundedRectangleBorder(
        //           side: BorderSide(
        //               width: 2.0, color: Theme.of(context).accentColor),
        //           borderRadius: BorderRadius.circular(8.0)),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //             time!.minute > 9 ? '${stringMin!.substring(0, 1)}' : '0'),
        //       ),
        //     ),
        //     Card(
        //       shape: RoundedRectangleBorder(
        //           side: BorderSide(
        //               width: 2.0, color: Theme.of(context).accentColor),
        //           borderRadius: BorderRadius.circular(8.0)),
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(time!.minute > 9
        //             ? '${stringMin!.substring(1, 2)}'
        //             : '$stringMin'),
        //       ),
        //     ),
        //     IconButton(
        //         icon: Icon(Icons.arrow_drop_down),
        //         onPressed: () {
        //           isChanged = true;
        //           _setTime();
        //         }),
        //   ],
        // ),
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
          isSelected: _selectedDays!,
          fillColor: Theme.of(context).colorScheme.secondary,
          selectedColor: Colors.white,
          onPressed: (int index) {
            isChanged = true;
            setState(() {
              _selectedDays![index] = !_selectedDays![index];
            });
          },
        ),
      ],
    );
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
        stringHour = time!.hour.toString();
        stringMin = time!.minute.toString();
      });
    }
  }

  Form levelDrop() {
    return Form(
      key: _formLevel,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dance Level :'),
          Container(
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
                  hint: const Text('Select a role'),
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
          ),
        ],
      ),
    );
  }

  Form roleDrop() {
    return Form(
      key: _formRole,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Role(s) :'),
          Container(
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
                  iconEnabledColor: Colors.teal,
                  value: dropdownRoleValue,
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
                        setSelectedRadioRole(val);
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
          ),
        ],
      ),
    );
  }

  Form roleRow() {
    return Form(
      key: _formRole,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Leader',
                style: selectedRadioRole == 0
                    ? textStyleHighlight
                    : textStyleClassic,
              ),
              Radio(
                  value: 0,
                  groupValue: selectedRadioRole,
                  onChanged: (int? val) {
                    setSelectedRadioRole(val!);
                  })
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Follower',
                style: selectedRadioRole == 1
                    ? textStyleHighlight
                    : textStyleClassic,
              ),
              Radio(
                  value: 1,
                  groupValue: selectedRadioRole,
                  onChanged: (int? val) {
                    setSelectedRadioRole(val!);
                  })
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Both',
                style: selectedRadioRole == 2
                    ? textStyleHighlight
                    : textStyleClassic,
              ),
              Radio(
                  value: 2,
                  groupValue: selectedRadioRole,
                  onChanged: (int? val) {
                    setSelectedRadioRole(val!);
                  })
            ],
          )
        ],
      ),
    );
  }

  Form levelRow() {
    return Form(
      key: _formLevel,
      child: Row(
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
                    setSelectedRadioLevel(val!);
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
                    setSelectedRadioLevel(val!);
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
                    setSelectedRadioLevel(val!);
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
                    setSelectedRadioLevel(val!);
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
                    setSelectedRadioLevel(val!);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
