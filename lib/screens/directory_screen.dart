import '/components/collection_renderer.dart';
import '/components/collection_viewer.dart';
import 'package:flutter/material.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const <Widget>[
          CollectionViewer(
            title: 'All Collections',
            imageLink: 'assets/all.jpg',
            description: 'Go find out all the drills here',
          ),
          CollectionRenderer(
            isScrollable: false,
          ),
//            Container(
//                height: SizeConfig.blockSizeVertical * 60,
//                child: DrillListRenderer(_drillList)),
        ],
      ),
    );
  }
}
