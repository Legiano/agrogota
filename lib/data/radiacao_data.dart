class RadiacaoData {
  // Valores em MJ/m²/dia — médias históricas para MS
  static const Map<int, double> radiacaoMS = {
    1: 22.5,  // Janeiro
    2: 21.8,  // Fevereiro
    3: 19.4,  // Março
    4: 17.2,  // Abril
    5: 15.1,  // Maio
    6: 14.8,  // Junho
    7: 15.6,  // Julho
    8: 18.3,  // Agosto
    9: 19.7,  // Setembro
    10: 21.0, // Outubro
    11: 21.5, // Novembro
    12: 22.0, // Dezembro
  };

  static double getRadiacaoEstimada(DateTime data) {
    return radiacaoMS[data.month] ?? 18.0;
  }

  static String getMesNome(int mes) {
    const meses = {
      1: 'Janeiro', 2: 'Fevereiro', 3: 'Março',
      4: 'Abril', 5: 'Maio', 6: 'Junho',
      7: 'Julho', 8: 'Agosto', 9: 'Setembro',
      10: 'Outubro', 11: 'Novembro', 12: 'Dezembro',
    };
    return meses[mes] ?? '';
  }
}