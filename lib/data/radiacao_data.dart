class RadiacaoData {
  // Irradiação Global Horizontal — Dourados/MS
  // Fonte: Atlas Brasileiro de Energia Solar INPE/LABREN 2017
  // Convertido de Wh/m²/dia × 0,0036 = MJ/m²/dia
  static const List<double> _mediasMensais = [
    19.8, // Janeiro
    19.2, // Fevereiro
    17.5, // Março
    15.1, // Abril
    12.8, // Maio
    11.9, // Junho
    12.6, // Julho
    14.8, // Agosto
    16.4, // Setembro
    18.2, // Outubro
    19.0, // Novembro
    19.5, // Dezembro
  ];

  static double getRadiacaoEstimada(DateTime data) {
    return _mediasMensais[data.month - 1];
  }

  static String getMesNome(int mes) {
    const nomes = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril',
      'Maio', 'Junho', 'Julho', 'Agosto',
      'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return nomes[mes - 1];
  }
}