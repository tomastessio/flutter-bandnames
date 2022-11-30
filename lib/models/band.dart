

class Band {

  String id;
  String name;
  int? votes;

  Band({
    required this.id, 
    required this.name,
    this.votes
  });


  //Tiene como objetivo regresar una nueva instancia de la clase Band
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']);


}