import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/database_helper.dart';
import '../models/solo.dart';
import '../models/cultura.dart';
import '../services/calculo_service.dart';
import '../data/kc_data.dart';
import '../data/solo_data.dart';
import '../data/regioes_ms_data.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  final _silteCtrl = TextEditingController();
  final _argilaCtrl = TextEditingController();
  final _espacamentoCtrl = TextEditingController();
  final _vazaoCtrl = TextEditingController();
  final _gotejadoresCtrl = TextEditingController(text: '1');

  String _culturaSelecionada = 'Alface';
  String _estagioSelecionado = 'intermediario';
  String _classeSoloSelecionada = 'Franco';
  String _regiaoSelecionada = 'Central';
  String? _municipioSelecionado;
  double _cc = 0;
  double _pmp = 0;
  bool _jaConfigurado = false;
  bool _modoAvancado = false;
  bool _usarMunicipio = false;

  final Map<String, String> _estagioLabels = {
    'inicial': 'Inicial — planta nova',
    'intermediario': 'Intermediário — crescendo',
    'final': 'Final — prestes a colher',
  };

  String _getHint(String unidade) {
    switch (unidade) {
      case '%':
        return 'ex: 30';
      case 'm²':
        return 'ex: 0.06';
      case 'L/h':
        return 'ex: 2.5';
      case 'un':
        return 'ex: 1';
      default:
        return '0';
    }
  }

  String? _validar(String? v, String unidade) {
    if (v == null || v.isEmpty) return 'Preencha';
    final valor = double.tryParse(v.replaceAll(',', '.'));
    if (valor == null) return 'Número inválido';

    switch (unidade) {
      case '%':
        if (valor < 1 || valor > 99) return 'Entre 1 e 99%';
        break;
      case 'm²':
        if (valor < 0.001 || valor > 30) return '0,001 a 30 m²';
        break;
      case 'L/h':
        if (valor < 0.1 || valor > 100) return '0,1 a 100 L/h';
        break;
      case 'un':
        final intVal = int.tryParse(v);
        if (intVal == null || intVal < 1 || intVal > 20) {
          return '1 a 20 un';
        }
        break;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _aplicarClasseSolo(_classeSoloSelecionada);
  }

  @override
  void dispose() {
    _silteCtrl.dispose();
    _argilaCtrl.dispose();
    _espacamentoCtrl.dispose();
    _vazaoCtrl.dispose();
    _gotejadoresCtrl.dispose();
    super.dispose();
  }

  void _aplicarClasseSolo(String classe) {
    final silte = SoloData.getSilte(classe);
    final argila = SoloData.getArgila(classe);
    setState(() {
      _classeSoloSelecionada = classe;
      _silteCtrl.text = silte.toStringAsFixed(0);
      _argilaCtrl.text = argila.toStringAsFixed(0);
      _cc = CalculoService.calcularCC(silte, argila);
      _pmp = CalculoService.calcularPMP(silte, argila);
    });
  }

  void _aplicarMunicipio(String municipio) {
    final classe = RegioesMSData.getSoloPorMunicipio(municipio);
    setState(() => _municipioSelecionado = municipio);
    _aplicarClasseSolo(classe);
  }

  void _calcularSolo() {
    final silte = double.tryParse(_silteCtrl.text) ?? 0;
    final argila = double.tryParse(_argilaCtrl.text) ?? 0;
    setState(() {
      _cc = CalculoService.calcularCC(silte, argila);
      _pmp = CalculoService.calcularPMP(silte, argila);
    });
  }

  Future<void> _carregarDados() async {
    final solo = await db.getSolo();
    final cultura = await db.getCultura();
    if (solo != null) {
      _silteCtrl.text = solo.silte.toString();
      _argilaCtrl.text = solo.argila.toString();
      _calcularSolo();
      setState(() => _jaConfigurado = true);
    }
    if (cultura != null) {
      setState(() {
        _culturaSelecionada = cultura.nome;
        _estagioSelecionado = cultura.estagio;
        _espacamentoCtrl.text = cultura.espacamento.toString();
        _vazaoCtrl.text = cultura.vazao.toString();
        _gotejadoresCtrl.text = cultura.gotejadores.toString();
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final silte = double.parse(_silteCtrl.text.replaceAll(',', '.'));
    final argila = double.parse(_argilaCtrl.text.replaceAll(',', '.'));
    final cc = CalculoService.calcularCC(silte, argila);
    final pmp = CalculoService.calcularPMP(silte, argila);

    await db.salvarSolo(Solo(silte: silte, argila: argila, cc: cc, pmp: pmp));
    await db.salvarCultura(
      Cultura(
        nome: _culturaSelecionada,
        estagio: _estagioSelecionado,
        kc: KcData.getKc(_culturaSelecionada, _estagioSelecionado),
        espacamento: double.parse(_espacamentoCtrl.text.replaceAll(',', '.')),
        vazao: double.parse(_vazaoCtrl.text.replaceAll(',', '.')),
        gotejadores: int.tryParse(_gotejadoresCtrl.text) ?? 1,
      ),
    );

    setState(() => _jaConfigurado = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _jaConfigurado
                ? 'Dados atualizados com sucesso!'
                : 'Dados salvos com sucesso!',
          ),
          backgroundColor: const Color(0xFF1AAF72),
        ),
      );
    }
  }

  Future<void> _resetar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apagar tudo?'),
        content: const Text(
          'Os dados do solo e da cultura serão apagados. Você terá que configurar tudo de novo.',
        ),
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
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await db.limparConfiguracoes();
      setState(() {
        _silteCtrl.clear();
        _argilaCtrl.clear();
        _espacamentoCtrl.clear();
        _vazaoCtrl.clear();
        _gotejadoresCtrl.text = '1';
        _culturaSelecionada = 'Alface';
        _estagioSelecionado = 'intermediario';
        _classeSoloSelecionada = 'Franco';
        _regiaoSelecionada = 'Central';
        _municipioSelecionado = null;
        _jaConfigurado = false;
        _modoAvancado = false;
        _usarMunicipio = false;
      });
      _calcularSolo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados apagados. Configure novamente.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final municipiosDaRegiao =
        RegioesMSData.getMunicipiosPorRegiao(_regiaoSelecionada);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _jaConfigurado ? 'Atualizar dados' : 'Configuração inicial',
        ),
        backgroundColor: const Color(0xFF1AAF72),
        foregroundColor: Colors.white,
        actions: [
          if (_jaConfigurado)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              tooltip: 'Apagar tudo',
              onPressed: _resetar,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_jaConfigurado)
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
                      Icon(Icons.edit_outlined,
                          color: Color(0xFF1AAF72), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Algo mudou? Atualize aqui e salve.',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF0F6E56)),
                        ),
                      ),
                    ],
                  ),
                ),

              // SEÇÃO LOCALIZAÇÃO
              _secaoTitulo('Sua localização no MS'),
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
                              _usarMunicipio
                                  ? 'Usando solo da minha cidade'
                                  : 'Selecionar pelo município',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _usarMunicipio
                                  ? 'Solo definido pelo mapa do MS'
                                  : 'Recomendado para produtores do MS',
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
                          value: _usarMunicipio,
                          activeThumbColor: const Color(0xFF1AAF72),
                          activeTrackColor: const Color(0xFF1AAF72)
                              .withValues(alpha: 0.3),
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade200,
                          onChanged: (v) {
                            setState(() {
                              _usarMunicipio = v;
                              if (!v) _municipioSelecionado = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_usarMunicipio) ...[
                  const SizedBox(height: 10),
                  _dropdownPadronizado(
                    label: 'Região do MS',
                    valor: _regiaoSelecionada,
                    opcoes: RegioesMSData.getRegioes(),
                    labelMap: null,
                    onChange: (v) {
                      setState(() {
                        _regiaoSelecionada = v!;
                        _municipioSelecionado = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (municipiosDaRegiao.isNotEmpty)
                    _dropdownPadronizado(
                      label: 'Município',
                      valor: _municipioSelecionado ??
                          municipiosDaRegiao.first,
                      opcoes: municipiosDaRegiao,
                      labelMap: null,
                      onChange: (v) => _aplicarMunicipio(v!),
                    ),
                  if (_municipioSelecionado != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F5EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Color(0xFF1AAF72), size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Solo de $_municipioSelecionado: $_classeSoloSelecionada',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0F6E56)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ]),

              const SizedBox(height: 16),

              // SEÇÃO SOLO
              _secaoTitulo('Tipo de solo'),
              _card([
                _dropdownPadronizado(
                  label: 'Qual é o tipo do seu solo?',
                  valor: _classeSoloSelecionada,
                  opcoes: SoloData.getClasses(),
                  labelMap: null,
                  onChange: (v) => _aplicarClasseSolo(v!),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    SoloData.getDescricao(_classeSoloSelecionada),
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF888780)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  _resultadoSolo('Água máxima\nno solo',
                      '${_cc.toStringAsFixed(1)}%'),
                  const SizedBox(width: 8),
                  _resultadoSolo('Limite mínimo\nde água',
                      '${_pmp.toStringAsFixed(1)}%'),
                ]),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      setState(() => _modoAvancado = !_modoAvancado),
                  child: Row(
                    children: [
                      Icon(
                        _modoAvancado
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: const Color(0xFF1AAF72),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _modoAvancado
                            ? 'Ocultar valores detalhados'
                            : 'Ver ou editar valores detalhados',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1AAF72),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_modoAvancado) ...[
                  const SizedBox(height: 8),
                  _campoNumerico('Silte do solo', _silteCtrl, '%',
                      onChange: _calcularSolo),
                  _campoNumerico('Argila do solo', _argilaCtrl, '%',
                      onChange: _calcularSolo),
                ],
              ]),

              const SizedBox(height: 16),
              _secaoTitulo('Cultura'),
              _card([
                _dropdownPadronizado(
                  label: 'O que está plantando?',
                  valor: _culturaSelecionada,
                  opcoes: KcData.getCulturas(),
                  labelMap: null,
                  onChange: (v) =>
                      setState(() => _culturaSelecionada = v!),
                ),
                const Divider(height: 16, color: Color(0xFFEEEEEE)),
                _dropdownPadronizado(
                  label: 'Fase da planta',
                  valor: _estagioSelecionado,
                  opcoes: ['inicial', 'intermediario', 'final'],
                  labelMap: _estagioLabels,
                  onChange: (v) =>
                      setState(() => _estagioSelecionado = v!),
                ),
              ]),

              const SizedBox(height: 16),
              _secaoTitulo('Sistema de irrigação'),
              _card([
                _campoNumerico('Área por planta', _espacamentoCtrl, 'm²'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Exemplos: Alface 0,06 m² | Tomate 0,50 m² | Milho 0,80 m²',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
                _campoNumerico(
                    'Água por hora do gotejador', _vazaoCtrl, 'L/h'),
                const SizedBox(height: 8),
                // NOVO — campo de gotejadores
                _campoGotejadores(),
              ]),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: Icon(
                    _jaConfigurado ? Icons.save_outlined : Icons.check,
                  ),
                  label: Text(
                    _jaConfigurado
                        ? 'Salvar alterações'
                        : 'Salvar e começar',
                    style: const TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1AAF72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Campo especial para gotejadores com botões + e -
  Widget _campoGotejadores() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Gotejadores por planta',
              style: TextStyle(fontSize: 13),
            ),
          ),
          // Botão -
          GestureDetector(
            onTap: () {
              final atual = int.tryParse(_gotejadoresCtrl.text) ?? 1;
              if (atual > 1) {
                setState(() =>
                    _gotejadoresCtrl.text = (atual - 1).toString());
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.remove, size: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          // Campo numérico
          SizedBox(
            width: 44,
            child: TextFormField(
              controller: _gotejadoresCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              validator: (v) => _validar(v, 'un'),
            ),
          ),
          const SizedBox(width: 8),
          // Botão +
          GestureDetector(
            onTap: () {
              final atual = int.tryParse(_gotejadoresCtrl.text) ?? 1;
              if (atual < 20) {
                setState(() =>
                    _gotejadoresCtrl.text = (atual + 1).toString());
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF1AAF72),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 6),
          const SizedBox(
            width: 28,
            child: Text('un',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),
        ],
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
            letterSpacing: 1,
          ),
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

  Widget _dropdownPadronizado({
    required String label,
    required String valor,
    required List<String> opcoes,
    required Map<String, String>? labelMap,
    required void Function(String?) onChange,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: valor,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color(0xFF1AAF72), width: 1.5),
              ),
            ),
            items: opcoes
                .map((o) => DropdownMenuItem(
                      value: o,
                      child: Text(
                        labelMap != null ? (labelMap[o] ?? o) : o,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ))
                .toList(),
            onChanged: onChange,
          ),
        ],
      );

  Widget _campoNumerico(
    String label,
    TextEditingController ctrl,
    String unidade, {
    VoidCallback? onChange,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(
                child:
                    Text(label, style: const TextStyle(fontSize: 13))),
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: ctrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _getHint(unidade),
                  hintStyle: TextStyle(
                      fontSize: 13, color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (_) => onChange?.call(),
                validator: (v) => _validar(v, unidade),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 28,
              child: Text(
                unidade,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      );

  Widget _resultadoSolo(String label, String valor) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F5EE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1AAF72),
                ),
              ),
            ],
          ),
        ),
      );
}