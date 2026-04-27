class Solo {
  int? id;
  double silte;
  double argila;
  double cc;
  double pmp;

  Solo({
    this.id,
    required this.silte,
    required this.argila,
    required this.cc,
    required this.pmp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'silte': silte,
    'argila': argila,
    'cc': cc,
    'pmp': pmp,
  };

  factory Solo.fromMap(Map<String, dynamic> map) => Solo(
    id: map['id'],
    silte: map['silte'],
    argila: map['argila'],
    cc: map['cc'],
    pmp: map['pmp'],
  );
}