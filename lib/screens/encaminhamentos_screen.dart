import 'package:flutter/material.dart';
import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class EncaminhamentosScreen extends StatefulWidget {
  const EncaminhamentosScreen({super.key});

  @override
  State<EncaminhamentosScreen> createState() =>
      _EncaminhamentosScreenState();
}

class _EncaminhamentosScreenState
    extends State<EncaminhamentosScreen> {

  List<Map<String, dynamic>> encaminhamentos = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarEncaminhamentos();
  }

  // Busca os encaminhamentos na API
  Future<void> _carregarEncaminhamentos() async {
    try {
      final resultado =
          await ApiService.buscarEncaminhamentos();

      if (!mounted) return;

      if (resultado["sucesso"] == true) {
        setState(() {
          encaminhamentos =
              List<Map<String, dynamic>>.from(
            resultado["encaminhamentos"] ?? [],
          );

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          carregando = false;
          erro = resultado["mensagem"] ??
              "Não foi possível carregar os encaminhamentos.";
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

  // Formata a data do banco
  // 2026-09-10 → 10/09/2026
  String _formatarData(String data) {
    if (data.length >= 10) {
      final partes = data.substring(0, 10).split('-');

      if (partes.length == 3) {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    }

    return data;
  }

  // Deixa o status mais bonito para a tela
  String _formatarStatus(String status) {
    switch (status.toLowerCase()) {
      case 'solicitado':
        return 'Solicitado';

      case 'em_analise':
        return 'Em análise';

      case 'aprovado':
        return 'Aprovado';

      case 'agendado':
        return 'Agendado';

      case 'concluido':
        return 'Concluído';

      case 'concluído':
        return 'Concluído';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Encaminhamentos',
          style: AppTextStyles.subtitulo,
        ),
      ),

      body: _conteudo(),
    );
  }

  Widget _conteudo() {
    // Enquanto busca os dados
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
                'Não foi possível carregar os encaminhamentos.',
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

                  _carregarEncaminhamentos();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Se não existem encaminhamentos
    if (encaminhamentos.isEmpty) {
      return const _SemEncaminhamentos();
    }

    // Mostra os encaminhamentos
    return ListView.builder(
      padding: const EdgeInsets.all(20),

      itemCount: encaminhamentos.length,

      itemBuilder: (context, index) {
        final encaminhamento =
            encaminhamentos[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),

          child: _EncaminhamentoCard(
            especialidade:
                encaminhamento['especialidade']?.toString() ??
                    'Especialidade não informada',

            profissional:
                encaminhamento['profissional_nome']?.toString() ??
                    'Profissional não informado',

            data: _formatarData(
              encaminhamento['data_encaminhamento']
                      ?.toString() ??
                  '',
            ),

            ubs:
                encaminhamento['ubs_nome']?.toString() ??
                    'UBS não informada',

            status: _formatarStatus(
              encaminhamento['status']?.toString() ??
                  '',
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DO ENCAMINHAMENTO
// ============================================================

class _EncaminhamentoCard extends StatelessWidget {
  final String especialidade;
  final String profissional;
  final String data;
  final String ubs;
  final String status;

  const _EncaminhamentoCard({
    required this.especialidade,
    required this.profissional,
    required this.data,
    required this.ubs,
    required this.status,
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
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Cabeçalho
          Row(
            children: [
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.assignment_outlined,
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
                      especialidade,
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Encaminhamento médico',
                      style:
                          AppTextStyles.textoPequeno.copyWith(
                        color: AppColors.azulMedio,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            color: AppColors.azulClaro,
          ),

          const SizedBox(height: 14),

          _InformacaoEncaminhamento(
            icone: Icons.person_outline,
            titulo: 'Profissional',
            valor: profissional,
          ),

          const SizedBox(height: 12),

          _InformacaoEncaminhamento(
            icone: Icons.calendar_today_outlined,
            titulo: 'Data',
            valor: data,
          ),

          const SizedBox(height: 12),

          _InformacaoEncaminhamento(
            icone: Icons.location_on_outlined,
            titulo: 'UBS',
            valor: ubs,
          ),

          const SizedBox(height: 18),

          // Status
          Text(
            'Status do encaminhamento',
            style: AppTextStyles.texto.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          _StatusEncaminhamento(
            status: status,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS DO ENCAMINHAMENTO
// ============================================================

class _StatusEncaminhamento extends StatelessWidget {
  final String status;

  const _StatusEncaminhamento({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    IconData icone;

    switch (status.toLowerCase()) {
      case 'concluído':
      case 'concluido':
        icone = Icons.check_circle_outline;
        break;

      case 'agendado':
        icone = Icons.event_available_outlined;
        break;

      case 'aprovado':
        icone = Icons.check_circle_outline;
        break;

      case 'em análise':
      case 'em_analise':
        icone = Icons.search_outlined;
        break;

      case 'solicitado':
        icone = Icons.hourglass_empty;
        break;

      default:
        icone = Icons.info_outline;
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: AppColors.azulClaro,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          Icon(
            icone,
            color: AppColors.azulEscuro,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              status,

              style: AppTextStyles.texto.copyWith(
                color: AppColors.azulEscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INFORMAÇÕES DO ENCAMINHAMENTO
// ============================================================

class _InformacaoEncaminhamento
    extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoEncaminhamento({
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
          size: 22,
        ),

        const SizedBox(width: 12),

        Text(
          '$titulo:',
          style: AppTextStyles.texto.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 6),

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
// QUANDO NÃO HÁ ENCAMINHAMENTOS
// ============================================================

class _SemEncaminhamentos
    extends StatelessWidget {
  const _SemEncaminhamentos();

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
              Icons.assignment_outlined,
              size: 70,
              color: AppColors.azulMedio,
            ),

            const SizedBox(height: 20),

            Text(
              'Nenhum encaminhamento encontrado',
              style: AppTextStyles.subtitulo,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Quando um encaminhamento for realizado, ele aparecerá aqui.',
              style: AppTextStyles.texto,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}