import 'drill.dart';

//enum Role { Leader, Follower, Both }

class Student {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  Role? role;
  List<bool>? notificationDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  String? notificationTime;
  List<int>? favorites = [];
  Map<String, int>? levels = {};
  DateTime? lastSignIn;
  int? workoutKey;
  int? category;

  Student({
    this.id,
    this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.notificationDays,
    this.notificationTime,
    this.favorites,
    this.levels,
    this.lastSignIn,
    this.workoutKey,
    this.category,
  });
}
