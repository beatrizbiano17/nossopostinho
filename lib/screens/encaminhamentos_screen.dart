import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class EncaminhamentosScreen extends StatelessWidget {
  const EncaminhamentosScreen({super.key});

  // Dados temporários para testar a tela.
  // Depois serão substituídos pelos dados vindos da API.
  final List<Map<String, String>> encaminhamentos = const [
    {
      'especialidade': 'Cardiologia',
      'profissional': 'Dra. Ana Souza',
      'data': '10/08/2026',
      'ubs': 'UBS Central',
      'status': 'Em análise',
    },
    {
      'especialidade': 'Oftalmologia',
      'profissional': 'Dr. Carlos Oliveira',
      'data': '25/07/2026',
      'ubs': 'UBS Central',
      'status': 'Aguardando agendamento',
    },
    {
      'especialidade': 'Dermatologia',
      'profissional': 'Dra. Mariana Costa',
      'data': '12/06/2026',
      'ubs': 'UBS do Bairro',
      'status': 'Concluído',
    },
  ];

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

      body: encaminhamentos.isEmpty
          ? const _SemEncaminhamentos()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: encaminhamentos.length,
              itemBuilder: (context, index) {
                final encaminhamento = encaminhamentos[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _EncaminhamentoCard(
                    especialidade:
                        encaminhamento['especialidade']!,
                    profissional:
                        encaminhamento['profissional']!,
                    data: encaminhamento['data']!,
                    ubs: encaminhamento['ubs']!,
                    status: encaminhamento['status']!,
                  ),
                );
              },
            ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      especialidade,
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Encaminhamento médico',
                      style: AppTextStyles.textoPequeno.copyWith(
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

    switch (status) {
      case 'Concluído':
        icone = Icons.check_circle_outline;
        break;

      case 'Aguardando agendamento':
        icone = Icons.schedule_outlined;
        break;

      default:
        icone = Icons.hourglass_empty;
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

class _InformacaoEncaminhamento extends StatelessWidget {
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

class _SemEncaminhamentos extends StatelessWidget {
  const _SemEncaminhamentos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

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