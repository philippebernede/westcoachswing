import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/objects/execution_list.dart';

class PracticeCard extends StatelessWidget {
  const PracticeCard(this.startDate, this.endDate, {Key? key})
      : super(key: key);

  final DateTime startDate;
  final DateTime endDate;
  final Color colorTechnique = const Color(0xff962300);
  final Color colorStyling = const Color(0xff00968c);
  final Color colorMusicality = const Color(0xff460096);
  final Color colorPartnering = const Color(0xff966e00);
  final Color colorPersonal = const Color(0xff000a96);
  final TextStyle textColorTechnique =
      const TextStyle(color: Color(0xff962300));
  final TextStyle textColorStyling = const TextStyle(color: Color(0xff00968c));
  final TextStyle textColorMusicality =
      const TextStyle(color: Color(0xff460096));
  final TextStyle textColorPartnering =
      const TextStyle(color: Color(0xff966e00));
  final TextStyle textColorPersonal = const TextStyle(color: Color(0xff000a96));

  @override
  Widget build(BuildContext context) {
    ExecutionList execProvider =
        Provider.of<ExecutionList>(context, listen: false);
    Map<String, int> practiceTimes =
        execProvider.getTotalPracticeTimes(context, startDate, endDate);
    int totalCategoryTime = practiceTimes['technique']! +
        practiceTimes['musicality']! +
        practiceTimes['styling']! +
        practiceTimes['personal skill']! +
        practiceTimes['partnering skill']!;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
//        TODO ajuster la hauteur de la carte
          height: 120.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${practiceTimes['total']}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const Text('min'),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                      Center(
                        child: PieChart(
                          PieChartData(
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              startDegreeOffset: 270,
                              centerSpaceRadius: double.infinity,
                              sections: showingSections(practiceTimes)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      practiceTimes['total'] == 0
                          ? Text(
                              '0 %',
                              style: textColorTechnique,
                            )
                          : Text(
                              '${(practiceTimes['technique']! / totalCategoryTime * 100).round()} %',
                              style: textColorTechnique,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      practiceTimes['total'] == 0
                          ? Text(
                              '0 %',
                              style: textColorStyling,
                            )
                          : Text(
                              '${(practiceTimes['styling']! / totalCategoryTime * 100).round()} %',
                              style: textColorStyling,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      practiceTimes['total'] == 0
                          ? Text(
                              '0 %',
                              style: textColorMusicality,
                            )
                          : Text(
                              '${(practiceTimes['musicality']! / totalCategoryTime * 100).round()} %',
                              style: textColorMusicality,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      practiceTimes['total'] == 0
                          ? Text(
                              '0 %',
                              style: textColorPartnering,
                            )
                          : Text(
                              '${(practiceTimes['partnering skill']! / totalCategoryTime * 100).round()} %',
                              style: textColorPartnering,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                      practiceTimes['total'] == 0
                          ? Text(
                              '0 %',
                              style: textColorPersonal,
                            )
                          : Text(
                              '${(practiceTimes['personal skill']! / totalCategoryTime * 100).round()} %',
                              style: textColorPersonal,
                            ),
                    ],
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Technique',
                        style: textColorTechnique,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Styling',
                        style: textColorStyling,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Musicality',
                        style: textColorMusicality,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Partnering Skills',
                        style: textColorPartnering,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Personal Skills',
                        style: textColorPersonal,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, int> practiceTimes) {
    return List.generate(5, (i) {
//      final isTouched = i == touchedIndex;
      const double radius = 10;
      final int totalCategoryTime = practiceTimes['technique']! +
          practiceTimes['musicality']! +
          practiceTimes['styling']! +
          practiceTimes['personal skill']! +
          practiceTimes['partnering skill']!;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colorTechnique,
            value: practiceTimes['total'] == 0.0
                ? 0.0
                : (practiceTimes['technique']! / totalCategoryTime * 100)
                    .round()
                    .toDouble(),
            showTitle: false,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: colorStyling,
            value: practiceTimes['total'] == 0.0
                ? 0.0
                : (practiceTimes['styling']! / totalCategoryTime * 100)
                    .round()
                    .toDouble(),
            showTitle: false,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: colorMusicality,
            value: practiceTimes['total'] == 0.0
                ? 0.0
                : (practiceTimes['musicality']! / totalCategoryTime * 100)
                    .round()
                    .toDouble(),
            showTitle: false,
            radius: radius,
          );
        case 3:
          return PieChartSectionData(
            color: colorPartnering,
            value: practiceTimes['total'] == 0.0
                ? 0.0
                : (practiceTimes['partnering skill']! / totalCategoryTime * 100)
                    .round()
                    .toDouble(),
            showTitle: false,
            radius: radius,
          );
        case 4:
          return PieChartSectionData(
            color: colorPersonal,
            value: practiceTimes['total'] == 0
                ? 0.0
                : (practiceTimes['personal skill']! / totalCategoryTime * 100)
                    .round()
                    .toDouble(),
            showTitle: false,
            radius: radius,
          );
        default:
          return PieChartSectionData();
      }
    });
  }
}
