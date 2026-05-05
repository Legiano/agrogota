import 'package:flutter/material.dart';
import '../data/balanco_hidrico_data.dart';

class BalancoScreen extends StatelessWidget {
  const BalancoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mesAtual = DateTime.now().month;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balanço Hídrico'),
        backgroundColor: const Color(0xFF1AAF72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFF1AAF72), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Balanço Hídrico — Dourados/MS',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F6E56)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dados climatológicos de 2018 — Thornthwaite & Matter (1955)\nCAD: 100mm | Alt: 452m',
                    style: TextStyle(
                        fontSize: 11, color: Color(0xFF0F6E56)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _cardMesAtual(mesAtual),
            const SizedBox(height: 16),
            const Text(
              'TODOS OS MESES',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            ...List.generate(12, (i) => _cardMes(i + 1, mesAtual)),
            const SizedBox(height: 16),
            _legenda(),
          ],
        ),
      ),
    );
  }

  Widget _cardMesAtual(int mes) {
    final d = BalancoHidricoData.getMes(mes);
    final cor = BalancoHidricoData.getCorMes(mes);
    final classificacao = BalancoHidricoData.getClassificacaoMes(mes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getColor(cor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getIcon(cor), color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Este mês — ${d['mes']}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            classificacao,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricaBranca('Chuva', '${d['precip']} mm'),
              _metricaBranca('ETP', '${d['etp']} mm'),
              _metricaBranca('Déficit', '${d['def']} mm'),
              _metricaBranca('Excesso', '${d['exc']} mm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardMes(int mes, int mesAtual) {
    final d = BalancoHidricoData.getMes(mes);
    final cor = BalancoHidricoData.getCorMes(mes);
    final isAtual = mes == mesAtual;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAtual ? const Color(0xFF1AAF72) : Colors.grey.shade200,
          width: isAtual ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              d['mes'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isAtual ? FontWeight.w700 : FontWeight.w500,
                color: isAtual ? const Color(0xFF1AAF72) : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _barraIndicador('Chuva',
                    (d['precip'] as double), 400, Colors.blue.shade300),
                const SizedBox(height: 3),
                _barraIndicador('ETP',
                    (d['etp'] as double), 400, Colors.orange.shade300),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getColor(cor).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              (d['def'] as double) > 0
                  ? '-${(d['def'] as double).toStringAsFixed(0)}mm'
                  : '+${(d['exc'] as double).toStringAsFixed(0)}mm',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getColor(cor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraIndicador(
          String label, double valor, double max, Color cor) =>
      Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(label,
                style: const TextStyle(fontSize: 9, color: Colors.grey)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (valor / max).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(cor),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            valor.toStringAsFixed(0),
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      );

  Widget _metricaBranca(String label, String valor) => Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.white70)),
          const SizedBox(height: 2),
          Text(valor,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      );

  Widget _legenda() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Legenda',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey)),
            const SizedBox(height: 8),
            _itemLegenda(Colors.blue, 'Excedente alto — reduzir irrigação'),
            _itemLegenda(const Color(0xFF1AAF72),
                'Excedente — irrigação reduzida'),
            _itemLegenda(
                Colors.orange, 'Déficit moderado — irrigar com atenção'),
            _itemLegenda(Colors.red, 'Déficit alto — irrigação essencial'),
          ],
        ),
      );

  Widget _itemLegenda(Color cor, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: cor, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 8),
            Text(texto,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      );

  Color _getColor(String cor) {
    switch (cor) {
      case 'blue':
        return Colors.blue.shade600;
      case 'red':
        return Colors.red.shade600;
      case 'orange':
        return Colors.orange.shade600;
      default:
        return const Color(0xFF1AAF72);
    }
  }

  IconData _getIcon(String cor) {
    switch (cor) {
      case 'blue':
        return Icons.water;
      case 'red':
        return Icons.warning_outlined;
      case 'orange':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}