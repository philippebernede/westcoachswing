import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:westcoachswing/objects/student_list.dart';

import 'drill.dart';
import 'drill_list.dart';

class Favorites with ChangeNotifier {
  int? studentID;
  List<int>? favoriteDrillID = [];
  List<Drill>? _favoriteList;

  void initFavorites(BuildContext context) {
    favoriteDrillID = Provider.of<StudentList>(context, listen: false)
        .currentStudent
        .favorites;
  }

  List<Drill> getFavoriteDrills(BuildContext context) {
    List<Drill> drillList =
        Provider.of<DrillList>(context, listen: false).drillList;

    _favoriteList = [];

//    on vérifie que la liste des favoris de l'étudiant n'est pas nulle
    if (favoriteDrillID != null) {
//   ajout des différents favoris dans la liste pour pouvoir les afficher
      for (int i = 0; i < favoriteDrillID!.length; i++) {
        favoriteDrillID!.sort();
        int drillID = favoriteDrillID![i];
        _favoriteList!
            .add(drillList.firstWhere((drill) => drill.id == drillID));
      }
    }
    return _favoriteList!;
  }

  bool isFavorite(int id) {
    bool isFav = false;
    for (int i = 0; i < favoriteDrillID!.length; i++) {
      if (id == favoriteDrillID![i]) {
        isFav = true;
      }
    }
    return isFav;
  }

  void addFavorite(int id, BuildContext context) async {
    final _currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
//    adding selected drill to local favorites
    favoriteDrillID!.add(id);
//    updating online Database with the new drill
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_currentStudent.id)
          .update({
        'Favorites': favoriteDrillID,
      });
    } catch (err) {
      print(err.toString());
    }

    notifyListeners();
  }

  void removeFavorite(int id, BuildContext context) async {
    final _currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
    favoriteDrillID!.removeWhere((element) => element == id);
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_currentStudent.id)
          .update({
        'Favorites': favoriteDrillID,
      });
    } catch (err) {
      print(err.toString());
    }
    notifyListeners();
  }
}
