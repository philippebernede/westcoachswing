import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/objects/drill.dart';
import '/components/practice_card.dart';
import '/objects/drill_list.dart';
import '/objects/execution_list.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  Map<DateTime, List>? _executions;
  List? _selectedEvents;

  AnimationController? _animationController;
//  CalendarController? _calendarController;
  bool isInit = false;
  DateTime firstCalDay = DateTime(2020, 1, 1);
  DateTime lastCalDay = DateTime(2050, 12, 31);
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();

//    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController!.forward();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final _selectedDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (!isInit) {
      _executions = Provider.of<ExecutionList>(context, listen: false)
          .executionsForCalendar();
    }
    _selectedEvents = _executions![_selectedDay] ?? [];
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
//    _calendarController!.dispose();
  }

  // void _onDaySelected(DateTime day, List executions, List holidays) {
  //   print('CALLBACK: _onDaySelected');
  //   setState(() {
  //     _selectedDay = day;
  //     _selectedEvents = executions.cast<Execution>();
  //   });
  // }

  List _getEventsfromDay(DateTime date) {
//     if (date.weekday == 1 &&
//         date != _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1)) &&
//         format != CalendarFormat.values[_focusedDayCheck]) {
//       _onPageChanged(date);
//       if (_focusedDayCheck + 1 == 3) {
//         _focusedDayCheck = 0;
//       } else {
//         _focusedDayCheck = _focusedDayCheck + 1;
//       }
// //       _focusedDayCheck++;
// // format = CalendarFormat.values[!_focusedDayCheck];
//     }
//     print(CalendarFormat.values[_focusedDayCheck]);
    DateTime selectedDayConv =
        date.toLocal().subtract(date.toLocal().timeZoneOffset);
    return _executions![selectedDayConv] ?? [];
  }

  void _onVisibleDaysChanged(DateTime? start, DateTime? end, DateTime? focus) {
    print('VisibleDaysChanged: Start : $start , End : $end , Calendar $focus');
    setState(() {
      startDate = DateTime(start!.year, start.month, start.day);
      endDate = DateTime(end!.year, end.month, end.day, 23, 59, 59);
    });
  }

  void _onPageChanged(focusedDay) {
    _selectedEvents =
        []; //on vide la liste des events lorsqu'on change de page car la journée sélectionné n'y apparaitra plus
    DateTime focusDayInter;
    _focusedDay = focusedDay;
    setState(() {
      if (format == CalendarFormat.month) {
        startDate = DateTime(_focusedDay.year, _focusedDay.month, 1);
        endDate = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
      } else if (format == CalendarFormat.twoWeeks) {
        focusDayInter = _focusedDay
            .subtract(
              Duration(days: _focusedDay.weekday - 1),
            )
            .subtract(
              const Duration(days: 7),
            ); // on retire 7 jours car le début du calendrier commence 1 ligne avant celle du focusDay;;
        startDate = DateTime(
            focusDayInter.year, focusDayInter.month, focusDayInter.day);
        endDate = startDate.add(const Duration(days: 14));
      } else if (format == CalendarFormat.week) {
        focusDayInter =
            _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
        startDate = DateTime(
            focusDayInter.year, focusDayInter.month, focusDayInter.day);

        endDate = startDate.add(const Duration(days: 7));
      }

      print(
          "OnPageChanged : start date : $startDate end date : $endDate format : $format focused Day : $_focusedDay");
    });
  }

  void _onFormatChanged(CalendarFormat _format) {
    DateTime focusDayInter;
    setState(() {
      if (_format == CalendarFormat.month) {
        startDate = DateTime(_focusedDay.year, _focusedDay.month, 1);
        endDate = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
      } else if (_format == CalendarFormat.twoWeeks) {
        focusDayInter =
            _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
        startDate =
            DateTime(focusDayInter.year, focusDayInter.month, focusDayInter.day)
                .subtract(
          const Duration(
              days:
                  7), // on retire 7 jours car le début du calendrier commence 1 ligne avant celle du focusDay
        );

        endDate = startDate.add(const Duration(days: 14));
      } else if (_format == CalendarFormat.week) {
        focusDayInter =
            _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
        startDate = DateTime(
            focusDayInter.year, focusDayInter.month, focusDayInter.day);
        endDate = startDate.add(const Duration(days: 7));
      }
      print(
          "OnFormatChanged : start date : $startDate end date : $endDate format : $_format focused Day : $_focusedDay weekday ${_focusedDay.weekday + 1}");
      format = _format;
    });
  }

  Color collectionColor(Drill drill) {
    const Color colorTechnique = Color(0xff962300);
    const Color colorStyling = Color(0xff00968c);
    const Color colorMusicality = Color(0xff460096);
    const Color colorPartnering = Color(0xff966e00);
    const Color colorPersonal = Color(0xff000a96);
    if (drill.technique!) return colorTechnique;
    if (drill.styling!) return colorStyling;
    if (drill.musicality!) return colorMusicality;
    if (drill.partneringSkill!) return colorPartnering;
    if (drill.personalSkill!) return colorPersonal;
//    cas où on n'est pas rentré dans aucun if et donc la valeur par défaut est blanc
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        PracticeCard(startDate, endDate),
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
//        _buildButtons(),
//        const SizedBox(height: 8.0),
        _buildExecutionList(),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return Card(
      child: TableCalendar(
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        firstDay: firstCalDay,
        lastDay: lastCalDay,
        focusedDay: _focusedDay,
        availableGestures: AvailableGestures.none,
        calendarFormat: format,
//      TODO changer la hauteur des lignes
        rowHeight: 40.0,
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.black),
        ),
//        calendarController: _calendarController,
//        events: _executions,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            DateTime selectedDayConv = _selectedDay.toLocal().subtract(_selectedDay
                .toLocal()
                .timeZoneOffset); //conversion to non UTC format but still keeping it at Midnight

            _selectedEvents = _executions![selectedDayConv] ?? [];
          });
        },
        onPageChanged: _onPageChanged,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onRangeSelected: _onVisibleDaysChanged,
        eventLoader: _getEventsfromDay,
        onFormatChanged: _onFormatChanged,
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          weekendTextStyle: TextStyle(color: Colors.black),
//          highlightToday: true,
//          selectedColor: Theme.of(context).accentColor,
//          todayStyle: const TextStyle(color: Colors.red),
//          todayColor: Theme.of(context).accentColor.withOpacity(0.3),
//          markersColor: Theme.of(context).accentColor.withOpacity(0.7),
          outsideDaysVisible: false,
          markersAutoAligned: true,
          markerDecoration:
              BoxDecoration(color: Color(0xB3009688), shape: BoxShape.circle),
          selectedDecoration:
              BoxDecoration(color: Color(0xFF009688), shape: BoxShape.circle),
          todayDecoration:
              BoxDecoration(color: Color(0x66009688), shape: BoxShape.circle),
        ),
        headerStyle: HeaderStyle(
          formatButtonShowsNext:
              true, //shows the actual format and the the upcoming format between 2 weeks, week and month
          formatButtonTextStyle:
              const TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),

//TODO changer eventuellement l'apparence de la journée d'aujourdh'hui pour que ca soit plus visible

//        builders: CalendarBuilders(
//          todayDayBuilder: (context, date, _) {
//            return CircleAvatar(
//              backgroundColor: Colors.red,
//              radius: 8.0,
//              child: CircleAvatar(
//                radius: 16.0,
//                backgroundColor: Colors.white,
//                child: Container(
////              decoration: BoxDecoration(
////                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
//                  margin: const EdgeInsets.all(4.0),
//                  padding: const EdgeInsets.all(4.0),
////                  color: Colors.deepOrange[300],
////                width: 100,
////                height: 100,
//                  child: Text(
//                    '${date.day}',
//                  ),
//                ),
//              ),
//            );
//          },
//        ),
//        onDaySelected: _onDaySelected,
//        onVisibleDaysChanged: _onVisibleDaysChanged,
//      onCalendarCreated: _onCalendarCreated,
      ),
    );
  }

// supprimé NETTOYAGE-------------------------------------------------------------------------------------------------------------------
//  Widget _buildButtons() {
//    final dateTime = _executions.keys.elementAt(_executions.length - 2);
//
//    return Column(
//      children: <Widget>[
//        Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            RaisedButton(
//              child: Text('Month'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.month);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('2 weeks'),
//              onPressed: () {
//                setState(() {
//                  _calendarController
//                      .setCalendarFormat(CalendarFormat.twoWeeks);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('Week'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.week);
//                });
//              },
//            ),
//          ],
//        ),
//        const SizedBox(height: 8.0),
//        RaisedButton(
//          child: Text(
//              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//          onPressed: () {
//            _calendarController.setSelectedDay(
//              DateTime(dateTime.year, dateTime.month, dateTime.day),
//              runCallback: true,
//            );
//          },
//        ),
//      ],
//    );
//  }

//  reprise à ne pas supprimer ---------------------------------------------------------------------------------------------------------------------
  Widget _buildExecutionList() {
    DrillList drills = Provider.of<DrillList>(context, listen: false);
    return _selectedEvents!.isNotEmpty
        ? Column(
//      physics: NeverScrollableScrollPhysics(),
            children: _selectedEvents!
                .map(
                  (event) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.5,
                          color: collectionColor(
                              drills.drillById(event.drillId!))),
                      borderRadius: BorderRadius.circular(12.0),
//                      color: collectionColor(drills.drillById(event.drillId)),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      leading: Container(
                        width: SizeConfig.blockSizeHorizontal! * 15,
                        child: Image.asset(
                            drills.drillById(event.drillId!).imageLink!),
//                         CachedNetworkImage(
//                           imageUrl: drills.drillById(event.drillId!).imageLink!,
// //          placeholder: (context, url) => CircularProgressIndicator(),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         ),
                      ),
                      title: Text(drills.drillById(event.drillId!).name!),
                      trailing: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
//                          '${DateFormat.yMd().format(event.dateTime)}\n'
                          '${DateFormat.jm().format(event.dateTime!)}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      onTap: () => print('$event tapped!'),
                    ),
                  ),
                )
                .toList(),
          )
        : Column(
            children: [
              const Text('Oh no! You didn\'t practice that day'),
              Image.asset(
                'assets/sleeping.png',
                width: SizeConfig.blockSizeHorizontal! * 50,
              ),
            ],
          );
  }
}
