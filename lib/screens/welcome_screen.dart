import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Imagem do professor
              Image.asset(
                'assets/icon.png',
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // Título
              const Text(
                'AgroGota IrrigaTech',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1AAF72),
                ),
              ),
              const SizedBox(height: 10),
              // Subtítulo
              const Text(
                'Saiba o tempo certo de irrigar\nsua lavoura',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF888780),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Cards de info
              _infoCard(
                Icons.wifi_off,
                'Funciona sem internet',
                'Use no campo sem precisar de conexão',
              ),
              const SizedBox(height: 10),
              _infoCard(
                Icons.wb_sunny_outlined,
                'Cálculo pelo clima do dia',
                'Baseado na temperatura e umidade de hoje',
              ),
              const SizedBox(height: 10),
              _infoCard(
                Icons.landscape_outlined,
                'Solos do Mato Grosso do Sul',
                'Banco de dados com tipos de solo por município',
              ),
              const SizedBox(height: 10),
              _infoCard(
                Icons.water_outlined,
                'Balanço hídrico mensal',
                'Déficit e excedente de água por época do ano',
              ),
              const SizedBox(height: 10),
              _infoCard(
                Icons.timer_outlined,
                'Resultado simples',
                'Ligue e desligue a irrigação no tempo certo',
              ),
              const SizedBox(height: 32),
              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('primeiro_acesso', false);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AAF72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Começar',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Rodapé
              const Text(
                'AgroGota IrrigaTech © 2026 — IFMS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icone, String titulo, String subtitulo) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1AAF72),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888780),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}