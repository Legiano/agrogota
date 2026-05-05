class BalancoHidricoData {
  static const List<Map<String, dynamic>> dados = [
    {
      'mes': 'Jan', 'temp': 25.4, 'etp': 130.0, 'precip': 305.0,
      'etr': 130.0, 'def': 0.0, 'exc': 175.0, 'arm': 100.0,
    },
    {
      'mes': 'Fev', 'temp': 25.3, 'etp': 114.0, 'precip': 87.0,
      'etr': 111.0, 'def': 3.0, 'exc': 0.0, 'arm': 76.3,
    },
    {
      'mes': 'Mar', 'temp': 26.8, 'etp': 141.8, 'precip': 132.0,
      'etr': 139.0, 'def': 2.8, 'exc': 0.0, 'arm': 69.1,
    },
    {
      'mes': 'Abr', 'temp': 24.7, 'etp': 110.6, 'precip': 6.0,
      'etr': 51.0, 'def': 59.6, 'exc': 0.0, 'arm': 24.2,
    },
    {
      'mes': 'Mai', 'temp': 22.0, 'etp': 77.0, 'precip': 118.0,
      'etr': 77.0, 'def': 0.0, 'exc': 0.0, 'arm': 65.0,
    },
    {
      'mes': 'Jun', 'temp': 18.9, 'etp': 48.6, 'precip': 13.0,
      'etr': 33.0, 'def': 15.6, 'exc': 0.0, 'arm': 45.4,
    },
    {
      'mes': 'Jul', 'temp': 20.9, 'etp': 67.7, 'precip': 0.0,
      'etr': 22.0, 'def': 45.7, 'exc': 0.0, 'arm': 23.0,
    },
    {
      'mes': 'Ago', 'temp': 19.0, 'etp': 53.5, 'precip': 67.0,
      'etr': 53.5, 'def': 0.0, 'exc': 0.0, 'arm': 37.0,
    },
    {
      'mes': 'Set', 'temp': 22.2, 'etp': 81.0, 'precip': 180.0,
      'etr': 81.0, 'def': 0.0, 'exc': 36.0, 'arm': 100.0,
    },
    {
      'mes': 'Out', 'temp': 25.0, 'etp': 124.3, 'precip': 215.0,
      'etr': 124.3, 'def': 0.0, 'exc': 91.0, 'arm': 100.0,
    },
    {
      'mes': 'Nov', 'temp': 25.1, 'etp': 125.4, 'precip': 181.0,
      'etr': 125.4, 'def': 0.0, 'exc': 55.6, 'arm': 100.0,
    },
    {
      'mes': 'Dez', 'temp': 26.2, 'etp': 149.6, 'precip': 90.0,
      'etr': 135.0, 'def': 14.6, 'exc': 0.0, 'arm': 54.9,
    },
  ];

  static Map<String, dynamic> getMes(int mes) => dados[mes - 1];

  static String getClassificacaoMes(int mes) {
    final d = dados[mes - 1];
    final def = d['def'] as double;
    final exc = d['exc'] as double;
    if (exc > 50) return 'Excedente hídrico alto — pode reduzir irrigação';
    if (exc > 0) return 'Excedente hídrico — irrigação reduzida';
    if (def > 40) return 'Déficit alto — irrigação essencial';
    if (def > 10) return 'Déficit moderado — irrigar com atenção';
    return 'Balanço equilibrado';
  }

  static String getCorMes(int mes) {
    final d = dados[mes - 1];
    final def = d['def'] as double;
    final exc = d['exc'] as double;
    if (exc > 50) return 'blue';
    if (exc > 0) return 'green';
    if (def > 40) return 'red';
    if (def > 10) return 'orange';
    return 'green';
  }
}