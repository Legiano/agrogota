class SoloData {
  static const Map<String, Map<String, double>> classes = {
    'Muito Argiloso': {
      'argila': 70.0,
      'silte': 15.0,
      'areia': 15.0,
    },
    'Argiloso': {
      'argila': 50.0,
      'silte': 20.0,
      'areia': 30.0,
    },
    'Argilo-Siltoso': {
      'argila': 47.0,
      'silte': 45.0,
      'areia': 8.0,
    },
    'Argilo-Arenoso': {
      'argila': 35.0,
      'silte': 10.0,
      'areia': 55.0,
    },
    'Franco-Argiloso': {
      'argila': 35.0,
      'silte': 30.0,
      'areia': 35.0,
    },
    'Franco-Argilo-Arenoso': {
      'argila': 27.0,
      'silte': 13.0,
      'areia': 60.0,
    },
    'Franco-Argilo-Siltoso': {
      'argila': 33.0,
      'silte': 53.0,
      'areia': 14.0,
    },
    'Franco-Siltoso': {
      'argila': 13.0,
      'silte': 65.0,
      'areia': 22.0,
    },
    'Franco': {
      'argila': 20.0,
      'silte': 40.0,
      'areia': 40.0,
    },
    'Franco-Arenoso': {
      'argila': 10.0,
      'silte': 25.0,
      'areia': 65.0,
    },
    'Areia Franca': {
      'argila': 8.0,
      'silte': 12.0,
      'areia': 80.0,
    },
    'Arenoso': {
      'argila': 5.0,
      'silte': 5.0,
      'areia': 90.0,
    },
  };

  static List<String> getClasses() => classes.keys.toList();

  static double getSilte(String classe) => classes[classe]?['silte'] ?? 0;
  static double getArgila(String classe) => classes[classe]?['argila'] ?? 0;
  static double getAreia(String classe) => classes[classe]?['areia'] ?? 0;

  // Descrição simples para o produtor
  static const Map<String, String> descricoes = {
    'Muito Argiloso': 'Solo pesado, retém muita água',
    'Argiloso': 'Solo pesado, boa retenção de água',
    'Argilo-Siltoso': 'Solo pesado com bastante silte',
    'Argilo-Arenoso': 'Solo pesado com areia',
    'Franco-Argiloso': 'Solo médio com tendência argilosa',
    'Franco-Argilo-Arenoso': 'Solo médio com tendência arenosa',
    'Franco-Argilo-Siltoso': 'Solo médio com bastante silte',
    'Franco-Siltoso': 'Solo leve com bastante silte',
    'Franco': 'Solo médio equilibrado',
    'Franco-Arenoso': 'Solo leve com tendência arenosa',
    'Areia Franca': 'Solo leve, drena rápido',
    'Arenoso': 'Solo muito leve, drena muito rápido',
  };

  static String getDescricao(String classe) =>
      descricoes[classe] ?? '';
}