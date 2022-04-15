import 'package:flutter/material.dart';

import 'drill_list_listtile.dart';
import '/objects/drill.dart';
import '/utilities/size_config.dart';

class DrillListRenderer extends StatelessWidget {
  final List<Drill>? _drillList;
  const DrillListRenderer(this._drillList, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (_drillList!.isEmpty || _drillList == null) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('There are no drills that match your selection\n'),
            Image.asset(
              'assets/surprised-dog.png',
              height: SizeConfig.blockSizeVertical! * 50,
              width: SizeConfig.blockSizeHorizontal! * 50,
            )
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return DrillListTile(
            drill: _drillList![index],
          );
        },
        itemCount: _drillList!.length,
      );
    }
  }
}
