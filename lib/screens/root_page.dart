import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:westcoachswing/objects/drill_list.dart';
import 'package:westcoachswing/components/workouts.dart';
import 'package:westcoachswing/objects/execution_list.dart';
import 'package:westcoachswing/objects/student_list.dart';
import 'package:westcoachswing/screens/authentication_screen.dart';
import '/tabView.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus? _authStatus;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    setState(() {
      _authStatus = user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
    });
  }

//  renvoi sur le bon écran selon si on est déjà connecté ou pas
  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return AuthenticationScreen();

      case AuthStatus.signedIn:
        Future<void> executionList =
            Provider.of<ExecutionList>(context, listen: false)
                .getStudentsExecutions();
//        on initialise les workout du jour seulement une fois que l'on a récupéré les informations de l'etudiant en cours et avant de lancer l'application avec la home page
        Future<void> studentList =
            Provider.of<StudentList>(context, listen: false)
                .initStudent(context)
                .then((_) => Provider.of<Workouts>(context, listen: false)
                    .todaysWorkout2(context));
        Future<void> drillList =
            Provider.of<DrillList>(context, listen: false).initDrills();

        return FutureBuilder(
            future: Future.wait([
              studentList,
              executionList,
              drillList,
              Future.delayed(const Duration(seconds: 3))
            ]),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TabView();
              } else {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: ClipRRect(
                        child: Image.asset('assets/LogoAnimatedFast.gif')),
                  ),
                );
              }
            });
      default:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Image.asset('assets/LogoAnimatedFast.gif'),
          ),
        );
    }
//        });
  }
}
