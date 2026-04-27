class EntradaClimatica {
  int? id;
  DateTime data;
  double tMax;
  double tMin;
  double urMax;
  double urMin;
  double radiacao; // MJ/m²/dia
  bool radiacaoEstimada;

  EntradaClimatica({
    this.id,
    required this.data,
    required this.tMax,
    required this.tMin,
    required this.urMax,
    required this.urMin,
    required this.radiacao,
    required this.radiacaoEstimada,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'data': data.toIso8601String(),
    'tMax': tMax,
    'tMin': tMin,
    'urMax': urMax,
    'urMin': urMin,
    'radiacao': radiacao,
    'radiacaoEstimada': radiacaoEstimada ? 1 : 0,
  };

  factory EntradaClimatica.fromMap(Map<String, dynamic> map) => EntradaClimatica(
    id: map['id'],
    data: DateTime.parse(map['data']),
    tMax: map['tMax'],
    tMin: map['tMin'],
    urMax: map['urMax'],
    urMin: map['urMin'],
    radiacao: map['radiacao'],
    radiacaoEstimada: map['radiacaoEstimada'] == 1,
  );
}