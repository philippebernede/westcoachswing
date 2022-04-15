enum Level { Fundamentals, L2, L3, L4, L5 }

enum Partner {
  Solo,
  Couple,
}

enum Role { Leader, Follower, Both }

class Drill {
  Drill({
    this.name,
    this.id,
    this.videoURL,
    this.duration,
    this.partneringSkill,
    this.level,
    this.personalSkill,
    this.imageLink,
    this.musicality,
    this.partner,
    this.role,
    this.shortVideoURL,
    this.styling,
    this.technique,
  });
  String? name;
  int? id;
  String? videoURL;
  String? shortVideoURL;
  String? imageLink;
  String? duration;
  Role? role; // lead or follow or both only 3 options
  Level? level;
  Partner? partner = Partner.Solo;
  bool? musicality = false;
  bool? technique = false;
  bool? personalSkill = false;
  bool? styling = false;
  bool? partneringSkill = false;
  Map<String, bool> skills = {
    'technique': true,
    'musicality': false,
    'personalSkill': false,
    'styling': false,
    'partneringSkill': false
  };
  //TODO ajouter le restant des catégories une fois que l'on aura défini ce que ca allait être
//  switch
//  creativity
//  quality of movement
//  compétition
//  Balance
//  turns
//  general
//  posture
//  core
//  free arm
//  awarness
//  pitch/poise
//  elastique band
//  isolation
//  Connection
//  Pattern
//  Blues

  int get durationInSeconds {
    return int.parse(duration!.substring(0, 2)) * 60 +
        int.parse(duration!.substring(3, 5));
  }

  String get roleText {
    switch (role) {
      case Role.Follower:
        return 'Follower';

      case Role.Leader:
        return 'Leader';

      case Role.Both:
        return 'Leader and Follower';

      default:
        return 'Unknowm';

    }
  }

  String get partnerText {
    switch (partner) {
      case Partner.Solo:
        return 'Solo';

      case Partner.Couple:
        return 'Couple';

      default:
        return 'Both';

    }
  }

  String get levelText {
    switch (level) {
      case Level.L2:
        return 'L2';

      case Level.L3:
        return 'L3';

      case Level.L4:
        return 'L4';

      case Level.L5:
        return 'L5';

      case Level.Fundamentals:
        return 'F';

      default:
        return 'All';

    }
  }
}
