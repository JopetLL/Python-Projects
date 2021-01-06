class Player {
  int id;
  String name;
  int sets = 0;

  Player(this.id, this.name,this.sets);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id, 'name': name, 'sets': sets,
    };
    return map;
  }

  Player.fromMap(Map<String, dynamic> map ) {
    id = map['id'];
    name = map['name'];
    sets = map['sets'];
  }
}