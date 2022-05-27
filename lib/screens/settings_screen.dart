import '/components/settings_static_info.dart';
import '/objects/execution_list.dart';
import '/objects/student_list.dart';
import '/screens/authentication_screen.dart';
import '/screens/edit_profile.dart';
// import '/screens/notification_settings.dart';
import '/components/settings_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _form = GlobalKey<FormState>();
//  bool _lastNameReadOnly = true;
//  bool _firstNameReadOnly = true;
//  bool _emailReadOnly = true;
//  final student = StudentList().getStudent;
  late int selectedRadio;
  bool reminderIsOn = true;
//  List<bool> _selectedDays = List.generate(7, (_) => false);
  late TimeOfDay time;
  bool isChanged = false;
  String stringHour = '08';
  String stringMin = '00';

  Future<void> signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//  void _saveForm() {
//    final isValid = _form.currentState.validate();
//    if (!isValid) return;
//    _form.currentState.save();
//    student.role = Role.values[selectedRadio];
//    student.id = TabView.studentID;
//  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.save,
//              ),
//              onPressed: () {
//                if (isChanged) _saveForm();
//              }),
          IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SettingsButton('Edit Profile and Settings', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()));
                      }),
                      //TODO a remettre
                      // SettingsButton('Notification Settings', () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => NotificationSettings()));
                      // }),
//                      RaisedButton(
//                        elevation: 2.0,
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => EditProfile()));
//                        },
//                        child: Align(
//                            alignment: Alignment.centerLeft,
//                            child: Text('Edit Profile and Role')),
//                      ),
//                      RaisedButton(
//                        elevation: 2.0,
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      NotificationSettings()));
//                        },
//                        child: Align(
//                            alignment: Alignment.centerLeft,
//                            child: Text('Notification Settings')),
//                      ),
                      Text(
                        'Other',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SettingsStaticInfo(),
                    ],
                  ),
                ),
              ),
            ),
            FlatButton.icon(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                color: Colors.white,
                onPressed: () async {
                  await signOut();
                  Provider.of<StudentList>(context, listen: false).initialized =
                      false;
                  Provider.of<StudentList>(context, listen: false).logout();
                  Provider.of<ExecutionList>(context, listen: false).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const AuthenticationScreen()),
                      (route) => false);
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const AuthenticationScreen()));
                },
                label: const Text(
                  'Log out',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
