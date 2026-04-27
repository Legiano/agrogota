import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/entrada_climatica.dart';
import '../models/resultado.dart';
import '../services/calculo_service.dart';
import '../data/radiacao_data.dart';

class EntradaScreen extends StatefulWidget {
  final Function(Resultado) onResultado;
  const EntradaScreen({super.key, required this.onResultado});

  @override
  State<EntradaScreen> createState() => _EntradaScreenState();
}

class _EntradaScreenState extends State<EntradaScreen> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  // Campos em branco — obriga o produtor a digitar
  final _tMaxCtrl = TextEditingController();
  final _tMinCtrl = TextEditingController();
  final _urMaxCtrl = TextEditingController();
  final _urMinCtrl = TextEditingController();
  final _radiacaoCtrl = TextEditingController();

  bool _radiacaoManual = false;
  bool _calculando = false;
  double _radiacaoEstimada = 0;

  @override
  void initState() {
    super.initState();
    _radiacaoEstimada = RadiacaoData.getRadiacaoEstimada(DateTime.now());
    _radiacaoCtrl.text = _radiacaoEstimada.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _tMaxCtrl.dispose();
    _tMinCtrl.dispose();
    _urMaxCtrl.dispose();
    _urMinCtrl.dispose();
    _radiacaoCtrl.dispose();
    super.dispose();
  }

  String _getHint(String unidade) {
    switch (unidade) {
      case '°C':
        return 'ex: 32';
      case '%':
        return 'ex: 75';
      case 'MJ/m²':
        return 'ex: 19.4';
      default:
        return '0';
    }
  }

  Future<void> _calcular() async {
    if (!_formKey.currentState!.validate()) return;

    final solo = await db.getSolo();
    final cultura = await db.getCultura();

    if (solo == null || cultura == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Antes de calcular, preencha os dados em Configuração!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _calculando = true);

    final entrada = EntradaClimatica(
      data: DateTime.now(),
      tMax: double.parse(_tMaxCtrl.text),
      tMin: double.parse(_tMinCtrl.text),
      urMax: double.parse(_urMaxCtrl.text),
      urMin: double.parse(_urMinCtrl.text),
      radiacao: double.parse(_radiacaoCtrl.text),
      radiacaoEstimada: !_radiacaoManual,
    );

    final resultado = CalculoService.calcular(
      solo: solo,
      cultura: cultura,
      entrada: entrada,
    );

    await db.salvarEntrada(entrada);
    await db.salvarResultado(resultado);

    setState(() => _calculando = false);
    widget.onResultado(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final mes = RadiacaoData.getMesNome(DateTime.now().month);
    final screenWidth = MediaQuery.of(context).size.width;
    final campoWidth = screenWidth * 0.25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Como está o tempo hoje?'),
        backgroundColor: const Color(0xFF1AAF72),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner explicativo
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF1AAF72), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Informe os dados do termômetro e higrômetro de hoje.',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF0F6E56)),
                      ),
                    ),
                  ],
                ),
              ),
              _secaoTitulo('Temperatura (termômetro)'),
              _card([
                _campoNumerico('Temperatura mais alta do dia',
                    _tMaxCtrl, '°C', campoWidth),
                _campoNumerico('Temperatura mais baixa do dia',
                    _tMinCtrl, '°C', campoWidth),
              ]),
              const SizedBox(height: 16),
              _secaoTitulo('Umidade do ar (higrômetro)'),
              _card([
                _campoNumerico('Umidade mais alta do dia',
                    _urMaxCtrl, '%', campoWidth),
                _campoNumerico('Umidade mais baixa do dia',
                    _urMinCtrl, '%', campoWidth),
              ]),
              const SizedBox(height: 16),
              _secaoTitulo('Luz solar'),
              _card([
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _radiacaoManual
                                  ? 'Informar manualmente'
                                  : 'Usar média do mês ($mes)',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _radiacaoManual
                                  ? 'Digite o valor da radiação abaixo'
                                  : 'Recomendado para a maioria dos casos',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: _radiacaoManual,
                          activeThumbColor: const Color(0xFF1AAF72),
                          activeTrackColor: const Color(0xFF1AAF72)
                              .withValues(alpha: 0.3),
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade200,
                          onChanged: (v) {
                            setState(() {
                              _radiacaoManual = v;
                              if (!v) {
                                _radiacaoCtrl.text =
                                    _radiacaoEstimada.toStringAsFixed(1);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_radiacaoManual) ...[
                  const SizedBox(height: 10),
                  _campoNumerico(
                    'Valor da radiação solar',
                    _radiacaoCtrl,
                    'MJ/m²',
                    campoWidth,
                    enabled: true,
                  ),
                ],
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculando ? null : _calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AAF72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _calculando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Calcular tempo de irrigação',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secaoTitulo(String titulo) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          titulo.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1),
        ),
      );

  Widget _card(List<Widget> children) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(children: children),
      );

  Widget _campoNumerico(
    String label,
    TextEditingController ctrl,
    String unidade,
    double campoWidth, {
    bool enabled = true,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: enabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: campoWidth.clamp(70.0, 90.0),
            child: TextFormField(
              controller: ctrl,
              enabled: enabled,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                hintText: _getHint(unidade),
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty || double.tryParse(v) == null)
                      ? 'Preencha'
                      : null,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            child: Text(
              unidade,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ]),
      );
}