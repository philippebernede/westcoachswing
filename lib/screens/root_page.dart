import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:westcoachswing/objects/drill_list.dart';
import 'package:westcoachswing/components/workouts.dart';
import 'package:westcoachswing/objects/execution_list.dart';
import 'package:westcoachswing/objects/student_list.dart';
import 'package:westcoachswing/screens/authentication_screen.dart';
import 'package:westcoachswing/screens/paywall.dart';
import 'package:westcoachswing/utilities/constants.dart';
import 'package:westcoachswing/utilities/size_config.dart';
import 'package:westcoachswing/utilities/singletons_data.dart';
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
    initPlatformState();
    super.initState();
    User? user = _auth.currentUser;
    setState(() {
      _authStatus = user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
    });
  }

  void performMagic() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    // if (customerInfo.entitlements.all[entitlementID] != null &&
    //     customerInfo.entitlements.all[entitlementID].isActive == true) {
    //   appData.currentData = WeatherData.generateData();
    //
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } else {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: "Error", content: e.message, buttonText: 'OK'));
    }

    if (offerings == null || offerings.current == null) {
      // offerings are empty, show a message to your user
    }
    // else {
    //   // current offering is available, show paywall
    //   await showModalBottomSheet(
    //     useRootNavigator: true,
    //     isDismissible: false, //todo: change to false once testing is done
    //     isScrollControlled: true,
    //     backgroundColor: kColorBackground,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    //     ),
    //     context: context,
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //           builder: (BuildContext context, StateSetter setModalState) {
    //         return Paywall(
    //           offering: offerings!.current,
    //         );
    //       });
    //     },
    //   );
    // }
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    if (_auth.currentUser == null) {
      // configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      configuration = PurchasesConfiguration(Platform.isIOS
          ? 'appl_jqkcQKikPEuNTlZrERvSWMZOWHr'
          : 'goog_uuyOovAeBplulRXAGjdDlXDbdvi')
        ..observerMode = false;

      await Purchases.configure(configuration);
    } else {
      // configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      configuration = PurchasesConfiguration(Platform.isIOS
          ? 'appl_jqkcQKikPEuNTlZrERvSWMZOWHr'
          : 'goog_uuyOovAeBplulRXAGjdDlXDbdvi')
        ..appUserID = _auth.currentUser!.uid
        ..observerMode = false;

      await Purchases.configure(configuration);

      appData.appUserID = await Purchases.appUserID;

      Purchases.addCustomerInfoUpdateListener(
        (customerInfo) async {
          appData.appUserID = await Purchases.appUserID;

          CustomerInfo customerInfo = await Purchases.getCustomerInfo();
          (customerInfo.entitlements.all[entitlementID] != null &&
                  customerInfo.entitlements.all[entitlementID]!.isActive)
              ? appData.entitlementIsActive = true
              : appData.entitlementIsActive = false;

          //setState(() {});
        },
      );
    }
  }

//  renvoi sur le bon écran selon si on est déjà connecté ou pas
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return const AuthenticationScreen();

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
              // Future.delayed(const Duration(seconds: 3))
            ]),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (appData.entitlementIsActive) {
                  return const TabView();
                } else {
                  performMagic();
                  return const TabView();
                } // sinon renvoyer vers le paywall
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

class ShowDialogToDismiss extends StatelessWidget {
  final String? content;
  final String? title;
  final String? buttonText;

  const ShowDialogToDismiss(
      {Key? key, this.title, this.buttonText, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: Text(
          title!,
        ),
        content: Text(
          content!,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              buttonText!,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title!,
          ),
          content: Text(
            content!,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                buttonText![0].toUpperCase() +
                    buttonText!.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}
