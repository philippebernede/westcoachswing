import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:westcoachswing/screens/root_page.dart';
import 'package:westcoachswing/utilities/constants.dart';
import 'package:westcoachswing/objects/drill_list.dart';
import 'package:westcoachswing/objects/student_list.dart';
import 'package:westcoachswing/objects/favorites.dart';
import 'package:westcoachswing/objects/drill_filters.dart';
import 'package:westcoachswing/components/workouts.dart';
import 'package:westcoachswing/objects/execution_list.dart';
import 'package:westcoachswing/components/received_notification.dart';

//------------------------------------------LOCAL NOTIFICATION SETUP------------------------------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String>();

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }

  selectNotificationSubject.add(payload);
}

//----------------------------NEW NOTIFICATION ADD--------------------------------------------------------------
//const MethodChannel platform =
//    MethodChannel('dexterx.dev/flutter_local_notifications_example');

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  String timezone = await FlutterNativeTimezone.getLocalTimezone();
//  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timezone));
}

//-------------------------------------main function-----------------------------------------------

Future<void> main() async {
  bool isConnected = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _configureLocalTimeZone();
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.wifi) {
    isConnected = true;
  } else if (result == ConnectivityResult.mobile) {
    isConnected = true;
  } else {
    isConnected = false;
  }

  //--------------------------START local Notification initialisation NEW-------------------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
    'app_icon',
  );
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DrillList()),
    ChangeNotifierProvider(create: (context) => StudentList()),
  ], child: MyApp(isConnected)));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  bool logo3s = false;
  bool connectionStatus;

  MyApp(this.connectionStatus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
// Checking if there is an internet connection otherwise you call a simple alert dialog box
        if (!connectionStatus) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AlertDialog(
              title: kLogoNoir,
              content: Text(
                  'This App needs a working internet connection, please : \n'
                  '     -verify your connection\n'
                  '     -close the app\n'
                  '     -try again later.'),
//                actions: [
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: FlatButton(
//                      child: Text('OK'),
//                      color: Colors.teal,
//                      onPressed: () {
////     TODO apparently this doesn't work on IOS so we need to check otherwise the option would be to write :  exit(0) but Apple may suspend App so we should find a bette way
////                        SystemNavigator.pop();
//                      },
//                    ),
//                  )
//                ],
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => Favorites(),
                ),
                ChangeNotifierProvider(
                  create: (context) => DrillFilters(),
                ),
//        ChangeNotifierProvider(
//          create: (context) => DrillList(),
//        ),
                ChangeNotifierProvider(
                  create: (context) => Workouts(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ExecutionList(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: RootPage(),
                theme: ThemeData(
//  TODO changer les caractéristiques et le thème en fonction de si c'est IOS ou Android
//                  platform: TargetPlatform.iOS,
                  appBarTheme: const AppBarTheme(
                    color: Colors.white,
                    iconTheme: IconThemeData(color: Colors.teal),
                    actionsIconTheme: IconThemeData(color: Colors.teal),
                  ),
//        bottomAppBarTheme: BottomAppBarTheme(
//          color: Colors.white,
//        ),
                  primarySwatch: Colors.teal,
                  colorScheme: ColorScheme.light(
                    secondary: Colors.teal,
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.teal.withOpacity(0.5),
                  ),
                  textTheme: ThemeData.light().textTheme.copyWith(
                        button: const TextStyle(
                          color: Colors.white,
//                backgroundColor: Theme.of(context).primaryColor,
                        ),
                        bodyText1: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
//                            fontStyle: FontStyle.italic,
                        ),
                        headline6: const TextStyle(
                          color: Colors.black,
                          fontSize: 35.0,
                          letterSpacing: 1.2,
                        ),
                      ),
//        primarySwatch: Colors.white,
                ),
              ),
            );
          } else {
//              TODO verify that this is working and that the logo lasts for 3s and it doesn't work if I add the condition in the if loop below
            Timer(const Duration(seconds: 3), () {
              logo3s = true;
            });
            return Container(
              color: Colors.white,
              child: Center(
                child: ClipRRect(
                  child: Image.asset('assets/LogoAnimatedFast.gif'),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
