  import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ConsultasScreen extends StatelessWidget {
  const ConsultasScreen({super.key});

  // Dados temporários para testar a tela.
  // Depois serão substituídos pelos dados vindos do banco.
  final List<Map<String, String>> consultas = const [
    {
      'profissional': 'Dra. Ana Souza',
      'especialidade': 'Clínica Geral',
      'data': '15/09/2026',
      'horario': '14:30',
      'ubs': 'UBS Central',
      'status': 'Agendada',
    },
    {
      'profissional': 'Dr. Carlos Oliveira',
      'especialidade': 'Clínica Geral',
      'data': '28/09/2026',
      'horario': '09:00',
      'ubs': 'UBS Central',
      'status': 'Agendada',
    },
    {
      'profissional': 'Dra. Mariana Costa',
      'especialidade': 'Enfermagem',
      'data': '05/10/2026',
      'horario': '10:30',
      'ubs': 'UBS do Bairro',
      'status': 'Agendada',
    },
  ];

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

      body: consultas.isEmpty
          ? _SemConsultas()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: consultas.length,
              itemBuilder: (context, index) {
                final consulta = consultas[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _ConsultaCard(
                    profissional: consulta['profissional']!,
                    especialidade: consulta['especialidade']!,
                    data: consulta['data']!,
                    horario: consulta['horario']!,
                    ubs: consulta['ubs']!,
                    status: consulta['status']!,
                  ),
                );
              },
            ),
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

              _StatusConsulta(status: status),
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