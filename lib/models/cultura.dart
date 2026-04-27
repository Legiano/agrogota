class Cultura {
  int? id;
  String nome;
  String estagio; // inicial, intermediario, final
  double kc;
  double espacamento; // m²
  double vazao;       // L/h

  Cultura({
    this.id,
    required this.nome,
    required this.estagio,
    required this.kc,
    required this.espacamento,
    required this.vazao,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'estagio': estagio,
    'kc': kc,
    'espacamento': espacamento,
    'vazao': vazao,
  };

  factory Cultura.fromMap(Map<String, dynamic> map) => Cultura(
    id: map['id'],
    nome: map['nome'],
    estagio: map['estagio'],
    kc: map['kc'],
    espacamento: map['espacamento'],
    vazao: map['vazao'],
  );
}