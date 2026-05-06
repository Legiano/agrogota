class Cultura {
  int? id;
  String nome;
  String estagio;
  double kc;
  double espacamento; // m²
  double vazao;       // L/h
  int gotejadores;    // quantidade por planta

  Cultura({
    this.id,
    required this.nome,
    required this.estagio,
    required this.kc,
    required this.espacamento,
    required this.vazao,
    this.gotejadores = 1, // padrão 1 gotejador por planta
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'estagio': estagio,
    'kc': kc,
    'espacamento': espacamento,
    'vazao': vazao,
    'gotejadores': gotejadores,
  };

  factory Cultura.fromMap(Map<String, dynamic> map) => Cultura(
    id: map['id'],
    nome: map['nome'],
    estagio: map['estagio'],
    kc: map['kc'],
    espacamento: map['espacamento'],
    vazao: map['vazao'],
    gotejadores: map['gotejadores'] ?? 1,
  );
}