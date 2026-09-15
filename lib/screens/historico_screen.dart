import 'package:flutter/material.dart';
import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  int _abaSelecionada = 0;

  // Atendimentos vindos da API
  List<Map<String, dynamic>> atendimentos = [];

  // Dados temporários das vacinas.
  // A integração com o banco será feita depois.
  final List<Map<String, String>> vacinas = const [
    {
      'vacina': 'Influenza',
      'data': '05/05/2026',
      'dose': 'Dose anual',
      'local': 'UBS Central',
    },
    {
      'vacina': 'COVID-19',
      'data': '15/03/2026',
      'dose': 'Dose de reforço',
      'local': 'UBS Central',
    },
    {
      'vacina': 'Hepatite B',
      'data': '10/01/2026',
      'dose': '3ª dose',
      'local': 'UBS do Bairro',
    },
  ];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();

    _carregarAtendimentos();
  }

  // ============================================================
  // BUSCAR ATENDIMENTOS NA API
  // ============================================================

  Future<void> _carregarAtendimentos() async {
    try {
      final resultado =
          await ApiService.buscarHistorico();

      if (!mounted) return;

      if (resultado["sucesso"] == true) {
        setState(() {
          atendimentos =
              List<Map<String, dynamic>>.from(
            resultado["atendimentos"] ?? [],
          );

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          carregando = false;
          erro = resultado["mensagem"] ??
              "Não foi possível carregar o histórico.";
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = "Não foi possível conectar com o servidor.";
      });
    }
  }

  // ============================================================
  // FORMATAR DATA
  // ============================================================

  String _formatarData(String data) {
    if (data.length >= 10) {
      final partes = data.substring(0, 10).split('-');

      if (partes.length == 3) {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Histórico',
          style: AppTextStyles.subtitulo,
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          // ====================================================
          // ABAS
          // ====================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Row(
              children: [
                Expanded(
                  child: _BotaoAba(
                    titulo: 'Atendimentos',
                    selecionado: _abaSelecionada == 0,

                    onTap: () {
                      setState(() {
                        _abaSelecionada = 0;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _BotaoAba(
                    titulo: 'Vacinação',
                    selecionado: _abaSelecionada == 1,

                    onTap: () {
                      setState(() {
                        _abaSelecionada = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: _abaSelecionada == 0
                ? _conteudoAtendimentos()
                : _ListaVacinas(
                    vacinas: vacinas,
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTEÚDO DOS ATENDIMENTOS
  // ============================================================

  Widget _conteudoAtendimentos() {
    // Enquanto carrega
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Caso aconteça algum erro
    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(
                Icons.error_outline,
                size: 70,
                color: AppColors.azulMedio,
              ),

              const SizedBox(height: 20),

              Text(
                'Não foi possível carregar o histórico.',
                style: AppTextStyles.subtitulo,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                erro!,
                style: AppTextStyles.texto,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    carregando = true;
                    erro = null;
                  });

                  _carregarAtendimentos();
                },

                child: const Text(
                  'Tentar novamente',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _ListaAtendimentos(
      atendimentos: atendimentos,
    );
  }
}

// ============================================================
// BOTÃO DAS ABAS
// ============================================================

class _BotaoAba extends StatelessWidget {
  final String titulo;
  final bool selecionado;
  final VoidCallback onTap;

  const _BotaoAba({
    required this.titulo,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),

        decoration: BoxDecoration(
          color: selecionado
              ? AppColors.azulMedio
              : AppColors.azulClaro,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Text(
          titulo,

          style: AppTextStyles.texto.copyWith(
            color: selecionado
                ? AppColors.branco
                : AppColors.azulEscuro,

            fontWeight: FontWeight.bold,
          ),

          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ============================================================
// LISTA DE ATENDIMENTOS
// ============================================================

class _ListaAtendimentos extends StatelessWidget {
  final List<Map<String, dynamic>> atendimentos;

  const _ListaAtendimentos({
    required this.atendimentos,
  });

  @override
  Widget build(BuildContext context) {
    if (atendimentos.isEmpty) {
      return const _SemHistorico(
        icone: Icons.medical_services_outlined,
        mensagem: 'Nenhum atendimento registrado.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        20,
      ),

      itemCount: atendimentos.length,

      itemBuilder: (context, index) {
        final atendimento = atendimentos[index];

        String data =
            atendimento['data_atendimento']?.toString() ?? '';

        // Formata a data
        if (data.length >= 10) {
          final partes =
              data.substring(0, 10).split('-');

          if (partes.length == 3) {
            data =
                '${partes[2]}/${partes[1]}/${partes[0]}';
          }
        }

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),

          child: _AtendimentoCard(
            data: data,

            profissional:
                atendimento['profissional_nome']
                        ?.toString() ??
                    'Profissional não informado',

            especialidade:
                atendimento['especialidade']
                        ?.toString() ??
                    'Especialidade não informada',

            ubs:
                atendimento['ubs_nome']
                        ?.toString() ??
                    'UBS não informada',

            descricao:
                atendimento['descricao']
                        ?.toString() ??
                    'Nenhuma descrição informada.',
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DE ATENDIMENTO
// ============================================================

class _AtendimentoCard extends StatelessWidget {
  final String data;
  final String profissional;
  final String especialidade;
  final String ubs;
  final String descricao;

  const _AtendimentoCard({
    required this.data,
    required this.profissional,
    required this.especialidade,
    required this.ubs,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.branco,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: AppColors.azulClaro,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.azulEscuro,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      especialidade,
                      style:
                          AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      profissional,
                      style:
                          AppTextStyles.textoPequeno,
                    ),
                  ],
                ),
              ),

              Text(
                data,

                style:
                    AppTextStyles.textoPequeno.copyWith(
                  color: AppColors.azulMedio,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(
            color: AppColors.azulClaro,
          ),

          const SizedBox(height: 12),

          _InformacaoHistorico(
            icone: Icons.location_on_outlined,
            titulo: 'UBS',
            valor: ubs,
          ),

          const SizedBox(height: 10),

          _InformacaoHistorico(
            icone: Icons.description_outlined,
            titulo: 'Atendimento',
            valor: descricao,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LISTA DE VACINAS
// ============================================================

class _ListaVacinas extends StatelessWidget {
  final List<Map<String, String>> vacinas;

  const _ListaVacinas({
    required this.vacinas,
  });

  @override
  Widget build(BuildContext context) {
    if (vacinas.isEmpty) {
      return const _SemHistorico(
        icone: Icons.vaccines_outlined,
        mensagem: 'Nenhuma vacina registrada.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        20,
      ),

      itemCount: vacinas.length,

      itemBuilder: (context, index) {
        final vacina = vacinas[index];

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),

          child: _VacinaCard(
            vacina: vacina['vacina']!,
            data: vacina['data']!,
            dose: vacina['dose']!,
            local: vacina['local']!,
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DE VACINA
// ============================================================

class _VacinaCard extends StatelessWidget {
  final String vacina;
  final String data;
  final String dose;
  final String local;

  const _VacinaCard({
    required this.vacina,
    required this.data,
    required this.dose,
    required this.local,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.branco,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: AppColors.azulClaro,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: AppColors.azulClaro,
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.vaccines_outlined,
              color: AppColors.azulEscuro,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  vacina,
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 5),

                Text(
                  dose,
                  style: AppTextStyles.texto,
                ),

                const SizedBox(height: 4),

                Text(
                  'Aplicada em $data',
                  style:
                      AppTextStyles.textoPequeno,
                ),

                const SizedBox(height: 4),

                Text(
                  local,
                  style:
                      AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulMedio,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle_outline,
            color: AppColors.azulMedio,
            size: 25,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INFORMAÇÃO DO HISTÓRICO
// ============================================================

class _InformacaoHistorico extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoHistorico({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Icon(
          icone,
          color: AppColors.azulMedio,
          size: 21,
        ),

        const SizedBox(width: 10),

        Text(
          '$titulo:',
          style: AppTextStyles.texto.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 5),

        Expanded(
          child: Text(
            valor,
            style: AppTextStyles.texto,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SEM HISTÓRICO
// ============================================================

class _SemHistorico extends StatelessWidget {
  final IconData icone;
  final String mensagem;

  const _SemHistorico({
    required this.icone,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icone,
              size: 70,
              color: AppColors.azulMedio,
            ),

            const SizedBox(height: 20),

            Text(
              mensagem,
              style: AppTextStyles.subtitulo,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}