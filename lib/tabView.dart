//import 'package:codedecoders/screens/explore.dart';
//import 'package:codedecoders/screens/heart.dart';

import 'package:westcoachswing/objects/favorites.dart';
import 'package:westcoachswing/screens/directory_screen.dart';
import 'package:westcoachswing/screens/home_page.dart';
import 'package:westcoachswing/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '/screens/feedback.dart';
import '/screens/dashboard.dart';
import 'screens/favorites_screen.dart';
import '/utilities/constants.dart';

class TabView extends StatefulWidget {
//  static String studentID = StudentList().students[1].id;
  final int? index;
  const TabView({Key? key, this.index}) : super(key: key);
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int? _currentIndex = 0;
  bool _navigated = false;
//  bool _isInit = true;

//  @override
//  void didChangeDependencies() {
//    if (_isInit) {
//      Provider.of<Workouts>(context, listen: false).todaysWorkout2(context);
//    }
//
//    _isInit = false;
//    super.didChangeDependencies();
//  }

//  Liste des différents Screen de l'application qui apparaissent dans le menu en bas
  final List<Widget> _children = [
    const HomePage(),
    const DirectoryScreen(),
    FavoritesScreen(),
    const Dashboard(),
//    const FeedbackScreen(),
//    TODO le test screen sera à supprimer pour la version finale
//    TestScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //    initialisation des favoris
    Provider.of<Favorites>(context, listen: false).initFavorites(context);
//    TODO rechanger cette formule qui ne fait pas beaucoup de sens, mais qui marche pour l'instant
    if (widget.index != null && !_navigated) {
      _navigated = true;
      _currentIndex = widget.index;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: kLogoNoir,
        ),
        centerTitle: true,
//        le bouton des paramètre qui est uniquement affiché sur la page du dashboard
        actions: _currentIndex == 3
            ? [
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
//                            CountDownTransitionScreen(drill),
                              const SettingsScreen(),
                        ),
                      );
                    })
              ]
            : null,

//        backgroundColor: Colors.white,
      ),
//      La barre de menu du bas
      bottomNavigationBar: BottomNavigationBar(
//        backgroundColor: Colors.transparent,
        onTap: onTabTapped,
        currentIndex: _currentIndex!,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        iconSize: 32,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Dashboard',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.comment),
          //   label: 'Feedback',
          // ),
        ],
      ),
      body: _children[_currentIndex!],
    );
  }
}
