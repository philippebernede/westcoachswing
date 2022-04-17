import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/objects/student_list.dart';
import '/objects/student.dart';
import '/objects/execution_list.dart';
import '/screens/authentication_screen.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
          'Are you sure you want to completly delete your account? (all your informations will be lost)'),
      actions: [
        TextButton(
            child: Text(
              'Yes, delete my account permanently',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () async {
              await deleteAccount(context).then((_) async {
                //    suppression de l'utilisateur Firebase une fois que toutes les autres choses sont finis
                User? user = FirebaseAuth.instance.currentUser;
//                print('deleteaccount/deleteUser/this is the user : $user');
                Provider.of<StudentList>(context, listen: false).logout();
                Provider.of<ExecutionList>(context, listen: false).logout();
                try {
//                  print('before user deletion');
                  user!.delete();
//                  print('after user deletion');
                } catch (err) {
                  // print('deleteaccounts/deleteUser : ${err.toString()}');
                }
              });

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen()));
            }),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    Student _currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
//suppression de toutes les exécutions faite par l'étudiant
    List<Execution> executionList =
        Provider.of<ExecutionList>(context, listen: false).studentExecutions;
    try {
      executionList.forEach((exec) async {
        await FirebaseFirestore.instance
            .collection('execution')
            .doc(exec.id)
            .delete();
      });
//      print('deleteaccount/deleteExecutions/executions done');
    } catch (err) {
      // print('deleteaccount/deleteExecutions : ${err.toString()}');
    }

//suppression de la liste des workouts de l'étudiant
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(_currentStudent.id)
          .delete();
//      print('deleteaccount/deleteWorkouts/workouts done');
    } catch (err) {
      // print('deleteAccount/deleteWorkouts : ${err.toString()}');
    }
    //suppression de l'étudiant
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_currentStudent.id)
          .delete();
//      print('deleteaccount/deleteStudent/students done');
    } catch (err) {
      // print('deleteaccounts/deleteStudent : ${err.toString()}');
    }
  }
}
