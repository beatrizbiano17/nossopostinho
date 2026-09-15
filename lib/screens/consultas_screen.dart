import 'package:flutter/material.dart';
import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  List<Map<String, dynamic>> consultas = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarConsultas();
  }

  // Busca as consultas na API
  Future<void> _carregarConsultas() async {
    try {
      final resultado = await ApiService.buscarConsultas();

      if (!mounted) return;

      if (resultado["sucesso"] == true) {
        setState(() {
          consultas = List<Map<String, dynamic>>.from(
            resultado["consultas"] ?? [],
          );

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          carregando = false;
          erro = resultado["mensagem"] ?? "Não foi possível carregar as consultas.";
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

  // Formata a data do banco: 2026-09-20 → 20/09/2026
  String _formatarData(String data) {
    if (data.length >= 10) {
      final partes = data.substring(0, 10).split('-');

      if (partes.length == 3) {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    }

    return data;
  }

  // Formata o horário do banco: 14:30:00 → 14:30
  String _formatarHorario(String horario) {
    if (horario.length >= 5) {
      return horario.substring(0, 5);
    }

    return horario;
  }

  // Deixa o status mais bonito para aparecer na tela
  String _formatarStatus(String status) {
    switch (status.toLowerCase()) {
      case 'agendada':
        return 'Agendada';

      case 'realizada':
        return 'Realizada';

      case 'cancelada':
        return 'Cancelada';

      case 'faltou':
        return 'Não compareceu';

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
          'Minhas Consultas',
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

    // Se aconteceu algum erro
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
                'Não foi possível carregar as consultas.',
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

                  _carregarConsultas();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // Se não existem consultas
    if (consultas.isEmpty) {
      return const _SemConsultas();
    }

    // Mostra as consultas encontradas
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: consultas.length,

      itemBuilder: (context, index) {
        final consulta = consultas[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),

          child: _ConsultaCard(
            profissional:
                consulta['profissional_nome']?.toString() ??
                    'Profissional não informado',

            especialidade:
                consulta['especialidade']?.toString() ??
                    'Especialidade não informada',

            data: _formatarData(
              consulta['data_consulta']?.toString() ?? '',
            ),

            horario: _formatarHorario(
              consulta['horario']?.toString() ?? '',
            ),

            ubs:
                consulta['ubs_nome']?.toString() ??
                    'UBS não informada',

            status: _formatarStatus(
              consulta['status']?.toString() ?? '',
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DA CONSULTA
// ============================================================

class _ConsultaCard extends StatelessWidget {
  final String profissional;
  final String especialidade;
  final String data;
  final String horario;
  final String ubs;
  final String status;

  const _ConsultaCard({
    required this.profissional,
    required this.especialidade,
    required this.data,
    required this.horario,
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
          // Cabeçalho do card
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
                  Icons.calendar_month_outlined,
                  color: AppColors.azulEscuro,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      profissional,
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      especialidade,
                      style: AppTextStyles.textoPequeno.copyWith(
                        color: AppColors.azulMedio,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusConsulta(
                status: status,
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(
            color: AppColors.azulClaro,
          ),

          const SizedBox(height: 14),

          // Data
          _InformacaoConsulta(
            icone: Icons.calendar_today_outlined,
            titulo: 'Data',
            valor: data,
          ),

          const SizedBox(height: 12),

          // Horário
          _InformacaoConsulta(
            icone: Icons.access_time_outlined,
            titulo: 'Horário',
            valor: horario,
          ),

          const SizedBox(height: 12),

          // UBS
          _InformacaoConsulta(
            icone: Icons.location_on_outlined,
            titulo: 'UBS',
            valor: ubs,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS DA CONSULTA
// ============================================================

class _StatusConsulta extends StatelessWidget {
  final String status;

  const _StatusConsulta({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: AppColors.azulClaro,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: AppTextStyles.textoPequeno.copyWith(
          color: AppColors.azulEscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// INFORMAÇÕES DA CONSULTA
// ============================================================

class _InformacaoConsulta extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoConsulta({
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
// QUANDO NÃO HÁ CONSULTAS
// ============================================================

class _SemConsultas extends StatelessWidget {
  const _SemConsultas();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 70,
              color: AppColors.azulMedio,
            ),

            const SizedBox(height: 20),

            Text(
              'Nenhuma consulta encontrada',
              style: AppTextStyles.subtitulo,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Quando uma consulta for marcada no postinho, ela aparecerá aqui.',
              style: AppTextStyles.texto,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}