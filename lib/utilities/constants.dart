import 'package:flutter/material.dart';

//COULEURS :
const Color kActionButtonColor = Colors.pink;
const Color kAppBarColor = Colors.white;
const Color kButtonColor = Colors.black;
const Color kActionButtonTextColor = Colors.black;

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
