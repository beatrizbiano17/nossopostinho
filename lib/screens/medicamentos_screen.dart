import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class MedicamentosScreen extends StatelessWidget {
  const MedicamentosScreen({super.key});

  // ============================================================
  // DADOS DE TESTE
  // ============================================================

  final List<Map<String, String>> medicamentos = const [
    {
      'nome': 'Paracetamol',
      'dosagem': '500 mg',
      'uso': '1 comprimido a cada 8 horas',
      'emissao': '10/08/2026',
      'validade': '10/09/2026',
      'status': 'Válida',
    },
    {
      'nome': 'Amoxicilina',
      'dosagem': '500 mg',
      'uso': '1 cápsula a cada 8 horas',
      'emissao': '15/08/2026',
      'validade': '15/09/2026',
      'status': 'Próxima do vencimento',
    },
    {
      'nome': 'Losartana',
      'dosagem': '50 mg',
      'uso': '1 comprimido uma vez ao dia',
      'emissao': '05/07/2026',
      'validade': '05/10/2026',
      'status': 'Válida',
    },
    {
      'nome': 'Ibuprofeno',
      'dosagem': '400 mg',
      'uso': '1 comprimido a cada 8 horas',
      'emissao': '01/06/2026',
      'validade': '01/07/2026',
      'status': 'Vencida',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Medicamentos',
          style: AppTextStyles.subtitulo,
        ),
      ),

      body: medicamentos.isEmpty
          ? const _SemMedicamentos()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                30,
              ),

              itemCount: medicamentos.length,

              itemBuilder: (context, index) {
                final medicamento = medicamentos[index];

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),

                  child: _MedicamentoCard(
                    nome: medicamento['nome']!,
                    dosagem: medicamento['dosagem']!,
                    uso: medicamento['uso']!,
                    emissao: medicamento['emissao']!,
                    validade: medicamento['validade']!,
                    status: medicamento['status']!,
                  ),
                );
              },
            ),
    );
  }
}


// ============================================================
// CARD DO MEDICAMENTO
// ============================================================

class _MedicamentoCard extends StatelessWidget {
  final String nome;
  final String dosagem;
  final String uso;
  final String emissao;
  final String validade;
  final String status;

  const _MedicamentoCard({
    required this.nome,
    required this.dosagem,
    required this.uso,
    required this.emissao,
    required this.validade,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool vencido = status == 'Vencida';

    final bool proximoDoVencimento =
        status == 'Próxima do vencimento';

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.branco,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: vencido
              ? Colors.red.shade200
              : proximoDoVencimento
                  ? Colors.orange.shade200
                  : AppColors.azulClaro,
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
          // ==================================================
          // CABEÇALHO
          // ==================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

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
                  Icons.medication_outlined,
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
                      nome,
                      style: AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      dosagem,
                      style: AppTextStyles.texto,
                    ),
                  ],
                ),
              ),

              _StatusMedicamento(
                status: status,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ==================================================
          // FORMA DE USO
          // ==================================================

          _InformacaoMedicamento(
            icone: Icons.schedule_outlined,
            titulo: 'Como usar',
            valor: uso,
          ),

          const SizedBox(height: 12),

          // ==================================================
          // DATA DE EMISSÃO
          // ==================================================

          _InformacaoMedicamento(
            icone: Icons.calendar_today_outlined,
            titulo: 'Receita emitida',
            valor: emissao,
          ),

          const SizedBox(height: 12),

          // ==================================================
          // VALIDADE
          // ==================================================

          _InformacaoMedicamento(
            icone: Icons.event_available_outlined,
            titulo: 'Validade',
            valor: validade,
          ),

          // ==================================================
          // AVISO
          // ==================================================

          if (vencido || proximoDoVencimento) ...[
            const SizedBox(height: 15),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: vencido
                    ? Colors.red.shade50
                    : Colors.orange.shade50,

                borderRadius:
                    BorderRadius.circular(10),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Icon(
                    vencido
                        ? Icons.error_outline
                        : Icons.warning_amber_outlined,

                    color: vencido
                        ? Colors.red.shade700
                        : Colors.orange.shade700,

                    size: 22,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      vencido
                          ? 'A receita deste medicamento está vencida.'
                          : 'A receita deste medicamento está próxima do vencimento.',

                      style: AppTextStyles.textoPequeno.copyWith(
                        color: vencido
                            ? Colors.red.shade700
                            : Colors.orange.shade700,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


// ============================================================
// STATUS DO MEDICAMENTO
// ============================================================

class _StatusMedicamento extends StatelessWidget {
  final String status;

  const _StatusMedicamento({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool vencido = status == 'Vencida';

    final bool proximoDoVencimento =
        status == 'Próxima do vencimento';

    Color cor;

    IconData icone;

    if (vencido) {
      cor = Colors.red.shade700;
      icone = Icons.cancel_outlined;
    } else if (proximoDoVencimento) {
      cor = Colors.orange.shade700;
      icone = Icons.warning_amber_outlined;
    } else {
      cor = AppColors.azulMedio;
      icone = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.10),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icone,
            color: cor,
            size: 16,
          ),

          const SizedBox(width: 4),

          Text(
            status,
            style: AppTextStyles.textoPequeno.copyWith(
              color: cor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// INFORMAÇÃO DO MEDICAMENTO
// ============================================================

class _InformacaoMedicamento extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _InformacaoMedicamento({
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
// NENHUM MEDICAMENTO
// ============================================================

class _SemMedicamentos extends StatelessWidget {
  const _SemMedicamentos();

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
              Icons.medication_outlined,
              size: 70,
              color: AppColors.azulMedio,
            ),

            const SizedBox(height: 20),

            Text(
              'Nenhum medicamento registrado.',
              style: AppTextStyles.subtitulo,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              'Quando houver medicamentos cadastrados, eles aparecerão aqui.',
              style: AppTextStyles.texto,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}