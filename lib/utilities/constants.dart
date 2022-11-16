import 'package:flutter/material.dart';

//COULEURS :
const Color kActionButtonColor = Colors.pink;
const Color kAppBarColor = Colors.white;
const Color kButtonColor = Colors.black;
const Color kActionTextColor = Colors.black;
const Color kActionButtonTextColor = Colors.white;

//Theme de l'application

//TEXTES / VALEURS FIXES :

//  liste des niveaux avec nom complet
const List<String> levelListFullLength = [
  'Fundamentals',
  'Level 2',
  'Level 3',
  'Level 4',
  'Level 5'
];

//  liste des niveaux avec nom raccourci
const List<String> levelListShortLength = [
  'Fund',
  'L2',
  'L3',
  'L4',
  'L5',
];

//  liste des rôles
const List<String> kRoleList = [
  'Leader',
  'Follower',
  'Both',
];

//  liste des différents REX possibles
const List<String> kLevelRates = ['Easy', 'Spot on', 'Hard'];

//  liste des différentes collections
const List<Map<String, String>> kCollectionList = [
  {
    'name': 'Styling',
    'image': 'assets/styling.jpg',
    'description':
        'This collection is focused on drills to make you improve your styling.',
  },
  {
    'name': 'Musicality',
    'image': 'assets/musicality.jpg',
    'description':
        'This collection is focused on drills to make you improve your musicality.',
  },
  {
    'name': 'Technique',
    'image': 'assets/technique.jpg',
    'description':
        'This collection is focused on drills to make you improve your technique.',
  },
  {
    'name': 'Partnering Skills',
    'image': 'assets/partneringSkills.jpg',
    'description':
        'This collection is focused on drills to make you improve your connection.',
  },
  {
    'name': 'Personal Skills',
    'image': 'assets/personalSkills.jpg',
    'description':
        'This collection is focused on drills to make you improve your body awareness and personal skills.',
  }
];

//LIENS DES IMAGES :

//  Image logo blanc
const Image kLogoBlanc = Image(
  image: AssetImage(kLogoBlancAddress),
  width: 90.0,
  height: 90.0,
);

//  Image logo noir
const Image kLogoNoir = Image(
  image: AssetImage('assets/logoNoir.png'),
//  width: 120.0,
  height: 55.0,
);

//  lien logo blanc
const String kLogoBlancAddress = 'assets/logoBlanc.png';
//  lien logo noir
const String kLogoNoirAddress = 'assets/logoNoir.png';

//  lien fond d'écran noir
const String kBackgroundAddress = "assets/woodbg.jpg";

//STYLES DES DIFFÉRENTS TEXTES :

const TextStyle kVideoDurationTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.lightBlue,
);

//  titre des qui videos qui apparait sur la video en presentation
const TextStyle kVideoTitleTextStyle = TextStyle(
  fontSize: 25.0,
  color: Colors.black,
);

//  titre de bienvenue
const TextStyle kWelcomeDay = TextStyle(
  color: Colors.white,
  backgroundColor: Colors.teal,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

//  phrase de bienvenue page d'accueil
const TextStyle kWelcomePhrase = TextStyle(
  backgroundColor: Colors.white,
  color: Colors.black,
  fontSize: 21.0,
);

//  typo pour toutes les descriptions et textes généraux
const TextStyle kDescription = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontStyle: FontStyle.italic,
);

//  titre des collections
const TextStyle kCollectionTitle = TextStyle(
  color: Colors.white,
  fontSize: 35.0,
  letterSpacing: 1.2,
);

//  typo pour TextField
const TextStyle kTextFieldHintStyle = TextStyle(
  color: Colors.white,
  fontStyle: FontStyle.italic,
  fontSize: 15.0,
);

//  typo pour Boutons
const TextStyle kActionButtonTextStyle = TextStyle(
  color: kActionButtonTextColor,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

//  typo pour Text
const TextStyle kActionTextStyle = TextStyle(
  color: kActionTextColor,
  fontWeight: FontWeight.bold,
  fontSize: 15.0,
);

//DECORATIONS
const BoxDecoration kBackgroundContainer = BoxDecoration(
  image: DecorationImage(
    image: AssetImage(kBackgroundAddress),
    fit: BoxFit.fill,
  ),
);

// Valeurs fixes pour calendrier
final kToday = DateTime.now();
final DateTime kFirstDay = DateTime(kToday.year, kToday.month, 1);
final DateTime kLastDay = DateTime(kToday.year, kToday.month + 1, 1);

//------------------REVENUE CAT CONSTANTS------------------------------
//TO DO: add the entitlement ID from the RevenueCat dashboard that is activated upon successful in-app purchase for the duration of the purchase.
const entitlementID = 'Regular';

//TO DO: add your subscription terms and conditions
const footerText = """Cancel any time on the App Store.""";

//TO DO: add the Apple API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const appleApiKey = 'appl_jqkcQKikPEuNTlZrERvSWMZOWHr';

//TO DO: add the Google API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const googleApiKey = 'goog_uuyOovAeBplulRXAGjdDlXDbdvi';

// UI Colors
const kColorBar = Colors.white;
const kColorText = Colors.black;
const kColorAccent = Color.fromRGBO(10, 115, 217, 1.0);
const kColorError = Colors.red;
const kColorSuccess = Colors.green;
const kColorNavIcon = Color.fromRGBO(131, 136, 139, 1.0);
const kColorBackground = Color.fromRGBO(30, 28, 33, 1.0);

// Text Styles
const kFontSizeSuperSmall = 10.0;
const kFontSizeNormal = 16.0;
const kFontSizeMedium = 18.0;
const kFontSizeLarge = 96.0;

const kDescriptionTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.normal,
  fontSize: kFontSizeNormal,
  backgroundColor: kColorBar,
);

const kTitleTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.bold,
  fontSize: kFontSizeMedium,
);

// Inputs
const kButtonRadius = 10.0;

const userInputDecoration = InputDecoration(
  fillColor: Colors.black,
  filled: true,
  hintText: 'Enter App User ID',
  hintStyle: TextStyle(color: kColorText),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
);
