class KcData {
  static const Map<String, Map<String, double>> kc = {
    'Alface': {
      'inicial': 0.7,
      'intermediario': 1.0,
      'final': 0.95,
    },
    'Tomate': {
      'inicial': 0.6,
      'intermediario': 1.15,
      'final': 0.8,
    },
    'Pimentão': {
      'inicial': 0.6,
      'intermediario': 1.05,
      'final': 0.9,
    },
    'Cenoura': {
      'inicial': 0.7,
      'intermediario': 1.05,
      'final': 0.95,
    },
    'Cebola': {
      'inicial': 0.7,
      'intermediario': 1.05,
      'final': 0.75,
    },
    'Feijão': {
      'inicial': 0.5,
      'intermediario': 1.15,
      'final': 0.55,
    },
    'Melancia': {
      'inicial': 0.4,
      'intermediario': 1.0,
      'final': 0.75,
    },
    'Melão': {
      'inicial': 0.5,
      'intermediario': 1.05,
      'final': 0.75,
    },
    'Milho': {
      'inicial': 0.3,
      'intermediario': 1.2,
      'final': 0.35,
    },
    'Pepino': {
      'inicial': 0.6,
      'intermediario': 1.0,
      'final': 0.75,
    },
  };

  static double getKc(String cultura, String estagio) {
    return kc[cultura]?[estagio] ?? 1.0;
  }

  static List<String> getCulturas() => kc.keys.toList();

  static List<String> getEstagios() => [
    'inicial',
    'intermediario',
    'final',
  ];
}