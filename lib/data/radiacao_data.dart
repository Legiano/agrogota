class RadiacaoData {
  // Irradiação Global Horizontal — Dourados/MS
  // Fonte: Atlas Brasileiro de Energia Solar LABREN/CCST/INPE 2ª Edição (2017)
  // Dados originais em Wh/m²/dia convertidos para MJ/m²/dia (× 0,0036)
  // Médias baseadas em 17 anos de imagens de satélite (1999–2015)
  static const List<double> _mediasMensais = [
    21.3, // Janeiro
    20.6, // Fevereiro
    19.0, // Março
    16.2, // Abril
    13.3, // Maio
    12.1, // Junho
    12.6, // Julho
    16.1, // Agosto
    17.1, // Setembro
    19.1, // Outubro
    21.3, // Novembro
    23.0, // Dezembro
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