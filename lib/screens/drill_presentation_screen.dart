import 'package:cached_network_image/cached_network_image.dart';
import '/components/drill_list_listtile.dart';
import '/objects/drill.dart';
import '/objects/drill_list.dart';
import '/utilities/constants.dart';
import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drill_screen.dart';

class DrillPresentationScreen extends StatelessWidget {
  final drillId;
  final List<int>? workoutDrillsId;
  final String? workoutName;
  DrillPresentationScreen(this.drillId,
      [this.workoutDrillsId, this.workoutName]);
  @override
  Widget build(BuildContext context) {
    final drillList = Provider.of<DrillList>(context, listen: false);
    Drill drill = drillList.drillById(drillId);
    List<Drill> workoutDrills = [];
//    TODO ajouter ceci lorsqu'on voudra ajouter la liste des autres drills à venir
    if (workoutDrillsId != null) {
      workoutDrills =
          workoutDrillsId!.map((e) => drillList.drillById(e)).toList();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
//   TODO faire en sorte que l'on puisse voir la liste des autres drills à venir si on scroll vers le bas tout en gardant la même page de base
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  child: Image.asset(
                    drill.imageLink!,
                    fit: BoxFit.cover,
                  ),
                  height: workoutDrillsId != null &&
                          workoutDrillsId!.length != 1
                      ? SizeConfig.blockSizeVertical! * 80
                      : (workoutDrillsId != null && workoutDrillsId!.length == 1
                          ? SizeConfig.blockSizeVertical! * 90
                          : SizeConfig.blockSizeVertical! * 100),
                ),
                // Image.asset(drill.imageLink!),
//                 CachedNetworkImage(
//                   imageUrl: drill.imageLink!,
//                   imageBuilder: (context, imageProvider) => Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     height:
//                         workoutDrillsId != null && workoutDrillsId!.length != 1
//                             ? SizeConfig.blockSizeVertical! * 80
//                             : (workoutDrillsId != null &&
//                                     workoutDrillsId!.length == 1
//                                 ? SizeConfig.blockSizeVertical! * 90
//                                 : SizeConfig.blockSizeVertical! * 100),
//                   ),
//
// //          placeholder: (context, url) => CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
                Positioned(
                  top: SizeConfig.blockSizeVertical! * 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    width: SizeConfig.blockSizeHorizontal! * 95,
                    child: Text(
                      workoutName == null ? drill.name! : workoutName!,
                      style: Theme.of(context).textTheme.headline6,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
// ajout logo en fonction de lead follow ou both et en fonction du niveau de difficulté et solo/couple
                if (workoutName == null)
                  Positioned(
                      top: 30.0,
                      right: 25.0,
                      child: ClipOval(
                        child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.9),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      drill.partner == Partner.Solo
                                          ? Icons.person
                                          : Icons.people,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      drill.role == Role.Leader
                                          ? 'L'
                                          : (drill.role == Role.Follower
                                              ? 'F'
                                              : 'L & F'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    for (int i = 0;
                                        i < drill.level!.index + 1;
                                        i++)
                                      const Icon(
                                        Icons.star,
                                        color: Colors.white,
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                Positioned(
                  bottom: 20.0,
//                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: RaisedButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
//                            CountDownTransitionScreen(drill),

                                DrillScreen(drill.id!),
                          ),
                        );
//                      SingleDrillBottomSheet();
                      },
                      child: const Text(
                        "Let's start working!",
                        style: kActionButtonTextStyle,
                      ),
                    ),
                  ),
                ),
//            Container(
////              child: SingleDrillBottomSheet(),
////            ),
              ],
            ),
            if (workoutDrillsId != null)
              ...workoutDrills
                  .map((e) => DrillListTile(
                        drill: e,
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }
}
