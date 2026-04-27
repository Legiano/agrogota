class Resultado {
  int? id;
  DateTime data;
  double eto;
  double etc;
  double lamina;     // mm
  double volume;     // litros/planta
  double tempoMin;   // minutos

  Resultado({
    this.id,
    required this.data,
    required this.eto,
    required this.etc,
    required this.lamina,
    required this.volume,
    required this.tempoMin,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'data': data.toIso8601String(),
    'eto': eto,
    'etc': etc,
    'lamina': lamina,
    'volume': volume,
    'tempoMin': tempoMin,
  };

  factory Resultado.fromMap(Map<String, dynamic> map) => Resultado(
    id: map['id'],
    data: DateTime.parse(map['data']),
    eto: map['eto'],
    etc: map['etc'],
    lamina: map['lamina'],
    volume: map['volume'],
    tempoMin: map['tempoMin'],
  );
}