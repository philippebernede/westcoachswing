import 'package:cloud_firestore/cloud_firestore.dart';
import '/objects/student.dart';
import '/objects/student_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackForm = GlobalKey<FormState>();
  String dropdownValue = 'General';
  String feedback = '';
  late Map<String, bool>? sentFeedback;
  List<String> sentFeedbackName = [];
  List<bool> sentFeedbackFix = [];

//  void initState() {
//    super.initState();
//    getFeedback();
//  }

//  fonction d'envoi du feedback vers firestore
  Future<void> addFeedback() async {
    Student currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
    try {
      await FirebaseFirestore.instance.collection('feedback').doc().set({
        'Sender Name': '${currentStudent.firstName} ${currentStudent.lastName}',
        'Subject': '$dropdownValue',
        'Feedback': '$feedback',
        'Date':
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        'Fixed': false,
        'Student ID': currentStudent.id,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Thank you for your help.Your feedback has been sent.'),
        ),
      );
//      réinitialisation des champs arpès l'envoi
      _feedbackForm.currentState!.reset();
      dropdownValue = 'General';
    } catch (err) {
//      si l'envoi du feedback n'a pas fonctionné on affiche une snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
              'Thank you for your help. Sadly an error occurred, please try again later.'),
        ),
      );
      print(err.toString());
    }
  }

  Future<void> getFeedback() async {
    Map<String, bool>? _feedbacks;

    Student currentStudent =
        Provider.of<StudentList>(context, listen: false).currentStudent;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('feedback').get();
      querySnapshot.docs.forEach((element) {
        if (element['Sender Name'] ==
                '${currentStudent.firstName} ${currentStudent.lastName}' ||
            element['Student ID'] == currentStudent.id) {
          if (_feedbacks == null) {
            _feedbacks = {element['Feedback']: element['Fixed']};
          } else {
            _feedbacks![element['Feedback']] = element['Fixed'];
          }
        } else {}
      });

      sentFeedback = _feedbacks == null
          ? {'There is no recorded feedback with your Student ID': false}
          : _feedbacks;
//      initialisation des 2 listes
      sentFeedbackName = [];
      sentFeedbackFix = [];
      sentFeedback!.forEach((key, value) {
        sentFeedbackName.add(key);
        sentFeedbackFix.add(value);
      });
// vérification que la liste n'est pas vide sinon on crée un instance pour annoncer qu'il n'y a pas de retours pour l'instant
      if (sentFeedbackName.isEmpty) {
        sentFeedbackName
            .add('There is no recorded feedback with your Student ID');
      }
    } catch (err) {
//      si l'envoi du feedback n'a pas fonctionné on affiche une snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
              'An error occurred while loading your submitted feedbacks, please try again later.'),
        ),
      );
      print(err.toString());
      sentFeedback = null;
    }
  }

  //  fonction pour lancer la vérification des différents champs du formulaire
  void _trySubmit() {
    final isValid = _feedbackForm.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _feedbackForm.currentState!.save();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Are you ready to send your feedback ?'),
          actions: [
            FlatButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                addFeedback();
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
            FlatButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFeedback(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/whiteBrick.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _feedbackForm,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feedback Form',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                          'We want to give you the best experience possible, therefore all your feedbacks are more then welcome to help us improve and to reach your goals'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text('Please select the subject of your feedback'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: const Color(0xffd3dde4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 16,
//                style: TextStyle(color: Colors.deepPurple),
//                underline: Container(
//                  height: 2,
//                  color: Colors.deepPurpleAccent,
//                ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Content',
                                'Design',
                                'Functionality',
                                'General',
                                'Misspelling ',
                                'Performance',
                                'Other',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        key: const ValueKey('Feedback'),
                        autocorrect: true,
                        maxLines: 10,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a feedback';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "CentraleSansRegular"),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xffd3dde4), width: 1)),
                          labelText: "Your feedback here",
                          labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: "CentraleSansRegular"),
                        ),
                        onSaved: (value) {
                          feedback = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: RaisedButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          onPressed: () {
                            _trySubmit();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Text(
                              'Send Feedback',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  height: 1.5),
                            ),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          disabledColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Text('Submitted Feedbacks :'),
                      ...sentFeedbackName
                          .map((e) => Text(
                                '     - "$e"',
                                style: TextStyle(
                                    color: sentFeedback![e]!
                                        ? Colors.green
                                        : Colors.red),
                              ))
                          .toList(),
//
                    ],
                  ),
                ),
              ),
            ),
          ));
        });
  }
}
