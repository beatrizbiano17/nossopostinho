import 'package:flutter/material.dart';
import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class VacinacaoScreen extends StatefulWidget {
  const VacinacaoScreen({super.key});

  @override
  State<VacinacaoScreen> createState() => _VacinacaoScreenState();
}

class _VacinacaoScreenState extends State<VacinacaoScreen> {
  int _abaSelecionada = 0;

  bool _carregando = true;
  String? _erro;

  List<Map<String, String>> minhasVacinas = [];
  List<Map<String, String>> proximasDoses = [];
  List<Map<String, String>> campanhas = [];

  @override
  void initState() {
    super.initState();
    _carregarVacinacao();
  }

  // ============================================================
  // CARREGAR DADOS DA API
  // ============================================================

  Future<void> _carregarVacinacao() async {
    try {
      final resultado = await ApiService.buscarVacinacao();

      if (!mounted) return;

      if (resultado["sucesso"] == true) {
        setState(() {
          minhasVacinas =
              List<Map<String, dynamic>>.from(
                resultado["vacinas"] ?? [],
              ).map(
                (vacina) => {
                  "vacina": vacina["vacina"].toString(),
                  "dose": vacina["dose"].toString(),
                  "data": _formatarData(
                    vacina["data"].toString(),
                  ),
                  "local": vacina["local"].toString(),
                },
              ).toList();

          campanhas =
              List<Map<String, dynamic>>.from(
                resultado["campanhas"] ?? [],
              ).map(
                (campanha) => {
                  "titulo": campanha["titulo"].toString(),
                  "descricao":
                      campanha["descricao"]?.toString() ??
                      "Sem descrição.",
                  "periodo":
                      "${_formatarData(campanha["data_inicio"].toString())} até "
                      "${_formatarData(campanha["data_fim"].toString())}",
                },
              ).toList();

          _carregando = false;
          _erro = null;
        });
      } else {
        setState(() {
          _carregando = false;
          _erro =
              resultado["mensagem"] ??
              "Não foi possível carregar os dados.";
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro =
            "Não foi possível conectar com o servidor.";
      });
    }
  }

  // ============================================================
  // FORMATA DATA
  // ============================================================

  String _formatarData(String data) {
    if (data.length == 10 && data.contains("-")) {
      final partes = data.split("-");

      return "${partes[2]}/${partes[1]}/${partes[0]}";
    }

    return data;
  }

  // ============================================================
  // CONTEÚDO DA ABA
  // ============================================================

  Widget _conteudoSelecionado() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.azulMedio,
              ),
              const SizedBox(height: 20),
              Text(
                _erro!,
                style: AppTextStyles.texto,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _carregarVacinacao,
                child: const Text("Tentar novamente"),
              ),
            ],
          ),
        ),
      );
    }

    switch (_abaSelecionada) {
      case 1:
        return _ListaProximasDoses(
          proximasDoses: proximasDoses,
        );

      case 2:
        return _ListaCampanhas(
          campanhas: campanhas,
        );

      default:
        return _ListaMinhasVacinas(
          vacinas: minhasVacinas,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Vacinação',
          style: AppTextStyles.subtitulo,
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          // ======================================================
          // ABAS
          // ======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _BotaoAba(
                    titulo: 'Minhas vacinas',
                    selecionado: _abaSelecionada == 0,
                    onTap: () {
                      setState(() {
                        _abaSelecionada = 0;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _BotaoAba(
                    titulo: 'Próximas doses',
                    selecionado: _abaSelecionada == 1,
                    onTap: () {
                      setState(() {
                        _abaSelecionada = 1;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _BotaoAba(
                    titulo: 'Campanhas',
                    selecionado: _abaSelecionada == 2,
                    onTap: () {
                      setState(() {
                        _abaSelecionada = 2;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: _conteudoSelecionado(),
          ),
        ],
      ),
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
          vertical: 12,
          horizontal: 5,
        ),

        decoration: BoxDecoration(
          color: selecionado
              ? AppColors.azulMedio
              : AppColors.azulClaro,

          borderRadius: BorderRadius.circular(10),
        ),

        child: Text(
          titulo,

          style: AppTextStyles.textoPequeno.copyWith(
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
// MINHAS VACINAS
// ============================================================

class _ListaMinhasVacinas extends StatelessWidget {
  final List<Map<String, String>> vacinas;

  const _ListaMinhasVacinas({
    required this.vacinas,
  });

  @override
  Widget build(BuildContext context) {
    if (vacinas.isEmpty) {
      return const _SemVacinas(
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
            dose: vacina['dose']!,
            data: vacina['data']!,
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
  final String dose;
  final String data;
  final String local;

  const _VacinaCard({
    required this.vacina,
    required this.dose,
    required this.data,
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
            color: Colors.black.withValues(alpha: 0.05),
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
              borderRadius: BorderRadius.circular(12),
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

                const SizedBox(height: 4),

                Text(
                  dose,
                  style: AppTextStyles.texto,
                ),

                const SizedBox(height: 5),

                Text(
                  'Aplicada em $data',
                  style: AppTextStyles.textoPequeno,
                ),

                const SizedBox(height: 3),

                Text(
                  local,
                  style: AppTextStyles.textoPequeno.copyWith(
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
// PRÓXIMAS DOSES
// ============================================================

class _ListaProximasDoses extends StatelessWidget {
  final List<Map<String, String>> proximasDoses;

  const _ListaProximasDoses({
    required this.proximasDoses,
  });

  @override
  Widget build(BuildContext context) {
    if (proximasDoses.isEmpty) {
      return const _SemVacinas(
        mensagem:
            'Nenhuma próxima dose registrada.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        20,
      ),

      itemCount: proximasDoses.length,

      itemBuilder: (context, index) {
        final vacina = proximasDoses[index];

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),

          child: _ProximaDoseCard(
            vacina: vacina['vacina']!,
            dose: vacina['dose']!,
            data: vacina['data']!,
            local: vacina['local']!,
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DA PRÓXIMA DOSE
// ============================================================

class _ProximaDoseCard extends StatelessWidget {
  final String vacina;
  final String dose;
  final String data;
  final String local;

  const _ProximaDoseCard({
    required this.vacina,
    required this.dose,
    required this.data,
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
            color: Colors.black.withValues(alpha: 0.05),
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
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.schedule_outlined,
                  color: AppColors.azulEscuro,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  vacina,
                  style: AppTextStyles.subtitulo,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _InformacaoVacina(
            icone:
                Icons.medical_information_outlined,
            titulo: 'Dose',
            valor: dose,
          ),

          const SizedBox(height: 10),

          _InformacaoVacina(
            icone:
                Icons.calendar_today_outlined,
            titulo: 'Data prevista',
            valor: data,
          ),

          const SizedBox(height: 10),

          _InformacaoVacina(
            icone:
                Icons.location_on_outlined,
            titulo: 'UBS',
            valor: local,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CAMPANHAS
// ============================================================

class _ListaCampanhas extends StatelessWidget {
  final List<Map<String, String>> campanhas;

  const _ListaCampanhas({
    required this.campanhas,
  });

  @override
  Widget build(BuildContext context) {
    if (campanhas.isEmpty) {
      return const _SemVacinas(
        mensagem: 'Nenhuma campanha disponível.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        20,
      ),

      itemCount: campanhas.length,

      itemBuilder: (context, index) {
        final campanha = campanhas[index];

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),

          child: _CampanhaCard(
            titulo: campanha['titulo']!,
            descricao: campanha['descricao']!,
            periodo: campanha['periodo']!,
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DA CAMPANHA
// ============================================================

class _CampanhaCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String periodo;

  const _CampanhaCard({
    required this.titulo,
    required this.descricao,
    required this.periodo,
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
            color: Colors.black.withValues(alpha: 0.05),
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
                  Icons.campaign_outlined,
                  color: AppColors.azulEscuro,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  titulo,
                  style: AppTextStyles.subtitulo,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            descricao,
            style: AppTextStyles.texto,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.azulMedio,
                size: 20,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  periodo,
                  style:
                      AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulMedio,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INFORMAÇÃO DA VACINA
// ============================================================

class _InformacaoVacina extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoVacina({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
// SEM VACINAS
// ============================================================

class _SemVacinas extends StatelessWidget {
  final String mensagem;

  const _SemVacinas({
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
            const Icon(
              Icons.vaccines_outlined,
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