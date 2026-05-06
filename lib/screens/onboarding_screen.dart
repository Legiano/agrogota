import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finalizar(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_visto', true);
    await prefs.setBool('primeiro_acesso', false);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER — apresentação
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/icon.png',
                        width: 100, height: 100, fit: BoxFit.contain),
                    const SizedBox(height: 14),
                    const Text(
                      'AgroGota IrrigaTech',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1AAF72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                       'Tecnologia que irriga. Família que floresce.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF888780)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // CARDS DE DIFERENCIAIS
              _cardDiferencial(Icons.wifi_off, const Color(0xFF1AAF72),
                  'Funciona sem internet',
                  'Use no campo sem precisar de conexão'),
              const SizedBox(height: 8),
              _cardDiferencial(Icons.science_outlined, const Color(0xFF3F51B5),
                  'Base científica',
                  'Método Penman-Monteith FAO-56 — padrão internacional'),
              const SizedBox(height: 8),
              _cardDiferencial(Icons.landscape_outlined, const Color(0xFF795548),
                  'Solos do MS por município',
                  'Solo preenchido automaticamente pela sua região'),
              const SizedBox(height: 8),
              _cardDiferencial(Icons.water_outlined, const Color(0xFF00BCD4),
                  'Balanço hídrico mensal',
                  'Déficit e excedente de água por época do ano'),
              const SizedBox(height: 24),

              // DIVISOR
              Row(children: [
                Expanded(child: Divider(color: Colors.grey.shade200)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Como usar',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ]),
              const SizedBox(height: 20),

              // PASSO 1
              _passoTitulo('1', 'Configure o solo e a cultura',
                  const Color(0xFF1AAF72)),
              const SizedBox(height: 10),
              _infoBox(
                icone: Icons.tune,
                cor: const Color(0xFF1AAF72),
                texto: 'Faça isso apenas uma vez. O app guarda tudo.',
              ),
              const SizedBox(height: 8),
              _itemPasso(Icons.landscape_outlined,
                  'Selecione sua região e município — o tipo de solo é preenchido automaticamente'),
              _itemPasso(Icons.grass_outlined,
                  'Escolha o que está plantando — Alface, Tomate, Milho e mais 7 culturas'),
              _itemPasso(Icons.water_drop_outlined,
                  'Informe a vazão, a área por planta e a quantidade de gotejadores'),
              _itemPasso(Icons.save_outlined,
                  'Clique em Salvar e começar — pronto, nunca mais precisa mexer nisso'),
              const SizedBox(height: 20),

              // PASSO 2
              _passoTitulo(
                  '2', 'Informe o clima de hoje', const Color(0xFFFF9800)),
              const SizedBox(height: 10),
              _infoBox(
                icone: Icons.wb_sunny_outlined,
                cor: const Color(0xFFFF9800),
                texto: 'Faça isso todo dia antes de irrigar.',
              ),
              const SizedBox(height: 8),
              _itemPasso(Icons.thermostat_outlined,
                  'Informe a temperatura mais alta e mais baixa — use um termômetro simples'),
              _itemPasso(Icons.water_outlined,
                  'Informe a umidade mais alta e mais baixa — use um higrômetro'),
              _itemPasso(Icons.cloud_outlined,
                  'Se choveu, ligue o botão de chuva e informe quantos mm — o app desconta automaticamente'),
              _itemPasso(Icons.wb_cloudy_outlined,
                  'A luz solar é calculada automaticamente pela média histórica da região'),
              const SizedBox(height: 20),

              // PASSO 3
              _passoTitulo(
                  '3', 'Veja o resultado e irrigue', const Color(0xFF2196F3)),
              const SizedBox(height: 10),
              _infoBox(
                icone: Icons.timer_outlined,
                cor: const Color(0xFF2196F3),
                texto: 'Clique em Calcular e veja exatamente quanto irrigar.',
              ),
              const SizedBox(height: 8),
              _itemPasso(Icons.access_time_outlined,
                  'O app mostra o tempo em minutos — ligue a irrigação e aguarde'),
              _itemPasso(Icons.opacity_outlined,
                  'Mostra também a lâmina em milímetros e os litros por planta'),
              _itemPasso(Icons.history_outlined,
                  'Todos os cálculos ficam salvos no histórico'),
              _itemPasso(Icons.check_circle_outline,
                  'Desligue no tempo indicado e volte amanhã para novo cálculo'),
              const SizedBox(height: 24),

              // DICA IMPORTANTE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.tips_and_updates_outlined,
                        color: Color(0xFF1AAF72), size: 24),
                    SizedBox(height: 8),
                    Text(
                      'Dica importante',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F6E56)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Configure o solo e a cultura uma única vez. Depois, todo dia basta informar o clima e calcular. O app faz todo o resto!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF0F6E56)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // BOTÃO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _finalizar(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AAF72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entendi, vamos começar!',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // RODAPÉ
              const Center(
                child: Text(
                  'AgroGota IrrigaTech © 2026 — IFMS',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardDiferencial(
          IconData icone, Color cor, String titulo, String subtitulo) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icone, color: cor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C2C2A))),
                  const SizedBox(height: 2),
                  Text(subtitulo,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF888780))),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _passoTitulo(String numero, String titulo, Color cor) => Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
            child: Center(
              child: Text(numero,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(titulo,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cor)),
          ),
        ],
      );

  Widget _infoBox({
    required IconData icone,
    required Color cor,
    required String texto,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(texto,
                  style: TextStyle(
                      fontSize: 13,
                      color: cor,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  Widget _itemPasso(IconData icone, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, size: 17, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Expanded(
              child: Text(texto,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF444441),
                      height: 1.4)),
            ),
          ],
        ),
      );
}