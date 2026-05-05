import 'dart:math';
import '../models/solo.dart';
import '../models/cultura.dart';
import '../models/entrada_climatica.dart';
import '../models/resultado.dart';

class CalculoService {

  // Calcula CC a partir de silte + argila
  static double calcularCC(double silte, double argila) {
    final x = silte + argila;
    return 0.003 * pow(x, 2) + 0.180 * x + 3.309;
  }

  // Calcula PMP a partir de silte + argila
  static double calcularPMP(double silte, double argila) {
    final x = silte + argila;
    return 0.213 * pow(x, 0.990);
  }

  // Penman-Monteith FAO-56 simplificado
  static double calcularETo(EntradaClimatica e, double altitude) {
    final tMed = (e.tMax + e.tMin) / 2;

    // Pressão de saturação (kPa)
    final esTmax = 0.6108 * exp((17.27 * e.tMax) / (e.tMax + 237.3));
    final esTmin = 0.6108 * exp((17.27 * e.tMin) / (e.tMin + 237.3));
    final es = (esTmax + esTmin) / 2;

    // Pressão atual de vapor (kPa)
    final ea = ((e.urMax / 100) * esTmin + (e.urMin / 100) * esTmax) / 2;

    // Déficit de pressão de vapor
    final vpd = es - ea;

    // Pressão atmosférica (kPa)
    final p = 101.3 * pow((293 - 0.0065 * altitude) / 293, 5.26);

    // Constante psicrométrica
    final gama = 0.000665 * p;

    // Inclinação da curva de pressão de vapor
    final delta = 4098 * (0.6108 * exp((17.27 * tMed) / (tMed + 237.3))) /
        pow(tMed + 237.3, 2);

    // Radiação líquida estimada (Rn ≈ 0.77 * Rs - Rnl simplificado)
    final rs = e.radiacao;
    final rns = 0.77 * rs;
    final rnl = 0.5; // valor médio simplificado MJ/m²/dia
    final rn = rns - rnl;

    // Fluxo de calor do solo (G ≈ 0 para período diário)
    const g = 0.0;

    // ETo Penman-Monteith FAO-56
    final numerador = (0.408 * delta * (rn - g)) +
        (gama * (900 / (tMed + 273)) * vpd);
    final denominador = delta + gama * 1.34;

    final eto = numerador / denominador;
    return eto < 0 ? 0 : eto;
  }

  // Cálculo completo: retorna Resultado
  static Resultado calcular({
  required Solo solo,
  required Cultura cultura,
  required EntradaClimatica entrada,
  double altitude = 400,
  double chuva = 0, // parâmetro novo
}) {
  final eto = calcularETo(entrada, altitude);
  final etc = eto * cultura.kc;

  final ad = solo.cc - solo.pmp;
  const f = 0.5;
  double lamina = etc * f > ad * f ? ad * f : etc;

  // Desconta a chuva da lâmina necessária
  lamina = (lamina - chuva).clamp(0.0, double.infinity);

  final volume = lamina * cultura.espacamento;
  final vazaoMinuto = cultura.vazao / 60;
  final tempoMin = vazaoMinuto > 0 ? volume / vazaoMinuto : 0.0;

  return Resultado(
    data: entrada.data,
    eto: double.parse(eto.toStringAsFixed(2)),
    etc: double.parse(etc.toStringAsFixed(2)),
    lamina: double.parse(lamina.toStringAsFixed(2)),
    volume: double.parse(volume.toStringAsFixed(2)),
    tempoMin: double.parse(tempoMin.toStringAsFixed(1)),
  );
}
}