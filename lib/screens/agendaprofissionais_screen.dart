import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class AgendaProfissionaisScreen extends StatelessWidget {
  const AgendaProfissionaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda dos Profissionais'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Profissionais da UBS',
            style: AppTextStyles.titulo,
          ),

          const SizedBox(height: 8),

          Text(
            'Consulte os profissionais, horários de atendimento e quantidade de pacientes.',
            style: AppTextStyles.texto,
          ),

          const SizedBox(height: 20),

          _CardProfissional(
            nome: 'Dra. Ana Carolina',
            profissao: 'Clínica Geral',
            ubs: 'UBS Central',
            dias: 'Segunda e quarta-feira',
            horario: '08:00 às 12:00',
            pacientes: '12 pacientes',
          ),

          _CardProfissional(
            nome: 'Dr. João Pedro',
            profissao: 'Clínico Geral',
            ubs: 'UBS Central',
            dias: 'Terça e quinta-feira',
            horario: '13:00 às 17:00',
            pacientes: '15 pacientes',
          ),

          _CardProfissional(
            nome: 'Dra. Mariana Souza',
            profissao: 'Enfermeira',
            ubs: 'UBS Central',
            dias: 'Segunda a sexta-feira',
            horario: '07:30 às 13:30',
            pacientes: '20 pacientes',
          ),

          _CardProfissional(
            nome: 'Carlos Henrique',
            profissao: 'Dentista',
            ubs: 'UBS Central',
            dias: 'Quarta e sexta-feira',
            horario: '08:00 às 16:00',
            pacientes: '10 pacientes',
          ),
        ],
      ),
    );
  }
}

class _CardProfissional extends StatelessWidget {
  final String nome;
  final String profissao;
  final String ubs;
  final String dias;
  final String horario;
  final String pacientes;

  const _CardProfissional({
    required this.nome,
    required this.profissao,
    required this.ubs,
    required this.dias,
    required this.horario,
    required this.pacientes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.branco,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.azulClaro,
                  child: Icon(
                    Icons.person,
                    color: AppColors.azulEscuro,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: AppTextStyles.subtitulo,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        profissao,
                        style: AppTextStyles.textoPequeno.copyWith(
                          color: AppColors.azulMedio,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _Informacao(
              icone: Icons.local_hospital,
              texto: ubs,
            ),

            const SizedBox(height: 8),

            _Informacao(
              icone: Icons.calendar_month,
              texto: dias,
            ),

            const SizedBox(height: 8),

            _Informacao(
              icone: Icons.access_time,
              texto: horario,
            ),

            const SizedBox(height: 8),

            _Informacao(
              icone: Icons.people,
              texto: pacientes,
            ),
          ],
        ),
      ),
    );
  }
}

class _Informacao extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _Informacao({
    required this.icone,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icone,
          size: 20,
          color: AppColors.azulMedio,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            texto,
            style: AppTextStyles.texto,
          ),
        ),
      ],
    );
  }
}