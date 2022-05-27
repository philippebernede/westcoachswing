import '/components/calendar_view.dart';
import '/objects/execution_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DateFormat formatter = DateFormat('d-MMM-y');
//  List<bool> _selectedSpan = [true, false, false, false];
  bool byDuration = true;
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  Map<String, int>? practiceTimes;

//-----------------------------------------------------methods---------------------------------
  void spanSelector(selectedSpan) {
    switch (selectedSpan) {
      case SpanSelection.Week:
        {
          setState(() {
            endDate = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);
            startDate = endDate.subtract(Duration(days: endDate.weekday));
          });
          break;
        }
      case SpanSelection.Month:
        {
          setState(() {
            endDate = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);
            startDate = DateTime(endDate.year, endDate.month, 1);
          });
          break;
        }
      case SpanSelection.Custom:
        {
          AlertDialog test = AlertDialog(
            title: const Text('Select your dates'),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  Text(DateFormat('d/MM/y').format(startDate)),
                  FlatButton(
                    child: const Text('Start Date'),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      DateTime? dateValue = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          // startDate == null ? DateTime.now() : startDate,
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2030));
                      setState(() {
                        startDate = dateValue!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(DateFormat('d/MM/y').format(endDate)),
                  FlatButton(
                    child: const Text('End Date'),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: endDate,
                              // endDate == null ? DateTime.now() : endDate,
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2030))
                          .then((dateValue) {
                        setState(() {
                          endDate = dateValue!;
                        });
                      });
                    },
                  ),
                ],
              ),
            ],
          );
          showDialog(context: context, builder: (BuildContext context) => test);
//          showDialog(context: context, child: Text('Test'));
//          showDatePicker(
//              context: context,
//              initialDate: DateTime.now(),
//              firstDate: DateTime(2017),
//              lastDate: DateTime(2025));
          break;
        }
      case SpanSelection.Year:
        {
          break;
        }
    }
  }

//-----------------------------------------build-------------------------------------
  @override
  Widget build(BuildContext context) {
//    ExecutionList execProvider =
//        Provider.of<ExecutionList>(context, listen: false);
//    practiceTimes =
//        execProvider.getTotalPracticeTimes(context, startDate, endDate);
//    int totalCategoryTime = practiceTimes['technique'] +
//        practiceTimes['musicality'] +
//        practiceTimes['styling'] +
//        practiceTimes['personal skill'] +
//        practiceTimes['partnering skill'];
    return const Scaffold(
      body: SingleChildScrollView(
        child: CalendarView(),
      ),
    );
//remettre cette seule ligne active si ce que je fais au dessus ne fonctionne pas
    //    return VideoCarousel();
  }
}

//supprimé NETTOYAGE
//Widget toggleItem(String text, bool isSelected, BuildContext context) {
//  return Padding(
//    padding: const EdgeInsets.all(4.0),
//    child: FlatButton(
//      child: Text(text),
//      disabledColor: isSelected ? Theme.of(context).accentColor : Colors.white,
//      disabledTextColor: isSelected ? Colors.white : Colors.black,
//      shape: RoundedRectangleBorder(
//          side: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
//          borderRadius: BorderRadius.circular(30.0)),
//    ),
//  );
//}
