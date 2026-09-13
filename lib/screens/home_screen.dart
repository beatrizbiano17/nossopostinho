import 'package:flutter/material.dart';

import 'perfil_screen.dart';
import 'consultas_screen.dart';
import 'encaminhamentos_screen.dart';
import 'historico_screen.dart';
import 'medicamentos_screen.dart';
import 'notificacoes_screen.dart';
import 'vacinacao_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Image.asset(
          'assets/images/nosso_postinho_header.png.jpeg',
          height: 45,
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),

            onSelected: (valor) {
              // ----------------------------------------------------
              // MEU PERFIL
              // ----------------------------------------------------

              if (valor == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PerfilScreen(),
                  ),
                );
              }

              // ----------------------------------------------------
              // NOTIFICAÇÕES
              // ----------------------------------------------------

              if (valor == 'notificacoes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const NotificacoesScreen(),
                  ),
                );
              }
            },

            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'perfil',

                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.azulEscuro,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Meu perfil',
                      ),
                    ],
                  ),
                ),

                const PopupMenuItem<String>(
                  value: 'notificacoes',

                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: AppColors.azulEscuro,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Notificações',
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ============================================================
      // CORPO
      // ============================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ======================================================
            // SAUDAÇÃO
            // ======================================================

            Text(
              'Olá, paciente!',
              style: AppTextStyles.titulo,
            ),

            const SizedBox(height: 8),

            Text(
              'Confira suas informações de saúde.',
              style: AppTextStyles.texto,
            ),

            const SizedBox(height: 30),

            // ======================================================
            // PRÓXIMA CONSULTA
            // ======================================================

            _CardHome(
              icone: Icons.calendar_month_outlined,
              titulo: 'Minha próxima consulta',
              descricao:
                  'Confira a data e o horário da sua consulta.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ConsultasScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // ======================================================
            // MÉDICO RESPONSÁVEL
            // ======================================================

            _CardHome(
              icone: Icons.medical_services_outlined,
              titulo: 'Meu médico responsável',
              descricao:
                  'Consulte o profissional responsável pelo seu atendimento.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Informações do profissional serão implementadas.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // ======================================================
            // UBS
            // ======================================================

            _CardHome(
              icone: Icons.location_on_outlined,
              titulo: 'Minha UBS',
              descricao:
                  'Confira sua unidade básica de saúde.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Informações da UBS serão implementadas.',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // ======================================================
            // MEDICAMENTOS
            // ======================================================

            _CardHome(
              icone: Icons.medication_outlined,
              titulo: 'Meus medicamentos',
              descricao:
                  'Confira seus medicamentos e receitas.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MedicamentosScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ======================================================
            // ACESSO RÁPIDO
            // ======================================================

            Text(
              'Acesso rápido',
              style: AppTextStyles.subtitulo,
            ),

            const SizedBox(height: 15),

            // ======================================================
            // PRIMEIRA LINHA
            // ======================================================

            Row(
              children: [
                // --------------------------------------------------
                // VACINAÇÃO
                // --------------------------------------------------

                Expanded(
                  child: _BotaoAtalho(
                    icone: Icons.vaccines_outlined,
                    titulo: 'Vacinação',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const VacinacaoScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // --------------------------------------------------
                // HISTÓRICO
                // --------------------------------------------------

                Expanded(
                  child: _BotaoAtalho(
                    icone: Icons.history,
                    titulo: 'Histórico',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HistoricoScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======================================================
            // SEGUNDA LINHA
            // ======================================================

            Row(
              children: [
                // --------------------------------------------------
                // ENCAMINHAMENTOS
                // --------------------------------------------------

                Expanded(
                  child: _BotaoAtalho(
                    icone: Icons.assignment_outlined,
                    titulo: 'Encaminhamentos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EncaminhamentosScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // --------------------------------------------------
                // NOTIFICAÇÕES
                // --------------------------------------------------

                Expanded(
                  child: _BotaoAtalho(
                    icone: Icons.notifications_none,
                    titulo: 'Notificações',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificacoesScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// CARD PRINCIPAL DA HOME
// ============================================================

class _CardHome extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;

  const _CardHome({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(15),

      child: Container(
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

              blurRadius: 5,

              offset: const Offset(
                0,
                3,
              ),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: AppColors.azulClaro,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icone,
                color: AppColors.azulEscuro,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    titulo,
                    style: AppTextStyles.subtitulo,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    descricao,
                    style: AppTextStyles.textoPequeno,
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppColors.azulMedio,
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// BOTÃO DE ACESSO RÁPIDO
// ============================================================

class _BotaoAtalho extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final VoidCallback onTap;

  const _BotaoAtalho({
    required this.icone,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        height: 105,

        decoration: BoxDecoration(
          color: AppColors.azulClaro,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icone,
              color: AppColors.azulEscuro,
              size: 32,
            ),

            const SizedBox(height: 8),

            Text(
              titulo,
              style: AppTextStyles.texto.copyWith(
                color: AppColors.azulEscuro,
                fontWeight: FontWeight.bold,
              ),

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}