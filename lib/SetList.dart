class Group {
  int setid;
  String participants;

  Group(this.setid, this.participants);

  Map<String, dynamic> toMap1() {
    var map1 = <String, dynamic>{
      'setid': setid, 'participants': participants,
    };
    return map1;
  }

  Group.fromMap(Map<String, dynamic> map1 ) {
    setid = map1['setid'];
    participants = map1['participants'];
  }
}