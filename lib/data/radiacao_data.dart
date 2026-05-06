class RadiacaoData {
  // Irradiação Global Horizontal — Coxim/MS
  // Fonte: Atlas Brasileiro de Energia Solar LABREN/CCST/INPE 2ª Edição (2017)
  // Dados originais em Wh/m²/dia convertidos para MJ/m²/dia (× 0,0036)
  // Médias baseadas em 17 anos de imagens de satélite (1999–2015)
  static const List<double> _mediasMensais = [
    20.1, // Janeiro
    20.6, // Fevereiro
    19.6, // Março
    17.9, // Abril
    15.4, // Maio
    14.9, // Junho
    15.2, // Julho
    18.4, // Agosto
    18.5, // Setembro
    19.9, // Outubro
    21.0, // Novembro
    21.6, // Dezembro
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