import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Ícone principal
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF1AAF72),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Título
              const Text(
                  'AgroGota IrrigaTech',
                style: TextStyle(
                  fontSize: 34,
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
              const Spacer(),
              // Cards de info
              _infoCard(
                Icons.wifi_off,
                'Funciona sem internet',
                'Use no campo sem precisar de conexão',
              ),
              const SizedBox(height: 12),
              _infoCard(
                Icons.wb_sunny_outlined,
                'Cálculo pelo clima do dia',
                'Baseado na temperatura e umidade de hoje',
              ),
              const SizedBox(height: 12),
              _infoCard(
                Icons.timer_outlined,
                'Resultado simples',
                'Ligue e desligue a irrigação no tempo certo',
              ),
              const Spacer(),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icone, String titulo, String subtitulo) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1AAF72),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 12,
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