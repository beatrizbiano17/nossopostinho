import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        title: Text(
          'Meu perfil',
          style: AppTextStyles.subtitulo,
        ),
      ),

      // ============================================================
      // CORPO
      // ============================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          25,
          20,
          30,
        ),

        child: Column(
          children: [
            // ======================================================
            // FOTO / ÍCONE DO PACIENTE
            // ======================================================

            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color: AppColors.azulClaro,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.person_outline,
                color: AppColors.azulEscuro,
                size: 58,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Maria da Silva',
              style: AppTextStyles.titulo,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            Text(
              'Paciente',
              style: AppTextStyles.texto.copyWith(
                color: AppColors.azulMedio,
              ),
            ),

            const SizedBox(height: 30),

            // ======================================================
            // DADOS PESSOAIS
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dados pessoais',
                style: AppTextStyles.subtitulo,
              ),
            ),

            const SizedBox(height: 15),

            _InformacaoPerfil(
              icone: Icons.badge_outlined,
              titulo: 'CPF',
              valor: '000.000.000-00',
            ),

            const SizedBox(height: 12),

            _InformacaoPerfil(
              icone: Icons.cake_outlined,
              titulo: 'Data de nascimento',
              valor: '01/01/2000',
            ),

            const SizedBox(height: 12),

            _InformacaoPerfil(
              icone: Icons.phone_outlined,
              titulo: 'Telefone',
              valor: '(47) 99999-9999',
            ),

            const SizedBox(height: 12),

            _InformacaoPerfil(
              icone: Icons.email_outlined,
              titulo: 'E-mail',
              valor: 'maria@email.com',
            ),

            const SizedBox(height: 30),

            // ======================================================
            // INFORMAÇÕES DE SAÚDE
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Informações de atendimento',
                style: AppTextStyles.subtitulo,
              ),
            ),

            const SizedBox(height: 15),

            _InformacaoPerfil(
              icone: Icons.local_hospital_outlined,
              titulo: 'UBS de referência',
              valor: 'UBS Central',
            ),

            const SizedBox(height: 30),

            // ======================================================
            // BOTÃO EDITAR PERFIL
            // ======================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Edição de perfil será implementada posteriormente.',
                      ),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.edit_outlined,
                ),

                label: const Text(
                  'Editar perfil',
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // BOTÃO SAIR
            // ======================================================

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: () {
                  _mostrarDialogoSair(context);
                },

                icon: const Icon(
                  Icons.logout,
                  color: AppColors.azulEscuro,
                ),

                label: Text(
                  'Sair da conta',
                  style: AppTextStyles.texto.copyWith(
                    color: AppColors.azulEscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  side: const BorderSide(
                    color: AppColors.azulMedio,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIÁLOGO DE SAÍDA
  // ============================================================

  void _mostrarDialogoSair(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            'Sair da conta',
            style: AppTextStyles.subtitulo,
          ),

          content: Text(
            'Tem certeza de que deseja sair da sua conta?',
            style: AppTextStyles.texto,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(
                'Cancelar',
                style: AppTextStyles.texto.copyWith(
                  color: AppColors.azulEscuro,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'A função de logout será implementada posteriormente.',
                    ),
                  ),
                );
              },

              child: const Text(
                'Sair',
              ),
            ),
          ],
        );
      },
    );
  }
}


// ============================================================
// INFORMAÇÃO DO PERFIL
// ============================================================

class _InformacaoPerfil extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoPerfil({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppColors.branco,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: AppColors.azulClaro,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),

            blurRadius: 5,

            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: AppColors.azulClaro,

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icone,
              color: AppColors.azulEscuro,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  titulo,
                  style: AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulMedio,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  valor,
                  style: AppTextStyles.texto.copyWith(
                    color: AppColors.azulEscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}