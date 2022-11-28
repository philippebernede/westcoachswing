import '/components/drill_list_renderer.dart';
import '/objects/drill_filters.dart';
import '/objects/drill_list.dart';
import '/screens/search_filter.dart';
import '/utilities/constants.dart';
import '/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String? collectionName;

  const SearchScreen(this.collectionName, {super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? filterName;

////          filteredDrills.sort((a, b) => a.name.compareTo(b.name));
//        }
//        break;
//    }
//    return filteredDrills;
//  }

  @override
  Widget build(BuildContext context) {
    final filterList = Provider.of<DrillFilters>(context, listen: true);
    final drillList = Provider.of<DrillList>(context);
    // Widget sortDrills() {
    //   return Container(
    //     child: Column(
    //       children: [
    //         RadioListTile<>(
    //           title: const Text('Lafayette'),
    //           value: SingingCharacter.lafayette,
    //           groupValue: _character,
    //           onChanged: (SingingCharacter? value) {
    //             setState(() {
    //               _character = value;
    //             });
    //           },
    //         ),
    //         RadioListTile<SingingCharacter>(
    //           title: const Text('Thomas Jefferson'),
    //           value: SingingCharacter.jefferson,
    //           groupValue: _character,
    //           onChanged: (SingingCharacter? value) {
    //             setState(() {
    //               _character = value;
    //             });
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // }
//    DrillList drillList = DrillList();

    return Scaffold(
      //      to make the keyboard overlay instead of pushing everything up
      resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: widget.collectionName != null
//             ? Text('${widget.collectionName} Drills')
//             : kLogoNoir,
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => const SearchFilter(),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.filter_list,
// //          color: Colors.white,
//             ),
//           ),
//         ],
// //        backgroundColor: Colors.white,
//       ),
//  Permet de faire en sorte que le clavier disparaisse si on clique en dehors du textField
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/whiteBrick.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
//          decoration: kBackgroundContainer,
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
//   Espace pour la barre de recherche que pour l'instant on a enlevé car on ne fait pas de recherche par nom
//   pourrait etre remis par la suite
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white30,
                          filled: true,
                          icon: const Icon(
                            Icons.search,
//            color: Colors.white,
                          ),
                          hintText: 'Search through the drills',
//          hintStyle: kTextFieldHintStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (textValue) {
                          filterName = textValue.toLowerCase();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DrillListRenderer(
                    drillList.drillsByFilter(
                      widget.collectionName!,
                      filterList,
                      filterName,
                    ),
                  ),
//                    filteredDrills == null ? _drillList : filteredDrills),
                ),
              ],
            ),
            // Positioned(
            //   top: SizeConfig.blockSizeVertical! * 70,
            //   left: SizeConfig.blockSizeHorizontal! * 43,
            //   child: Container(
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       // borderRadius: BorderRadius.circular(30.0),
            //       color: Colors.teal.withOpacity(0.6),
            //     ),
            //     width: SizeConfig.blockSizeHorizontal! * 14, //30
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (BuildContext context) =>
            //                     const SearchFilter(),
            //               ),
            //             );
            //           },
            //           icon: const Icon(Icons.filter_list),
            //           color: Colors.white,
            //         ),
            //         // IconButton(
            //         //   onPressed: () {
            //         //     // sortDrills();
            //         //   },
            //         //   icon:
            //         //       const Icon(Icons.compare_arrows, color: Colors.white),
            //         // )
            //       ],
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }
}
