import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:westcoachswing/objects/drill.dart';
import 'package:westcoachswing/objects/drill_list.dart';
import 'package:westcoachswing/objects/student_list.dart';

enum Rex { Easy, Perfect, Difficult }
enum SpanSelection { Custom, Week, Month, Year }

class Execution {
  String? id;
  int? drillId;
  String? studentId;
  DateTime? dateTime;
  Rex? rex;

  Execution({this.studentId, this.rex, this.dateTime, this.id, this.drillId});
}

class ExecutedDrills {
  int? drillID;
  int? repetitionCount;
  List<int>? executionsID;

  ExecutedDrills({this.drillID, this.repetitionCount, this.executionsID});
}

class ExecutionList with ChangeNotifier {
  String? studentId;
  ExecutionList([this.studentId]);
  List<Execution> _executions = [];

  List<Execution> get studentExecutions {
    return _executions;
  }

//  création de la liste des éléments exécutés avec le nombre de répétitions par étudiant
  Future<void> getStudentsExecutions() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('execution').get();
//    print(querySnapshot.documents);
//    print(querySnapshot.documents.length);
//    List test = querySnapshot.documents
//        .where((element) => element.data['Student'] == user.uid)
//        .toList();
//    print('${test.length} la liste $test');
    querySnapshot.docs.forEach((element) {
      if (element['Student'] == user!.uid) {
        Execution execution = Execution();
        execution.studentId = element['Student'];
        execution.rex = Rex.values[element['Rex']];
//        final dateToDate = (element.data['DateTime']).toDate;
//        final dateToString = dateToDate.toString();
        execution.dateTime = DateTime.parse(element['DateTime']);
        execution.drillId = element['Drill'];
        execution.id = element.id;
        _executions.add(execution);
//        print(execution.id);

      }
    });
//    notifyListeners();
//    _executions == null
//        ? studentExecutions = []
//        : studentExecutions = _executions.where((element) {
//            if (element.studentId == this.studentId) {
//              return true;
//            } else
//              return false;
//          }).toList();
//    return studentExecutions;
  }

  Map<DateTime, List> executionsForCalendar() {
    Map<DateTime, List> executionMap = {};
    List<Execution> _executionDate = _executions;
    List<Execution> _executionEvent = _executions;
    List<DateTime> dates = [];
    _executionDate.forEach((element) {
      dates.add(DateTime(element.dateTime!.year, element.dateTime!.month,
          element.dateTime!.day));
    });
    dates.sort();
    for (int i = 0; i < dates.length - 1; i++) {
      if (i >= dates.length - 1) {
        break;
      } else if (dates[i] == dates[i + 1]) {
        dates.removeAt(i + 1);
        i = i - 1;
      }
    }
//    dates.removeWhere(
//        (element) => element == dates.elementAt(dates.indexOf(element) + 1));
//    dates.toSet();
//    executionMap=dates.map((e) => {e : _executionEvent.where((exec) => exec.dateTime.year==element.year)});
    dates.forEach((element) => {
          executionMap.putIfAbsent(
              element,
              () => _executionEvent
                  .where((exec) => (exec.dateTime!.year == element.year &&
                      exec.dateTime!.month == element.month &&
                      exec.dateTime!.day == element.day))
                  .toList())
        });

    return executionMap;
  }

//  permet de vider la liste d'Exécution lorsque l'on se déconnecte de l'application
  void logout() {
    _executions = [];
  }

//  List<ExecutedDrills> get executedDrills {
//    List<ExecutedDrills> _executedList = [];
//    int drillID;
//    int repetitionCount;
//
//    List<int> drills = studentsExecutions.map((e) => e.drillId).toList();
//
////    permet d'enlever les doublons dans la liste
//    List<int> singleDrillId = drills.toSet().toList();
//
////    ajout de tous les elements a la liste en récupérant toutes les valeurs d'un  executed drills
//    _executedList = singleDrillId.map((e) {
//      List<int> executionsIDList = [];
//      drillID = e;
//      repetitionCount = countRepetitions(drills, e);
//      studentsExecutions.where((element) {
//        if (element.drillId == e) {
//          executionsIDList.add(element.id);
//
//          return true;
//        } else
//          return false;
//      }).toList();
//      return ExecutedDrills(
//          drillID: drillID,
//          repetitionCount: repetitionCount,
//          executionsID: executionsIDList);
//    }).toList();
//
////    for (int i = 0; i < singleDrillId.length; i++) {
////      List<int> executionsIDList = [];
////      var dID = this.drillID;
////
//////    récupération du numéro de drill
////      this.drillID = singleDrillId[i];
//////    execution de la fonction pour récupérer le nombre de repetitions du drill
////      this.repetitionCount = countRepetitions(drills, singleDrillId[i]);
//////    récupération de la liste des identifiants des executions du drill
////      studentExecutions.where((element) {
////        if (element.drillId == singleDrillId[i]) {
////          executionsIDList.add(element.id);
////
////          return true;
////        } else
////          return false;
////      }).toList();
////
////      this.executionsID = executionsIDList;
////      print(
////          'drillID : ${this.drillID} , repetitionCount : ${this.repetitionCount}, executionIDList : ${this.executionsID}');
//////    ajout de l'instance à la liste que l'on va récupérer
////      var exeDrill = this;
////      _executedList.add(exeDrill);
////      print('longueur de la liste au fur et a mesure ${_executedList.length}');
////      if (_executedList.length == 7) {
////        for (int i = 0; i < _executedList.length; i++) {
////          print(
////              'index: $i , drillID : ${_executedList[i].drillID} , repetitionCount : ${_executedList[i].repetitionCount}, executionIDList : ${_executedList[i].executionsID}');
////        }
////      }
////    }
////    print('longueur de la liste renvoyé ${_executedList.length}');
//////    for (int i = 0; i < _executedList.length; i++) {
//////      print(
//////          'index: $i , drillID : ${_executedList[i].drillID} , repetitionCount : ${_executedList[i].repetitionCount}, executionIDList : ${_executedList[i].executionsID}');
//////    }
//    return _executedList;
//  }

//  ajout d'une nouvelle execution
  void addExecution(Execution execution, BuildContext context) {
    int rex = 0;
//  ajout de l'identifiant en incrémentant de +1 par rapport aux nombres d'executions déjà existantes pour que ca soit unique.
//List<Execution> newExecutionList= executions.length==30 ? executions : newExecutionList;
//    execution.id = executions.length + 1;
//  ajout de l'execution dans la BDD

//  TODO make it async and add a try catch
    try {
      FirebaseFirestore.instance.collection('execution').doc().set(
        {
          'Drill': execution.drillId,
          'DateTime': execution.dateTime!.toIso8601String(),
          'Rex': execution.rex!.index,
          'Student': execution.studentId
        },
      );
    } catch (err) {
      print(err.toString());
    }
//    ajout de l'execution en local pour ne pas avoir à recharger les données lorsqu'on veux afficher le dashboard

//   TODO il faudrait ici lancer l'ajustement des niveaux en fonction des résultats du REX
    _executions.add(execution);
    if (execution.rex!.index == 0) {
      rex = -1;
    } else if (execution.rex!.index == 2) {
      rex = 1;
    } else {
      rex = 0;
    }
    Drill drill = Provider.of<DrillList>(context, listen: false)
        .drillById(execution.drillId!);
    Provider.of<StudentList>(context, listen: false).updateLevels(rex, drill);

//    print('taille de la liste des executions = ${executions.length}');
//
    notifyListeners();
  }

  List<int> executedDrills() {
    List<int> _executedDrills = [];
    _executions.forEach((element) {
      _executedDrills.add(element.drillId!);
    });
    _executedDrills = _executedDrills.toSet().toList();
    return _executedDrills;
  }

  List<int> execDrillsNoEasy() {
    List<int> _executedDrills = [];
    _executions.forEach((element) {
      if (element.rex == Rex.Easy) _executedDrills.add(element.drillId!);
    });
    _executedDrills = _executedDrills.toSet().toList();
    return _executedDrills;
  }

  DateTime lastExecutionDay() {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (_executions.isNotEmpty) {
      _executions.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
      return _executions[0].dateTime!;
    } else {
      return today;
    }
  }

  Map<String, int> getTotalPracticeTimes(
      BuildContext context, DateTime startDate, DateTime endDate) {
    DrillList drillProvider = Provider.of<DrillList>(context, listen: false);
    Map<String, int> totalPracticeTimes = {
      'total': 0,
      'technique': 0,
      'styling': 0,
      'personal skill': 0,
      'partnering skill': 0,
      'musicality': 0,
    };
    List<Execution> executionsDuringTime = [];
    _executions.forEach((element) {
      if (element.dateTime!.isAfter(startDate) &&
          element.dateTime!.isBefore(endDate)) {
        executionsDuringTime.add(element);
      }
    });
    if (executionsDuringTime != []) {
      for (Execution e in executionsDuringTime) {
        Drill drill = drillProvider.drillById(e.drillId!);
//  on travaille en secondes que l'on redivise en minutes par la suite d'ou la division par 60 le ~/ cree un resultat de division en int
        totalPracticeTimes['total'] =
            drill.durationInSeconds + totalPracticeTimes['total']!;
        if (drill.technique!) {
          totalPracticeTimes['technique'] =
              drill.durationInSeconds + totalPracticeTimes['technique']!;
        }
        if (drill.musicality!) {
          totalPracticeTimes['musicality'] =
              drill.durationInSeconds + totalPracticeTimes['musicality']!;
        }
        if (drill.partneringSkill!) {
          totalPracticeTimes['partnering skill'] =
              drill.durationInSeconds + totalPracticeTimes['partnering skill']!;
        }
        if (drill.personalSkill!) {
          totalPracticeTimes['personal skill'] =
              drill.durationInSeconds + totalPracticeTimes['personal skill']!;
        }
        if (drill.styling!) {
          totalPracticeTimes['styling'] =
              drill.durationInSeconds + totalPracticeTimes['styling']!;
        }
      }

//      pour l'instant on a récupéré toutes les durées en secondes donc maintenant on s'assure d'arrondir pour les avoir en minutes et les afficher le ~/ arrondi la division en un INT
      totalPracticeTimes['total'] = totalPracticeTimes['total']! ~/ 60;
      totalPracticeTimes['technique'] = totalPracticeTimes['technique']! ~/ 60;
      totalPracticeTimes['musicality'] =
          totalPracticeTimes['musicality']! ~/ 60;
      totalPracticeTimes['partnering skill'] =
          totalPracticeTimes['partnering skill']! ~/ 60;
      totalPracticeTimes['personal skill'] =
          totalPracticeTimes['personal skill']! ~/ 60;
      totalPracticeTimes['styling'] = totalPracticeTimes['styling']! ~/ 60;
    } else {
      totalPracticeTimes['total'] = 0;
    }
    return totalPracticeTimes;
  }

  //  fonction pour récupérer le nombre de fois qu'un d   print(
  ////        'taille de la liste des executions dun etudiant = ${studentsExecutions.length}');
  ////    print(
  ////        'date et heure de l\'avant derniere execution = ${studentsExecutions[studentsExecutions.length - 1].dateTime}');
  ////    print(
  ////        'Rex de l\'avant derniere execution = ${studentsExecutions[studentsExecutions.length - 1].rex}');rill a été effectué
  int countRepetitions(List<int> e, int drill) {
    if (e == null || e.isEmpty) {
      return 0;
    }

    int count = 0;
    for (int i = 0; i < e.length; i++) {
      if (e[i] == drill) {
        count++;
      }
    }

    return count;
  }
}
