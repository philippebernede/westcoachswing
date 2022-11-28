import '/components/filter_button.dart';
import '/objects/drill_filters.dart';
import '/objects/drill_list.dart';
import '/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final List<bool> _isOpen = [true, true, true, true];
  @override
  Widget build(BuildContext context) {
    final filterList = Provider.of<DrillFilters>(context);
    final drillList = Provider.of<DrillList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Hero(tag: 'logo', child: kLogoNoir),
        backgroundColor: Colors.white,
        centerTitle: true,
//        toolbarOpacity: 1.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              filterList.setFilters(filterList);
              Navigator.pop(context);

//  TODO: ajouter ici la fonction pour réinitialiser tous les filtres
            },
          ),
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              filterList.initializeFilters();
//   TODO: ajouter le changement de statut de la page précédente en fonction des filtres sélectionnés
              Navigator.pop(context);
            },
          ),
        ],
//        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/whiteBrick.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//            TODO Refactor Text+Row pour raccourcir le fichier
                  const SizedBox(
                    height: 10.0,
                  ),
                  // const Text(
                  //   'Select your Filters :',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 20.0),
                  // ),
                  //
                  // const Divider(
                  //   thickness: 2.0,
                  // ),
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
// ------------------------ADDING CATEGORIES FILTER--------------------------------------------------------------------

                  ExpansionPanelList(
                    expansionCallback: (int i, isOpen) =>
                        setState(() => _isOpen[i] = !isOpen),
                    children: [
                      ExpansionPanel(
                        isExpanded: _isOpen[0],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            'Category',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                        body: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    FilterButton(
                                        'Technique', filterList.technique,
                                        (bool newValue) {
                                      filterList.technique = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton(
                                        'Musicality', filterList.musicality,
                                        (newValue) {
                                      filterList.musicality = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('Styling', filterList.styling,
                                        (newValue) {
                                      filterList.styling = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('Partnering Skills',
                                        filterList.partneringSkill, (newValue) {
                                      filterList.partneringSkill = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('Personal Skills',
                                        filterList.personalSkill, (newValue) {
                                      filterList.personalSkill = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ExpansionPanel(
                        isExpanded: _isOpen[1],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            'Role',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                        body: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FilterButton('Leader', filterList.leader,
                                (bool newValue) {
                              filterList.leader = newValue;
                              setState(() {
                                filterList.setFilters(filterList);
                              });
                            }),
                            FilterButton('Follower', filterList.follower,
                                (newValue) {
                              filterList.follower = newValue;
                              setState(() {
                                filterList.setFilters(filterList);
                              });
                            }),
                          ],
                        ),
                      ),
                      ExpansionPanel(
                        isExpanded: _isOpen[2],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            'Type',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                        body: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FilterButton('Solo', filterList.solo, (newValue) {
                              filterList.solo = newValue;
                              setState(() {
                                filterList.setFilters(filterList);
                              });
                            }),
                            FilterButton('Couple', filterList.couple,
                                (newValue) {
                              filterList.couple = newValue;
                              setState(() {
                                filterList.setFilters(filterList);
                              });
                            }),
                          ],
                        ),
                      ),
                      ExpansionPanel(
                        isExpanded: _isOpen[3],
                        headerBuilder: (context, isOpen) {
                          return Text(
                            'Level(s)',
                            style: Theme.of(context).textTheme.headline5,
                          );
                        },
                        body: Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    FilterButton('Fund', filterList.fundamental,
                                        (newValue) {
                                      filterList.fundamental = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('L2', filterList.L2,
                                        (newValue) {
                                      filterList.L2 = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('L3', filterList.L3,
                                        (newValue) {
                                      filterList.L3 = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('L4', filterList.L4,
                                        (newValue) {
                                      filterList.L4 = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                    FilterButton('L5', filterList.L5,
                                        (newValue) {
                                      filterList.L5 = newValue;
                                      setState(() {
                                        filterList.setFilters(filterList);
                                      });
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

//---------------------END OF CATEGORIES FILTER----------------------------------------------------------
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () {
                  filterList.setFilters(filterList);
                  Navigator.pop(context);
                },
                child: Text(
                    'Show ${drillList.nbFilteredDrills(filterList).toString()} results'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Ancienne config

//class SearchFilter extends StatefulWidget {
//  @override
//  _SearchFilterState createState() => _SearchFilterState();
//}
//
//class _SearchFilterState extends State<SearchFilter> {
//  DrillFilters filterList=DrillFilters();
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Hero(tag: 'logo', child: kLogoNoir),
//        backgroundColor: Colors.white,
//        centerTitle: true,
////        toolbarOpacity: 1.0,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.settings_backup_restore,
////              color: Colors.black,
//            ),
//            onPressed: () {
//              setState(() {
//                DrillFilters().initializeFilters();
//                filterList = DrillFilters();
//              });
//
////  TODO: ajouter ici la fonction pour réinitialiser tous les filtres
//            },
//          ),
//          IconButton(
//            icon: Icon(
//              Icons.save,
////              color: Colors.black,
//            ),
//            onPressed: () {
//              filterList.setFilters(filterList);
////   TODO: ajouter le changement de statut de la page précédente en fonction des filtres sélectionnés
//              Navigator.pop(context);
//            },
//          ),
//        ],
////        backgroundColor: Colors.transparent,
//      ),
//      body: Container(
////        decoration: kBackgroundContainer,
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
////            TODO Refactor Text+Row pour raccourcir le fichier
//            Text(
//              'Role',
//              style: Theme.of(context).textTheme.headline6,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                FilterButton('Leader', filterList.leader, (bool newValue) {
//                  setState(() {
//                    filterList.leader = newValue;
//                  });
//                }),
//                FilterButton('Follower', filterList.follower, (newValue) {
//                  setState(() {
//                    filterList.follower = newValue;
//                  });
//                }),
//              ],
//            ),
//            Text(
//              'Type',
//              style: Theme.of(context).textTheme.headline6,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                FilterButton('Solo', filterList.solo, (newValue) {
//                  setState(() {
//                    filterList.solo = newValue;
//                  });
//                }),
//                FilterButton('Couple', filterList.couple, (newValue) {
//                  setState(() {
//                    filterList.couple = newValue;
//                  });
//                }),
//              ],
//            ),
//            Text(
//              'Level(s)',
//              style: Theme.of(context).textTheme.headline6,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                FilterButton('Fund', filterList.fundamental, (newValue) {
//                  setState(() {
//                    filterList.fundamental = newValue;
//                  });
//                }),
//                FilterButton('L2', filterList.L2, (newValue) {
//                  setState(() {
//                    filterList.L2 = newValue;
//                  });
//                }),
//                FilterButton('L3', filterList.L3, (newValue) {
//                  setState(() {
//                    filterList.L3 = newValue;
//                  });
//                }),
//                FilterButton('L4', filterList.L4, (newValue) {
//                  setState(() {
//                    filterList.L4 = newValue;
//                  });
//                }),
//                FilterButton('L5', filterList.L5, (newValue) {
//                  setState(() {
//                    filterList.L5 = newValue;
//                  });
//                }),
//              ],
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
