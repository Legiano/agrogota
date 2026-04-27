import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/resultado.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final db = DatabaseHelper();
  List<Resultado> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await db.getHistorico();
    setState(() => _historico = lista);
  }

  Future<void> _excluir(Resultado r, int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: const Text(
            'Esse registro será removido do histórico permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true && r.id != null) {
      await db.excluirResultado(r.id!);
      setState(() => _historico.removeAt(index));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro excluído.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: const Color(0xFF1AAF72),
        foregroundColor: Colors.white,
      ),
      body: _historico.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum registro ainda.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _historico.length,
              itemBuilder: (context, i) {
                final r = _historico[i];
                return Dismissible(
                  key: Key(r.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await _excluir(r, i);
                    return false;
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.water_drop,
                              color: Color(0xFF1AAF72), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r.data.day.toString().padLeft(2, '0')}/'
                                '${r.data.month.toString().padLeft(2, '0')}/'
                                '${r.data.year}',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                              Text(
                                '${r.tempoMin.toStringAsFixed(0)} min · '
                                '${r.lamina} mm · ${r.volume} L/planta',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_left,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}