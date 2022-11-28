import 'package:flutter/material.dart';

class DrillFilters with ChangeNotifier {
  bool leader = false;
  bool follower = false;
  bool solo = false;
  bool couple = false;
  bool L2 = false;
  bool L3 = false;
  bool L4 = false;
  bool L5 = false;
  bool fundamental = false;
  bool technique = false;
  bool styling = false;
  bool musicality = false;
  bool personalSkill = false;
  bool partneringSkill = false;

//  DrillFilters({
//    this.leader,
//    this.follower,
//    this.solo,
//    this.couple,
//    this.fundamental,
//    this.L2,
//    this.L3,
//    this.L4,
//    this.L5,
//  });

//  DrillFilters get filterValues {
//    DrillFilters filter=DrillFilters();
//    print(leader.toString());
//    if (leader == null) {
//      leader = false;
//    }
//    if (follower == null) {
//      follower = false;
//    }
//    if (solo == null) {
//      solo = false;
//    }
//    if (couple == null) {
//      couple = false;
//    }
//    if (fundamental == null) {
//      fundamental = false;
//    }
//    if (L2 == null) {
//      L2 = false;
//    }
//    if (L3 == null) {
//      L3 = false;
//    }
//    if (L4 == null) {
//      L4 = false;
//    }
//    if (L5 == null) {
//      L5 = false;
//    }
//    filter.leader = leader;
//    filter.follower = follower;
//    filter.solo = solo;
//    filter.couple = couple;
//    filter.fundamental = fundamental;
//    filter.L2 = L2;
//    filter.L3 = L3;
//    filter.L4 = L4;
//    filter.L5 = L5;
//    print(filter.leader.toString());
//    return filter;
//  }

  // void toggleLeader() {
  //   this.leader ? leader = false : leader = true;
  //   notifyListeners();
  // }

  void initializeFilters() {
    leader = false;
    follower = false;
    solo = false;
    couple = false;
    fundamental = false;
    L2 = false;
    L3 = false;
    L4 = false;
    L5 = false;
    technique = false;
    styling = false;
    musicality = false;
    personalSkill = false;
    partneringSkill = false;
    notifyListeners();
  }

  void setFilters(DrillFilters filters) {
    leader = filters.leader;
    follower = filters.follower;
    solo = filters.solo;
    couple = filters.couple;
    fundamental = filters.fundamental;
    L2 = filters.L2;
    L3 = filters.L3;
    L4 = filters.L4;
    L5 = filters.L5;
    technique = filters.technique;
    styling = filters.styling;
    musicality = filters.musicality;
    personalSkill = filters.personalSkill;
    partneringSkill = filters.partneringSkill;
    notifyListeners();
  }
}
