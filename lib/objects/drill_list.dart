import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:westcoachswing/objects/drill.dart';
import 'package:westcoachswing/objects/drill_filters.dart';

class DrillList with ChangeNotifier {
// certainement utiliser la fonction final List<Drill> drills=List<Drill>.generate

//  DrillList() {
//    initDrills();
//  }

//  DrillList() {
//    initDrills();
//  }
  Drill selectedDrill = Drill();
  List<Drill> _drills = [];
  bool drillInit = false;

  Future<void> initDrills() async {
//---------------------------------------------------------------------Partie pour ajouter de nouveaux drills--------------------------------------------------------------
//   ---------------les nouveaux drills sont à mettre ici dans la list drillAdd------------------------
//     List<Drill> drillAdd = [];
//     drillAdd.forEach(
//       (element) => FirebaseFirestore.instance
//           .collection('drill')
//           .doc(element.id.toString())
//           .set({
//         'name': element.name,
//         'role': element.role.toString(),
//         'duration': element.duration,
//         'level': element.level.toString(),
//         'shortVideoURL': element.shortVideoURL,
//         'videoURL': element.videoURL,
//         'partner': element.partner.toString(),
//         'imageLink': element.imageLink,
//         'personalSkill': element.personalSkill,
//         'partneringSkill': element.partneringSkill,
//         'technique': element.technique,
//         'musicality': element.musicality,
//         'styling': element.styling,
//         // 'levels': element.levels,
//       }),
//     );

//    Drill drill = Drill();
    if (!drillInit) {
      drillInit = true;
      _drills =
          []; // on s'assure que la liste des drills est vide au moment de l'initialisation pour ne pas l'afficher en double. Changement fait suite à un bug
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('drill').get();
      querySnapshot.docs.forEach((element) {
        Drill drill = Drill();
        drill.name = element['name'];
        drill.duration = element['duration'];
        drill.imageLink = element['imageLink'];
        drill.level = convertToLevel(element['level']);
        drill.musicality = element['musicality'];
        drill.partner = convertToPartner(element['partner']);
        drill.partneringSkill = element['partneringSkill'];
        drill.personalSkill = element['personalSkill'];
        drill.role = convertToRole(element['role']);
        drill.shortVideoURL = element['shortVideoURL'];
        drill.styling = element['styling'];
        drill.technique = element['technique'];
        drill.videoURL = element['videoURL'];
        drill.id = int.parse(element.id);
        drill.skills = {
          'technique': element['technique'],
          'styling': element['styling'],
          'personalSkill': element['personalSkill'],
          'partneringSkill': element['partneringSkill'],
          'musicality': element['musicality']
        };
        _drills.add(drill);
      });

      _drills.sort((a, b) => a.name!.compareTo(b.name!));
      notifyListeners();
    }

//    return _drills;
  }

  Level convertToLevel(String lev) {
    late Level level;
    switch (lev) {
      case 'Level.Fundamentals':
        {
          level = Level.Fundamentals;
        }
        break;
      case 'Level.L2':
        {
          level = Level.L2;
        }
        break;
      case 'Level.L3':
        {
          level = Level.L3;
        }
        break;
      case 'Level.L4':
        {
          level = Level.L4;
        }
        break;
      case 'Level.L5':
        {
          level = Level.L5;
        }
        break;
    }
    return level;
  }

  Role convertToRole(String rol) {
    late Role role;
    switch (rol) {
      case 'Role.Leader':
        {
          role = Role.Leader;
        }
        break;
      case 'Role.Follower':
        {
          role = Role.Follower;
        }
        break;
      case 'Role.Both':
        {
          role = Role.Both;
        }
        break;
    }
    return role;
  }

  Partner convertToPartner(String part) {
    late Partner partner;
    switch (part) {
      case 'Partner.Solo':
        {
          partner = Partner.Solo;
        }
        break;
      case 'Partner.Couple':
        {
          partner = Partner.Couple;
        }
        break;
    }
    return partner;
  }

  set setSelectedDrillById(int drillId) {
    selectedDrill.id = drillId;
//    notifyListeners();
  }

  int get getSelectedDrillId {
    return selectedDrill.id!;
  }

  List<Drill> get drillList {
    return _drills;
  }

//  récupère la durée d'un drill par rapport à son ID
  int durationInSecByDrillId(int drillId) {
//    checks if the list of _drills is still empty
    if (_drills.isNotEmpty) {
      Drill drill = _drills.firstWhere(
        (element) => element.id == drillId,
      );
      return drill.durationInSeconds;
    }
    return 0;
  }

//    récupère le drill en fonction de son ID et renvoi null si pas trouvé
  Drill drillById(int drillId) {
    return _drills.firstWhere((element) => element.id == drillId,
        orElse: () => null!);
  }

//  récupère le drill en fonction de son nom. La comparaison se fait indépendamment de la casse et renvoi null si pas trouvé
  List<Drill> drillsByName(String drillName) {
    notifyListeners();
    return _drills
        .where((element) =>
            element.name!.toLowerCase().contains(drillName.toLowerCase()))
        .toList();
  }

  Drill? drillByName(String drillName) {
    return _drills.firstWhere(
        (element) => element.name!.toLowerCase() == drillName.toLowerCase(),
        orElse: () => null!);
  }

//  vérification si un filtre a été appliqué ou pas
  bool isFiltered(DrillFilters _filterList) {
    return _filterList.leader ||
        _filterList.follower ||
        _filterList.solo ||
        _filterList.couple ||
        _filterList.fundamental ||
        _filterList.L2 ||
        _filterList.L3 ||
        _filterList.L4 ||
        _filterList.L5 ||
        _filterList.technique ||
        _filterList.partneringSkill ||
        _filterList.personalSkill ||
        _filterList.styling ||
        _filterList.musicality;
  }

//  récupère le nombre de drill filtré
  int nbFilteredDrills(DrillFilters? filterList) {
    int i = _drills.length;
    i = drillsByFilter('ALL COLLECTIONS', filterList).length;
    return i;
  }

//  création d'une nouvelle liste de drill en fonctions des filtres établis.
  List<Drill> drillsByFilter(String? collect, DrillFilters? filterList,
      [String? filterName]) {
    List<Drill> filteredDrills = _drills;

//   analyse de la collection
    if (filterList != null && filterList.personalSkill) {
      filteredDrills = filteredDrills.where((drill) {
        return !drill.personalSkill! ? false : true;
      }).toList();
    } else if (filterList != null && filterList.musicality) {
      filteredDrills = filteredDrills.where((drill) {
        return !drill.musicality! ? false : true;
      }).toList();
    } else if (filterList != null && filterList.partneringSkill) {
      filteredDrills = filteredDrills.where((drill) {
        return !drill.partneringSkill! ? false : true;
      }).toList();
    } else if (filterList != null && filterList.technique) {
      filteredDrills = filteredDrills.where((drill) {
        return !drill.technique! ? false : true;
      }).toList();
    } else if (filterList != null && filterList.styling) {
      filteredDrills = filteredDrills.where((drill) {
        return !drill.styling! ? false : true;
      }).toList();
    }
//    else
//         {
//           filteredDrills = _drills;
// //          filteredDrills.sort((a, b) => a.name.compareTo(b.name));
//         }

//     switch (collect) {
//       case 'Personal Skills':
//         {
//           filteredDrills = filteredDrills.where((drill) {
//             return !drill.personalSkill! ? false : true;
//           }).toList();
//         }
//         break;
//       case 'Musicality':
//         {
//           filteredDrills = filteredDrills.where((drill) {
//             return !drill.musicality! ? false : true;
//           }).toList();
//         }
//         break;
//       case 'Partnering Skills':
//         {
//           filteredDrills = filteredDrills.where((drill) {
//             return !drill.partneringSkill! ? false : true;
//           }).toList();
//         }
//         break;
//       case 'Technique':
//         {
//           filteredDrills = filteredDrills.where((drill) {
//             return !drill.technique! ? false : true;
//           }).toList();
//         }
//         break;
//       case 'Styling':
//         {
//           filteredDrills = filteredDrills.where((drill) {
//             return !drill.styling! ? false : true;
//           }).toList();
//         }
//         break;
//       default:
//         {
//           filteredDrills = _drills;
// //          filteredDrills.sort((a, b) => a.name.compareTo(b.name));
//         }
//         break;
//     }

//    si un filtre a été fourni dans ce cas on analyse le filtre sinon on n'y va pas
    if (filterList != null) {
      //   analyse de la collection
      if (filterList.personalSkill) {
        filteredDrills = filteredDrills.where((drill) {
          return !drill.personalSkill! ? false : true;
        }).toList();
      } else if (filterList.musicality) {
        filteredDrills = filteredDrills.where((drill) {
          return !drill.musicality! ? false : true;
        }).toList();
      } else if (filterList.partneringSkill) {
        filteredDrills = filteredDrills.where((drill) {
          return !drill.partneringSkill! ? false : true;
        }).toList();
      } else if (filterList.technique) {
        filteredDrills = filteredDrills.where((drill) {
          return !drill.technique! ? false : true;
        }).toList();
      } else if (filterList.styling) {
        filteredDrills = filteredDrills.where((drill) {
          return !drill.styling! ? false : true;
        }).toList();
      }

//       if (filterList.partneringSkill ||
//           filterList.personalSkill ||
//           filterList.musicality ||
//           filterList.styling ||
//           filterList.technique) {
//         filteredDrills = filteredDrills.where((element) {
//           if ((element.technique == filterList.technique) ||
//               (element.partneringSkill == filterList.partneringSkill) ||
//               (element.personalSkill == filterList.personalSkill) ||
//               (element.musicality == filterList.musicality) ||
//               (element.styling == filterList.styling)) {
//             return true;
//           } else {
//             return false;
//           }
//         }).toList();
//       }

      if (filterList.leader || filterList.follower) {
        filteredDrills = filteredDrills.where((element) {
          if ((element.role == Role.Leader && filterList.leader) ||
              (element.role == Role.Follower && filterList.follower) ||
              (element.role == Role.Both &&
                  (filterList.leader || filterList.follower))) {
            return true;
          } else {
            return false;
          }
        }).toList();
      }

      if (filterList.solo || filterList.couple) {
        filteredDrills = filteredDrills.where((element) {
          if ((element.partner == Partner.Solo && filterList.solo) ||
              (element.partner == Partner.Couple && filterList.couple)) {
            return true;
          } else {
            return false;
          }
        }).toList();
      }

      if (filterList.fundamental ||
          filterList.L2 ||
          filterList.L3 ||
          filterList.L4 ||
          filterList.L5) {
        filteredDrills = filteredDrills.where((element) {
          if ((element.level == Level.Fundamentals && filterList.fundamental) ||
              (element.level == Level.L2 && filterList.L2) ||
              (element.level == Level.L3 && filterList.L3) ||
              (element.level == Level.L4 && filterList.L4) ||
              (element.level == Level.L5 && filterList.L5)) {
            return true;
          } else {
            return false;
          }
        }).toList();
      }
    }

    if (filterName != null) {
      filteredDrills = filteredDrills.where((drill) {
        return drill.name!.toLowerCase().contains(filterName) ? true : false;
      }).toList();
    }
//    notifyListeners();
//        retourne la liste filtrée
    return filteredDrills;
  }

//  List<Drill> setCollectionFilter(String collect, DrillFilters filterList) {
//    List<Drill> _filteredDrills;
//    print('set Collection has been called');
//
//    List<Drill> _drillList = DrillList().drillsByFilter(filterList);
//    print(filterList.leader);
//    print(_drillList.length);
//    switch (collect) {
//      case 'Personal Skills':
//        {
//          _filteredDrills = _drillList.where((drill) {
//            return !drill.personalSkill ? false : true;
//          }).toList();
//        }
//        break;
//      case 'Musicality':
//        {
//          _filteredDrills = _drillList.where((drill) {
//            return !drill.musicality ? false : true;
//          }).toList();
//        }
//        break;
//      case 'Partnering Skills':
//        {
//          _filteredDrills = _drillList.where((drill) {
//            return !drill.partneringSkill ? false : true;
//          }).toList();
//        }
//        break;
//      case 'Technique':
//        {
//          _filteredDrills = _drillList.where((drill) {
//            return !drill.technique ? false : true;
//          }).toList();
//        }
//        break;
//      case 'Styling':
//        {
//          _filteredDrills = _drillList.where((drill) {
//            return !drill.styling ? false : true;
//          }).toList();
//        }
//        break;
//      default:
//        {
//          _filteredDrills = _drillList;
////          filteredDrills.sort((a, b) => a.name.compareTo(b.name));
//        }
//        break;
//    }
////    notifyListeners();
//    return _filteredDrills;
//  }

}
