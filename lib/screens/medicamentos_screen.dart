import 'package:flutter/material.dart';
import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class MedicamentosScreen extends StatefulWidget {
  const MedicamentosScreen({super.key});

  @override
  State<MedicamentosScreen> createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  List<Map<String, dynamic>> medicamentos = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarMedicamentos();
  }

  // ============================================================
  // BUSCA OS MEDICAMENTOS NA API
  // ============================================================

  Future<void> _carregarMedicamentos() async {
    try {
      final resultado = await ApiService.buscarMedicamentos();

      if (!mounted) return;

      if (resultado['sucesso'] == true) {
        setState(() {
          medicamentos = List<Map<String, dynamic>>.from(
            resultado['medicamentos'] ?? [],
          );

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          carregando = false;
          erro = resultado['mensagem'] ??
              'Não foi possível carregar os medicamentos.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = 'Não foi possível conectar com o servidor.';
      });
    }
  }

  // ============================================================
  // FORMATA O HORÁRIO
  // 08:00:00 → 08:00
  // ============================================================

  String _formatarHorario(String? horario) {
    if (horario == null || horario.isEmpty) {
      return 'Horário não informado';
    }

    if (horario.length >= 5) {
      return horario.substring(0, 5);
    }

    return horario;
  }

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

      body: _conteudo(),
    );
  }

  // ============================================================
  // CONTEÚDO DA TELA
  // ============================================================

  Widget _conteudo() {
    // Carregando
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Erro
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
                'Não foi possível carregar os medicamentos.',
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

                  _carregarMedicamentos();
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

    // Nenhum medicamento
    if (medicamentos.isEmpty) {
      return const _SemMedicamentos();
    }

    // Lista de medicamentos
    return ListView.builder(
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
            nome: medicamento['nome']?.toString() ??
                'Medicamento não informado',

            descricao: medicamento['descricao']?.toString() ??
                'Sem descrição',

            dosagem: medicamento['dosagem']?.toString() ??
                'Dosagem não informada',

            horario: _formatarHorario(
              medicamento['horario']?.toString(),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// CARD DO MEDICAMENTO
// ============================================================

class _MedicamentoCard extends StatelessWidget {
  final String nome;
  final String descricao;
  final String dosagem;
  final String horario;

  const _MedicamentoCard({
    required this.nome,
    required this.descricao,
    required this.dosagem,
    required this.horario,
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
                      style:
                          AppTextStyles.subtitulo,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      dosagem,
                      style:
                          AppTextStyles.texto,
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

          // ==================================================
          // DESCRIÇÃO
          // ==================================================

          _InformacaoMedicamento(
            icone: Icons.info_outline,
            titulo: 'Descrição',
            valor: descricao,
          ),

          const SizedBox(height: 12),

          // ==================================================
          // HORÁRIO
          // ==================================================

          _InformacaoMedicamento(
            icone: Icons.schedule_outlined,
            titulo: 'Horário',
            valor: horario,
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