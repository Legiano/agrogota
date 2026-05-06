import 'package:flutter/material.dart';
import '../models/resultado.dart';

class ResultadoScreen extends StatelessWidget {
  final Resultado? resultado;
  const ResultadoScreen({super.key, this.resultado});

  // Converte minutos para formato legível
  String _formatarTempo(double minutos) {
    final total = minutos.round();
    if (total < 60) {
      return '$total min';
    }
    final horas = total ~/ 60;
    final mins = total % 60;
    if (mins == 0) {
      return '${horas}h';
    }
    return '${horas}h ${mins}min';
  }

  // Texto descritivo do tempo
  String _descricaoTempo(double minutos) {
    final total = minutos.round();
    if (total < 60) return 'ligue a irrigação agora';
    final horas = total ~/ 60;
    final mins = total % 60;
    if (mins == 0) return 'ligue por $horas hora${horas > 1 ? 's' : ''}';
    return 'ligue por ${horas}h e ${mins}min';
  }

  @override
  Widget build(BuildContext context) {
    if (resultado == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Ainda não calculou hoje.',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                'Vá em Irrigar, informe o clima\ndo dia e calcule.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigue assim hoje'),
        backgroundColor: const Color(0xFF1AAF72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Destaque principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF1AAF72),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    _formatarTempo(resultado!.tempoMin),
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    _descricaoTempo(resultado!.tempoMin),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grid de métricas
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                _metricaCard('Água necessária',
                    '${resultado!.lamina} mm', Icons.water_outlined),
                _metricaCard('Por planta',
                    '${resultado!.volume} L', Icons.eco_outlined),
                _metricaCard('Evaporação do dia',
                    '${resultado!.eto} mm', Icons.wb_sunny_outlined),
                _metricaCard('Consumo da planta',
                    '${resultado!.etc} mm', Icons.grass_outlined),
              ],
            ),
            const SizedBox(height: 16),
            // Dica
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Color(0xFF1AAF72), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ligue a irrigação, aguarde o tempo acima e desligue. Amanhã abra o app de novo.',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF0F6E56)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Resumo técnico
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _resumoItem('Data',
                      '${resultado!.data.day.toString().padLeft(2, '0')}/${resultado!.data.month.toString().padLeft(2, '0')}'),
                  _divider(),
                  _resumoItem('Água total', '${resultado!.lamina} mm'),
                  _divider(),
                  _resumoItem('Por planta', '${resultado!.volume} L'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricaCard(String label, String valor, IconData icone) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icone, color: const Color(0xFF1AAF72), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                  Text(valor,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _resumoItem(String label, String valor) => Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(valor,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      );

  Widget _divider() => Container(
        height: 30,
        width: 1,
        color: Colors.grey.shade200,
      );
}