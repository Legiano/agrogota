import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/config_screen.dart';
import 'screens/entrada_screen.dart';
import 'screens/resultado_screen.dart';
import 'screens/historico_screen.dart';
import 'models/resultado.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingVisto = prefs.getBool('onboarding_visto') ?? false;
  runApp(IrrigaFacilApp(rotaInicial: onboardingVisto ? '/home' : '/onboarding'));
}

class IrrigaFacilApp extends StatelessWidget {
  final String rotaInicial;
  const IrrigaFacilApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroGota',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1AAF72),
          primary: const Color(0xFF1AAF72),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: rotaInicial,
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  Resultado? _ultimoResultado;

  void _setResultado(Resultado r) {
    setState(() {
      _ultimoResultado = r;
      _currentIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      EntradaScreen(onResultado: _setResultado),
      const HistoricoScreen(),
      ResultadoScreen(resultado: _ultimoResultado),
      const ConfigScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFE1F5EE),
            height: 65,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop, color: Color(0xFF1AAF72)),
                label: 'Irrigar',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history, color: Color(0xFF1AAF72)),
                label: 'Histórico',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF1AAF72)),
                label: 'Resultado',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings, color: Color(0xFF1AAF72)),
                label: 'Config.',
              ),
            ],
          ),
          // Rodapé
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: const Text(
              'AgroGota IrrigaTech © 2026 — IFMS',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
