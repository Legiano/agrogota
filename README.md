# 💧 AgroGota IrrigaTech

Aplicativo mobile para manejo de irrigação voltado à agricultura familiar, desenvolvido em Flutter.

## 📱 Sobre o projeto

O AgroGota IrrigaTech auxilia pequenos produtores rurais a saberem exatamente quanto tempo devem deixar a irrigação ligada a cada dia, evitando desperdício de água e energia elétrica.

O app traduz cálculos científicos complexos em uma resposta simples e direta:
> **"Ligue a irrigação por X minutos hoje."**

## 🎯 Público-alvo

- Pequenos agricultores familiares
- Assentamentos rurais
- Produtores de hortaliças e frutas
- Técnicos agrônomos e extensionistas rurais
- Instituições de ensino agrícola (IFMS e similares)

## ⚙️ Como funciona

**Primeira vez (configuração única):**
1. Informa o tipo do solo (% silte e % argila)
2. Escolhe a cultura plantada e o estágio da planta
3. Informa a vazão do gotejador e o espaçamento entre plantas

**Todo dia:**
1. Informa a temperatura máxima e mínima do dia
2. Informa a umidade relativa máxima e mínima
3. Clica em **Calcular tempo de irrigação**
4. Recebe o resultado em minutos, milímetros e litros por planta

## 🧠 Base científica

O cálculo utiliza o método **Penman-Monteith (FAO-56)**, padrão internacional para estimativa de evapotranspiração, combinado com:

- **ETc = ETo × Kc** — evapotranspiração da cultura
- **CC e PMP** — calculados a partir de silte + argila
- **Lâmina de irrigação** — baseada na água disponível no solo
- **Tempo de irrigação** — calculado pela vazão e espaçamento

## 🌱 Culturas disponíveis

Alface, Tomate, Pimentão, Cenoura, Cebola, Feijão, Melancia, Melão, Milho e Pepino.

## 📡 Funciona 100% offline

Todos os dados necessários estão dentro do app:
- Banco de Kc por cultura e estágio fenológico
- Radiação solar média histórica mensal para o Mato Grosso do Sul
- Banco de dados local SQLite para histórico e configurações

## 🛠️ Tecnologias utilizadas

- [Flutter](https://flutter.dev/) — framework multiplataforma
- [Dart](https://dart.dev/) — linguagem de programação
- [SQLite (sqflite)](https://pub.dev/packages/sqflite) — banco de dados local
- [Shared Preferences](https://pub.dev/packages/shared_preferences) — armazenamento local
- [Provider](https://pub.dev/packages/provider) — gerenciamento de estado

## 📂 Estrutura do projeto

lib/
├── main.dart
├── db/
│   └── database_helper.dart
├── models/
│   ├── solo.dart
│   ├── cultura.dart
│   ├── entrada_climatica.dart
│   └── resultado.dart
├── data/
│   ├── kc_data.dart
│   └── radiacao_data.dart
├── services/
│   └── calculo_service.dart
└── screens/
    ├── welcome_screen.dart
    ├── entrada_screen.dart
    ├── resultado_screen.dart
    ├── historico_screen.dart
    └── config_screen.dart
    
## 🚀 Como rodar o projeto

```bash
# Clone o repositório
git clone https://github.com/Legiano/agrogota.git

# Entre na pasta
cd AgroGota

# Instale as dependências
flutter pub get

# Rode o app
flutter run
```

## 📦 Gerar APK

```bash
flutter build apk --release
```

O arquivo será gerado em:
build/app/outputs/flutter-apk/app-release.apk

## 👨‍💻 Desenvolvido por

**Legiano Lucio Rodrigues**

Projeto desenvolvido no **IFMS — Instituto Federal de Mato Grosso do Sul**
---

© 2026 AgroGota IrrigaTech — IFMS
