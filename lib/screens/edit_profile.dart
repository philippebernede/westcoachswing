import 'package:westcoachswing/utilities/size_config.dart';

import '/objects/drill.dart';
import '/objects/student.dart';
import '/objects/student_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    print('selectedRadio : $selectedRadioRole student.role: ${student.role}');

    try {
      await studentList.updateStudentProfile(student);
      ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Changes have been saved')));
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text(
              'Something went wrong. Please try again later or report the problem')));
    }
  }

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
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes have been saved')));
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
              Container(
                child: Padding(
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
                        roleRow(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        levelRow(),
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
