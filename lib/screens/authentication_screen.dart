import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '/components/authentication_form.dart';
import '/objects/execution_list.dart';
import '/objects/student_list.dart';
// import 'package:westcoachswing/screens/more_info.dart';
import '/tabView.dart';
import '/utilities/constants.dart';
import '/objects/drill_list.dart';
import '/components/workouts.dart';
import '/screens/more_info.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
//  formule que l'on va utiliser dans authentication form pour soumettre les informations
  void _submitAuthForm(
    String email,
    String password,
    String firstName,
    String lastName,
    bool isLogin,
    bool resetPassword,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (resetPassword) {
        try {
          await _auth.sendPasswordResetEmail(email: email);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('A password reset link has been sent to $email'),
              backgroundColor: Theme.of(ctx).colorScheme.secondary,
            ),
          );
        } catch (error) {
          String errorMessage;
          error.toString() == "ERROR_USER_NOT_FOUND"
              ? errorMessage = "Sorry, we couldn't find a user with this email."
              : errorMessage =
                  "An undefined error happened. Please contact the support team.";

          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Theme.of(ctx).colorScheme.secondary,
            ),
          );

          print(error);
        }

        setState(() {
          _isLoading = false;
        });
        return;
      }
//      cas ou la personne ce login avec son mot de passe
      if (isLogin && !resetPassword) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Future<void> executionList =
            Provider.of<ExecutionList>(ctx, listen: false)
                .getStudentsExecutions();
        Future<void> studentList = Provider.of<StudentList>(ctx, listen: false)
            .initStudent(ctx)
            .then((_) =>
                Provider.of<Workouts>(ctx, listen: false).todaysWorkout2(ctx));
        Future<void> drillList =
            Provider.of<DrillList>(ctx, listen: false).initDrills();
        Future.wait([studentList, executionList, drillList]).then((value) =>
            Navigator.pushReplacement(
              ctx,
              MaterialPageRoute(
                builder: (context) => FutureBuilder(
                  future: Future.wait([studentList, executionList, drillList]),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const TabView();
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: ClipRRect(
                            child: Image.asset('assets/LogoAnimatedFast.gif'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ));
      } else {
        //cas où la personne se crée un compte dans se cas on crée l'utilisateur sur firebase et on initialise la liste des drills
        await Provider.of<DrillList>(ctx, listen: false).initDrills();
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        try {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(authResult.user!.uid)
              .set({
            'First Name': firstName,
            'Last Name': lastName,
            'Email': email,
            'Favorites': [],
            'Last Sign In':
                DateFormat('ddMMy').format(DateTime.now()).toString(),
            'Workout Key': 0,
          });
        } catch (err) {
          print('authentication_screen/students/setData : ${err.toString()}');
        }
        try {
          await FirebaseFirestore.instance
              .collection('workouts')
              .doc(authResult.user!.uid)
              .set(
            {
              'Workouts 0': [86],
              'Workouts 1': [22, 27, 52],
              'Workouts 2': [27, 2, 44, 86, 38],
              'Student': authResult.user!.uid,
            },
          );
        } catch (err) {
          print('authentication_screen/workouts/setData : ${err.toString()}');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MoreInfo(authResult.user!.uid)),
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
//    isLogin && !resetPassword
//        ? Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(builder: (context) => TabView()),
//          )
//        : Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => MoreInfo(authResult.user.uid)),
//          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundAddress),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter)),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//            padding: EdgeInsets.all(10),
                  children: <Widget>[
                    const Center(
//                      TODO changer le logo de l'application
                      child: kLogoBlanc,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                        child: AuthenticationForm(_submitAuthForm, _isLoading)),

//TODO sera certainement a ajouté plus tard
//              MaterialButton(
//                color: Colors.blueAccent,
//                minWidth: 330,
//                height: 70,
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    side: BorderSide(color: Colors.white, width: 3)),
//                onPressed: () {},
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Icon(
//                      LineAwesomeIcons.facebook_official,
//                      color: Colors.white,
//                      size: 40,
//                    ),
//                    Text(
//                      "Connect with Facebook",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontFamily: "CentraleSansRegular",
//                          fontSize: 18,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 20,
//              ),
//              MaterialButton(
//                minWidth: 330,
//                height: 70,
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                    side: BorderSide(color: Colors.grey, width: 3)),
//                onPressed: () {
//                  Navigator.pushReplacement(context,
//                      MaterialPageRoute(builder: (context) => HomePage()));
//                },
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Text(
//                      "Continue as Guest",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontFamily: "CentraleSansRegular",
//                          fontSize: 18,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                ),
//              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
