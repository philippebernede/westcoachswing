import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:westcoachswing/objects/student.dart';
import 'drill.dart';

class StudentList with ChangeNotifier {
  bool initialized = false;
//  StudentList() {
//    initStudent();
//  }

  Student currentStudent = Student();

  Future<void> initStudent(BuildContext context) async {
    if (!initialized) {
      User? user = FirebaseAuth.instance.currentUser;
      try {
        final studentData = await FirebaseFirestore.instance
            .collection('students')
            .doc(user!.uid)
            .get();
        currentStudent.id = user.uid;
        currentStudent.firstName = studentData.data()!['First Name'];
        currentStudent.lastName = studentData.data()!['Last Name'];
        currentStudent.email = studentData.data()!['Email'];
        currentStudent.role = convertToRole(studentData.data()!['Role']);
        currentStudent.category = studentData.data()!['Category'];
//   verifie que l'on a bien rempli la catégorie et le role sinon on renvoi sur la page More Info
//        TODO: on pourrait mettre un AlertDialog pour préciser que l'on est renvoyé car il y a eu un problème lors de l'enregistrement
        if (currentStudent.role == null || currentStudent.category == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                //TODO cette partie est à remettre à l'originale
                //ancien texte a remettre
                // builder: (context) => MoreInfo(authResult.user!.uid)),

                //debut test nouvelle partie à changer
                builder: (context) => const AlertDialog(
                      title: Text("Title"),
                      content: Text(
                          'I am in student_list and should have gone to More Info'),
                    )
                //fin test nouvelle partie a changer

                ),
          );
        }

//        Role.Follower

//    List favorites = studentData['Favorites'];
//
//    List intFavorites = favorites.map((e) => e as int).toList();
// converts a List<dynamic> to List<int>
        currentStudent.favorites = studentData.data()!['Favorites'].cast<int>();
        currentStudent.notificationTime =
            studentData.data()!['Notification Time'];
        currentStudent.notificationDays =
            studentData['Notification Days'].cast<bool>();
        currentStudent.workoutKey = studentData.data()!['Workout Key'];
        if (studentData.data()!.containsKey('Last Sign In')) {
          String date = studentData.data()!['Last Sign In'].toString();
          int year = int.parse(date.substring(4, 8));
          int month = int.parse(date.substring(2, 4));
          int day = int.parse(date.substring(0, 2));
          currentStudent.lastSignIn = DateTime(year, month, day);
        }
//      currentStudent.lastSignIn = studentData['Last Sign In'];
        initialized = true;
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .update({
          'Last Sign In': DateFormat('ddMMy').format(DateTime.now()).toString()
        });

//      notifyListeners();
      } catch (err) {
        print('workouts/studentList/initStudent : ${err.toString()}');
      }
    }
  }

  void logout() {
    initialized = false;
    currentStudent = Student();
  }

  set setRole(Role role) {
    currentStudent.role = role;
  }

  set setNotificationsDay(List<bool> notifDays) {
    currentStudent.notificationDays = notifDays;
  }

  set setNotificationsTime(String notifTime) {
    currentStudent.notificationTime = notifTime;
  }

  set setCategory(int category) {
    currentStudent.category = category;
  }

//  Student get getStudent {
//    Student _student =
//        students.firstWhere((element) => element.id == TabView.studentID);
//    return _student;
//  }

  String get studentsFirstName {
//    Student _student =
//        students.firstWhere((element) => element.id == TabView.studentID);
//    return _student.firstName;
    return currentStudent.firstName!;
  }

  Future<void> updateStudentProfile(Student student) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(currentStudent.id)
          .update({
        'First Name': student.firstName,
        'Last Name': student.lastName,
        'Role': student.role.toString(),
        'Category': student.category,
      });
      currentStudent.firstName = student.firstName;
      currentStudent.lastName = student.lastName;
      currentStudent.role = student.role;
      currentStudent.category = student.category;
    } catch (err) {
      print(err.toString());
    }

//    final studentIndex =
//        students.indexWhere((element) => element.id == student.id);
//    students[studentIndex] = student;
//    print('student updated');
  }

  Future<void> updateStudentNotification() async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(currentStudent.id)
          .update({
        'Notification Time': currentStudent.notificationTime,
        'Notification Days': currentStudent.notificationDays,
      });
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> updateStudentWorkoutKey() async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(currentStudent.id)
          .update({
        'Workout Key':
            currentStudent.workoutKey == 4 ? 0 : currentStudent.workoutKey! + 1,
      });
      currentStudent.workoutKey =
          currentStudent.workoutKey == 4 ? 0 : currentStudent.workoutKey! + 1;
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> updateLevels(int rex, Drill drill) async {
// rex est égal à -1 , 0 ou +1 en fonction du rex de l'execution
    Map<String, int> levels =
        currentStudent.levels == null ? {} : currentStudent.levels!;
    if (rex != 0) {
      drill.skills.forEach(
        (key, value) {
          if (!levels.containsKey(key)) {
            levels.putIfAbsent(key, () => 0);
          }
          int level = levels[key]! + rex > Level.values.length
              ? Level.values.length
              : (levels[key]! + rex < 0 ? 0 : levels[key]! + rex);
          if (value) levels[key] = level;
        },
      );
    }
    currentStudent.levels = levels;
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(currentStudent.id)
          .update({
        'Levels': levels,
      });
    } catch (err) {
      print(err.toString());
    }
  }

  Role convertToRole(String rol) {
    Role? role;
    switch (rol) {
      case 'Role.Leader':
        {
          role = Role.Leader;
        }
        break;
      case 'Role.Follower':
        {
          role = Role.Follower;
        }
        break;
      case 'Role.Both':
        {
          role = Role.Both;
        }
        break;
    }
    return role!;
  }
}
