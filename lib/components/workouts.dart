import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:westcoachswing/objects/drill.dart';
import 'package:westcoachswing/objects/drill_list.dart';
import 'package:westcoachswing/objects/execution_list.dart';
import 'package:westcoachswing/objects/student.dart';
import 'package:westcoachswing/objects/student_list.dart';

class Workouts with ChangeNotifier {
//  TODO changer les drills avec drill_logic pour avoir les bonnes liste qui ne changeront pas une fois setté
  bool? soloCoupleSwitch;
  int? selectedWorkoutKey;
  int activeSelectionIndex = 0;
//  TODO mettre les workouts de base si on viens de créer un nouvel étudiant
  Map<int, List<int>> workouts = {
    0: [86],
    1: [20, 27, 52],
    2: [27, 2, 44, 86, 38],
  };
  Map<int, List<int>> soloWorkouts = {};

  set workoutList(Map<int, List<int>> workoutList) {
    workouts[0] = workoutList[0]!;
    workouts[1] = workoutList[1]!;
    workouts[2] = workoutList[2]!;
  }

  void selectedWorkout(int index, BuildContext context, [int? drillId]) {
    DrillList drillList = Provider.of<DrillList>(context, listen: false);
    if (drillId != null) {
      selectedWorkoutKey = index;
      activeSelectionIndex = 0;
      drillList.setSelectedDrillById = drillId;
    } else {
      selectedWorkoutKey = index;
      activeSelectionIndex = 0;
      drillList.setSelectedDrillById = workouts[index]![activeSelectionIndex];
    }

    notifyListeners();
  }

  List<Drill> getUpcomingDrills(BuildContext context) {
    DrillList drillList = Provider.of<DrillList>(context, listen: false);
    List<Drill> _upcomingDrills = [];
    if (activeSelectionIndex < workouts[selectedWorkoutKey]!.length) {
      for (int i = activeSelectionIndex + 1;
          i < workouts[selectedWorkoutKey]!.length;
          i++) {
        _upcomingDrills
            .add(drillList.drillById(workouts[selectedWorkoutKey]![i]));
      }
      return _upcomingDrills;
    } else {
      return _upcomingDrills = [];
    }
  }

  String getSingleDrillName(BuildContext context) {
    DrillList drillList = Provider.of<DrillList>(context, listen: false);
    Drill drill = drillList.drillById(workouts[0]![0]);
    return drill.name!;
  }

  List<int> getWorkoutDurations(DrillList drillList) {
//    DrillList drillList = Provider.of<DrillList>(context, listen: false);
    List<int> durations = [];
    int durationShortWorkout = 0;
    int durationLongWorkout = 0;
//  récupération durée drill seul
    int durationSingleDrill =
        drillList.durationInSecByDrillId(workouts[0]![0]) ~/ 60;
//  récupération durée pratique courte
    for (int i = 0; i < workouts[1]!.length; i++) {
      durationShortWorkout = durationShortWorkout +
          drillList.durationInSecByDrillId(workouts[1]![i]);
    }
    durationShortWorkout = durationShortWorkout ~/ 60;
//  récupération durée pratique longue
    for (int i = 0; i < workouts[2]!.length; i++) {
      durationLongWorkout = durationLongWorkout +
          drillList.durationInSecByDrillId(workouts[2]![i]);
    }
    durationLongWorkout = durationLongWorkout ~/ 60;
    durations = [
      durationSingleDrill,
      durationShortWorkout,
      durationLongWorkout,
    ];
    return durations;
  }

  int nextWorkout(BuildContext context) {
    DrillList drillList = Provider.of<DrillList>(context, listen: false);
    activeSelectionIndex++;
//    renvoi 0 si le workout est fini
    if (activeSelectionIndex >= workouts[selectedWorkoutKey]!.length) {
      activeSelectionIndex = 0;
//      notifyListeners();
      return activeSelectionIndex;
    } else {
      drillList.setSelectedDrillById =
          workouts[selectedWorkoutKey]![activeSelectionIndex];
//      notifyListeners();
      return workouts[selectedWorkoutKey]![activeSelectionIndex];
    }
  }

//  Ancien algorythme pas fini ---------------------------------------------------------------------------------------------------------------------------------------------------------
//  Map<int, List<int>> todaysWorkout(BuildContext context) {
//    ExecutionList _executionList =
//        Provider.of<ExecutionList>(context, listen: false);
//    StudentList _studentList = Provider.of<StudentList>(context, listen: false);
//    List<Drill> _drills =
//        Provider.of<DrillList>(context, listen: false).drillList;
//    Student _currentStudent = _studentList.currentStudent;
//    DateTime today = DateTime(
//      DateTime.now().year,
//      DateTime.now().month,
//      DateTime.now().day,
//    );
//    if (_currentStudent.lastSignIn.isBefore(today)) {
////TODO: on fait le nouveau calcul et on incrément de un la série
////    TODO: changer le key 'technique' pour mettre la logique par rapport à la derniere pratique par un des 5
//      String key = 'technique';
//      int level = _currentStudent.levels[key];
//      List<Drill> _filteredDrills2 = [];
//      List<Drill> _filteredDrills3 = [];
//      List<int> _executedDrills = _executionList.executedDrills();
//// première filtration en fonction du focus principal du jour
//      List<Drill> _filteredDrills1 =
//          _drills.where((element) => element.skills[key]);
//// deuxieme filtration on retire tous les drills que l'étudiant a déjà fait
//      _executedDrills.forEach((element) {
//        _filteredDrills1.removeWhere((drill) => drill.id == element);
//      });
//// si l'étudiant a déjà fait tous les drills de ce skill il faut refaire le processus en ignorant les drills déjà fait. Sinon cette étape est juste sauté car la liste n'est pas vide
//      if (_filteredDrills1.isEmpty)
//        _filteredDrills1 = _drills.where((element) => element.skills[key]);
//// deuxième filtration en fonction du niveau de l'étudiant
//      _filteredDrills2 =
//          _filteredDrills1.where((element) => element.level.index == level);
//// on vérifie que le résultat n'est pas nul et si il est nul on augmente le niveau de 1 sauf si on est déjà au niveau max et dans ce cas on descend de 1
//      if (_filteredDrills2.isEmpty) {
//        level = level + 1 == 5 ? level - 1 : level + 1;
//        _filteredDrills2 =
//            _filteredDrills1.where((element) => element.level.index == level);
//        _filteredDrills3 = _filteredDrills2;
//      }
//// seconde vérification par rapport au niveau. Si à +-1 la liste est tjs vide c'est que l'étudiant a déjà fait tous les exercices de ces niveaux et dans ce cas on recommence à zéro
//
//// si la liste est plus longue que 5 on peux ajouter un filtre sur les autres catégories
//
//// tri des drills de façon aléatoire
//      _filteredDrills1.shuffle();
//      workouts[0] = [_filteredDrills1[0].id];
//      _filteredDrills1.shuffle();
//      workouts[1] = [
//        _filteredDrills1[0].id,
//        _filteredDrills1[1].id,
//        _filteredDrills1[2].id
//      ];
//      _filteredDrills1.shuffle();
//      workouts[2] = [
//        _filteredDrills1[0].id,
//        _filteredDrills1[1].id,
//        _filteredDrills1[2].id,
//        _filteredDrills1[3].id,
//        _filteredDrills1[4].id
//      ];
//      return workouts;
////      TODO prendre un cas par défaut si la liste filtrée est vide car la personne a déjà fait tous les drills ou peut être prendre les drills avec un niveau de difficulté supérieur
//
//    }
//  }

//  ---------------------------------------------------DÉBUT ALGORITHME COUPLE-----------------------------------------------------------------------------------
//  Algorithme particulier pour les exercices en couple
  Map<int, List<int>> todaysCoupleWorkout(BuildContext context, String key) {
    Map<int, List<int>> coupleWorkouts = {};
    coupleWorkouts[3] = [];
    ExecutionList _executionList =
        Provider.of<ExecutionList>(context, listen: false);
    StudentList _studentList = Provider.of<StudentList>(context, listen: false);
    List<Drill> _drills =
        Provider.of<DrillList>(context, listen: false).drillList;
    Student _currentStudent = _studentList.currentStudent;
    List<String> _keyList = [
      'technique',
      'styling',
      'personalSkill',
      'partneringSkill',
      'musicality'
    ];

    List<Drill> _filteredDrills1 = [];
    List<Drill> _filteredDrills2 = [];
    List<Drill> _filteredDrills3 = [];
// on récupère uniquement les exercices qu'ils n'ont pas indiqué comme trop simple
    List<int> _executedDrills = _executionList.execDrillsNoEasy();

// première filtration en fonction du focus principal du jour
//    si ils ont séléctioné random dans ce cas on prends l'ensemble des drills de couple sinon on filtre également avec par le sujet choisi
    if (key == 'random') {
      _filteredDrills1 = drillListFilter(
        _drills,
        'couple',
      );
      _filteredDrills1 = _drills
          .where((element) => element.partner == Partner.Couple)
          .toList();
    } else {
      _filteredDrills1 = _drills
          .where((element) =>
              element.partner == Partner.Couple && element.skills[key]!)
          .toList();
    }

    //si la liste est vide ça veut dire que l'on n'a pas d'exercice qui correspond pas à cette catégorie pour l'instant si elle n'est pas vide
    //alors on passe à la deuxième filtration
    if (_filteredDrills1.isEmpty) {
      coupleWorkouts[0] = [];
      coupleWorkouts[1] = [];
      coupleWorkouts[2] = [];
      coupleWorkouts[3] = [11111];
    } else {
// deuxieme filtration on retire tous les drills que l'étudiant a déjà fait
      _executedDrills.forEach((element) {
        _filteredDrills1.removeWhere((drill) => drill.id == element);
      });

// si l'étudiant a déjà fait tous les drills de ce skill on renvoi une erreur allDone=99999 en demandant si les personnes veulent réinitialiser leur
// drills exécuté ou si ils veulent changer de catégorie si ce n'est pas en random
      if (key == 'random' && _filteredDrills1.isEmpty) {
        _filteredDrills1 = _drills
            .where((element) => element.partner == Partner.Couple)
            .toList();
        coupleWorkouts[3] = [99999];
      } else if (key != 'random' && _filteredDrills1.isEmpty) {
        coupleWorkouts[0] = [];
        coupleWorkouts[1] = [];
        coupleWorkouts[2] = [];
        coupleWorkouts[3] = [99999];
      } else if (key != 'random' && _filteredDrills1.length < 5) {
        _filteredDrills2 = _drills
            .where((element) => element.skills[_currentStudent.workoutKey == 4
                ? _keyList[0]
                : _keyList[_currentStudent.workoutKey! + 1]]!)
            .toList();
        _filteredDrills2 = _filteredDrills1 + _filteredDrills2;
      } else {
        _filteredDrills2 = _filteredDrills1;
      }
    }
    //  filtration en fonction de la catégorie compétitive de l'étudiant limité à un niveau au dessus de leur niveau actuel
    _filteredDrills2 = _filteredDrills1
        .where(
            (element) => element.level!.index < _currentStudent.category! + 2)
        .toList();

    //      on vérifie que filteredDrills2 a plus de 5 drills sinon on reprend la liste de base
    if (_filteredDrills2.length < 5) {
      _filteredDrills2 = _filteredDrills1;
    }

    _filteredDrills3 = _filteredDrills2;

    //vérification que l'on n'a pas d'erreur 11111(pas de drill pour la catégorie) ou 99999(déjà fait tous les drills)
    if (listEquals(coupleWorkouts[3], [])) {
      // tri des drills de façon aléatoire
      _filteredDrills3.shuffle();
      coupleWorkouts[0] = [_filteredDrills3[0].id!];
      int workout0Duration = _filteredDrills3[0].durationInSeconds;
      _filteredDrills3.shuffle();
      int workout1Duration = _filteredDrills3[0].durationInSeconds +
          _filteredDrills3[1].durationInSeconds +
          _filteredDrills3[2].durationInSeconds;
      while (workout1Duration < workout0Duration) {
        _filteredDrills3.shuffle();
        workout1Duration = _filteredDrills3[0].durationInSeconds +
            _filteredDrills3[1].durationInSeconds +
            _filteredDrills3[2].durationInSeconds;
      }
      coupleWorkouts[1] = [
        _filteredDrills3[0].id!,
        _filteredDrills3[1].id!,
        _filteredDrills3[2].id!
      ];

      _filteredDrills3.shuffle();
      int workout2Duration = _filteredDrills3[0].durationInSeconds +
          _filteredDrills3[1].durationInSeconds +
          _filteredDrills3[2].durationInSeconds +
          _filteredDrills3[3].durationInSeconds +
          _filteredDrills3[4].durationInSeconds;
      while (workout2Duration < workout1Duration) {
        _filteredDrills3.shuffle();
        workout2Duration = _filteredDrills3[0].durationInSeconds +
            _filteredDrills3[1].durationInSeconds +
            _filteredDrills3[2].durationInSeconds +
            _filteredDrills3[3].durationInSeconds +
            _filteredDrills3[4].durationInSeconds;
      }
      coupleWorkouts[2] = [
        _filteredDrills3[0].id!,
        _filteredDrills3[1].id!,
        _filteredDrills3[2].id!,
        _filteredDrills3[3].id!,
        _filteredDrills3[4].id!
      ];
      //TODO je viens de retirer cette ligne et j'ai ajouté cet élément dans l'initialisation vérifier que ça marche
      // if (key != 'random') coupleWorkouts[3] = [];

// on met à jour la liste des workouts
      workouts[0] = coupleWorkouts[0]!;
      workouts[1] = coupleWorkouts[1]!;
      workouts[2] = coupleWorkouts[2]!;
    }
    return coupleWorkouts;
  }

//  ---------------------------------------------------FIN ALGORITHME COUPLE-----------------------------------------------------------------------------------

// -------------------------------Nouvel algorithme comme Flore le voulais--------------------------------------------------------------------------------------------------------------------------
  Future<void> todaysWorkout2(BuildContext context,
      [bool? firstConnection]) async {
    String key = 'technique'; //initialisation du thème
    ExecutionList _executionList =
        Provider.of<ExecutionList>(context, listen: false);
    StudentList _studentList = Provider.of<StudentList>(context, listen: false);
    List<Drill> _drills =
        Provider.of<DrillList>(context, listen: false).drillList;
    Student _currentStudent = _studentList.currentStudent;
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    List<String> _keyList = [
      'technique',
      'styling',
      'personalSkill',
      'partneringSkill',
      'musicality'
    ];
//    we make sure that if we didn't pass the firstconnection it means that we are not in the firstconnection so we set the var to false
    firstConnection ??= false;
    if ((_executionList.lastExecutionDay().isBefore(today) &&
            _currentStudent.lastSignIn!.isBefore(today)) ||
        firstConnection) {
//TODO: on fait le nouveau calcul et on incrément de un la série
//    TODO: changer le key 'technique' pour mettre la logique par rapport à la derniere pratique par un des 5
      _studentList.updateStudentWorkoutKey();
      key = _keyList[_currentStudent.workoutKey!];

//      int level = _currentStudent.levels[key]; plus besoin de cette ligne si on ne prend pas en compte le niveau de l'étudiant
      List<Drill> _filteredDrills1 = [];
      List<Drill> _filteredDrills2 = [];
      List<Drill> _filteredDrills3 = [];
// on récupère uniquement les exercices qu'ils n'ont pas indiqué comme trop simple
      List<int> _executedDrills = _executionList.execDrillsNoEasy();

//  filtration pour avoir uniquement les drills solo
      _filteredDrills1 = drillListFilter(_drills, 'solo');

// première filtration en fonction du focus principal du jour
      _filteredDrills1 =
          _filteredDrills1.where((element) => element.skills[key]!).toList();

// filtration en fonction du rôle si le rôle est both pas besoin de filtrer car tous les drills s'appliquent si par contre c'est lead ou follow dans ce cas il faut filtrer
      if (_currentStudent.role != Role.Both) {
        _filteredDrills1 = _filteredDrills1
            .where((element) => element.role == _currentStudent.role)
            .toList();
      }

// deuxieme filtration on retire tous les drills que l'étudiant a déjà fait uniquement si la liste filteredDrills1 est > à 5
      if (_filteredDrills1.length > 5) {
        _executedDrills.forEach((element) {
          _filteredDrills1.removeWhere((drill) => drill.id == element);
        });
      }
// si l'étudiant a déjà fait tous les drills de ce skill il faut refaire le processus en ignorant les drills déjà fait. Sinon cette étape est juste sauté car la liste n'est pas vide
      if (_filteredDrills1.isEmpty) {
        _filteredDrills2 =
            _drills.where((element) => element.skills[key]!).toList();
        if (_currentStudent.role != Role.Both) {
          _filteredDrills2 = _filteredDrills2
              .where((element) => element.role == _currentStudent.role)
              .toList();
        }
      }
//  si il y a moins de 5 drills dans la liste alors on prend la catégorie du jour suivant
      else if (_filteredDrills1.length < 5) {
//          TODO : changer la formule de skill key pour accéder à la catégorie du jour d'après
        _filteredDrills2 = _drills
            .where((element) => element.skills[_currentStudent.workoutKey == 4
                ? _keyList[0]
                : _keyList[_currentStudent.workoutKey! + 1]]!)
            .toList();
        _filteredDrills2 = _filteredDrills1 + _filteredDrills2;
      } else {
        _filteredDrills2 = _filteredDrills1;
      }
//      on vérifie que filteredDrills2 a plus de 5 drills sinon on reprend la liste de base
      if (_filteredDrills2.length < 5) {
        _filteredDrills2 =
            _drills.where((element) => element.skills[key]!).toList();
      }
//// filtration en fonction du role lead/follow/both
//      _filteredDrills3 = _filteredDrills2
//          .where((element) => element.role == _currentStudent.role)
//          .toList();
//  filtration en fonction de la catégorie compétitive de l'étudiant limité à un niveau au dessus de leur niveau actuel
      _filteredDrills3 = _filteredDrills2
          .where(
              (element) => element.level!.index < _currentStudent.category! + 2)
          .toList();
// vérification que la liste contient tjs au moins 5
      if (_filteredDrills3.length < 5) {
        _filteredDrills3 = _filteredDrills2;
      }

// TODO: pour optimiser si la liste est plus longue que 5 on peux ajouter un filtre sur les autres sous-catégories

// tri des drills de façon aléatoire et vérification que la durée du workout0<duree workout1<duree workout2
      _filteredDrills3.shuffle();
      workouts[0] = [_filteredDrills3[0].id!];
      int workout0Duration = _filteredDrills3[0].durationInSeconds;
      _filteredDrills3.shuffle();
      int workout1Duration = _filteredDrills3[0].durationInSeconds +
          _filteredDrills3[1].durationInSeconds +
          _filteredDrills3[2].durationInSeconds;
      while (workout1Duration < workout0Duration) {
        _filteredDrills3.shuffle();
        workout1Duration = _filteredDrills3[0].durationInSeconds +
            _filteredDrills3[1].durationInSeconds +
            _filteredDrills3[2].durationInSeconds;
      }
      workouts[1] = [
        _filteredDrills3[0].id!,
        _filteredDrills3[1].id!,
        _filteredDrills3[2].id!
      ];

      _filteredDrills3.shuffle();
      int workout2Duration = _filteredDrills3[0].durationInSeconds +
          _filteredDrills3[1].durationInSeconds +
          _filteredDrills3[2].durationInSeconds +
          _filteredDrills3[3].durationInSeconds +
          _filteredDrills3[4].durationInSeconds;
      while (workout2Duration < workout1Duration) {
        _filteredDrills3.shuffle();
        workout2Duration = _filteredDrills3[0].durationInSeconds +
            _filteredDrills3[1].durationInSeconds +
            _filteredDrills3[2].durationInSeconds +
            _filteredDrills3[3].durationInSeconds +
            _filteredDrills3[4].durationInSeconds;
      }

      workouts[2] = [
        _filteredDrills3[0].id!,
        _filteredDrills3[1].id!,
        _filteredDrills3[2].id!,
        _filteredDrills3[3].id!,
        _filteredDrills3[4].id!
      ];

//      on met à jour la base de données avec la liste des workout qui viens d'être créé pour la journée
      try {
        await FirebaseFirestore.instance
            .collection('workouts')
            .doc(_currentStudent.id)
            .update(
          {
            'Workouts 0': workouts[0],
            'Workouts 1': workouts[1],
            'Workouts 2': workouts[2],
            'Student': _currentStudent.id,
          },
        );
        soloWorkouts[0] = workouts[0]!;
        soloWorkouts[1] = workouts[1]!;
        soloWorkouts[2] = workouts[2]!;
      } catch (err) {
        // print('workouts/todaysWorkout2/updateData : ${err.toString()}');
      }
    } else {
//      on récupère simplement le workout qui est déjà dans la base de données
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('workouts').get();
        DocumentSnapshot documentSnapshot = querySnapshot.docs
            .firstWhere((element) => element['Student'] == _currentStudent.id);
        workouts[0] = documentSnapshot['Workouts 0'].cast<int>();
        workouts[1] = documentSnapshot['Workouts 1'].cast<int>();
        workouts[2] = documentSnapshot['Workouts 2'].cast<int>();
        soloWorkouts[0] = workouts[0]!;
        soloWorkouts[1] = workouts[1]!;
        soloWorkouts[2] = workouts[2]!;
//        return workouts;
      } catch (err) {
        // print(
        //     'workouts/todaysWorkout2/querysnapshot getDocuments : ${err.toString()}');
      }
    }

//      TODO prendre un cas par défaut si la liste filtrée est vide car la personne a déjà fait tous les drills ou peut être prendre les drills avec un niveau de difficulté supérieur

//    }

//    sinon on va chercher la série actuelle
//    else {
//      workouts = {
//        0: [10],
//        1: [5, 2, 10],
//        2: [4, 7, 8, 3, 10],
//      };

//    TODO logique pour la série actuelle
//    }
  }

  List<Drill> drillListFilter(List<Drill> initialList, String filter,
      [Student? student, List<int>? executedDrills]) {
    List<Drill> filteredList = [];
    switch (filter) {
      case 'couple':
        filteredList = initialList
            .where((element) => element.partner == Partner.Couple)
            .toList();
        break;
      case 'solo':
        filteredList = initialList
            .where((element) => element.partner == Partner.Solo)
            .toList();
        break;
      case 'role':
        student!.role == Role.Both
            ? filteredList = initialList
            : filteredList = initialList
                .where((element) => element.role == student.role)
                .toList();
        break;
      case 'executed':
        executedDrills!.forEach((element) {
          initialList.removeWhere((drill) => drill.id == element);
        });
        filteredList = initialList;
        break;
      case 'level':
        filteredList = initialList
            .where((element) => element.level!.index < student!.category! + 2)
            .toList();
    }
    return filteredList;
  }

//   vérification que la liste des drills contient au moins 5 éléments sinon ajouté le nombre de drills manquants sinon prendre la liste filtrée précédente
  List<Drill> verifFiveDrill(List<Drill> _verifList, List<Drill> _originList) {
    if (_verifList.isEmpty) {
      _verifList = _originList;
    } else if (_verifList.length < 6 && _verifList.isNotEmpty) {
      bool existsInFilter = false;
      for (int i = _verifList.length; i < 6; i++) {
        _verifList.forEach((element) {
          if (_originList[i - _verifList.length] == element) {
            existsInFilter = true;
          }
        });
        if (!existsInFilter) _verifList.add(_originList[i - _verifList.length]);
        existsInFilter = false;
      }
    }
    return _verifList;
  }
}
