import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() =>
      _NotificacoesScreenState();
}

class _NotificacoesScreenState
    extends State<NotificacoesScreen> {

  // ============================================================
  // DADOS DE TESTE
  // ============================================================

  final List<Map<String, dynamic>> notificacoes = [
    {
      'tipo': 'consulta',
      'titulo': 'Lembrete de consulta',
      'mensagem':
          'Você possui uma consulta marcada para amanhã às 14:00.',
      'data': 'Hoje, 10:30',
      'lida': false,
    },
    {
      'tipo': 'vacina',
      'titulo': 'Campanha de vacinação',
      'mensagem':
          'A campanha de vacinação contra a gripe está acontecendo. Confira sua situação vacinal.',
      'data': 'Hoje, 08:15',
      'lida': false,
    },
    {
      'tipo': 'medicamento',
      'titulo': 'Receita próxima do vencimento',
      'mensagem':
          'A receita de Amoxicilina está próxima do vencimento.',
      'data': 'Ontem, 16:20',
      'lida': true,
    },
    {
      'tipo': 'encaminhamento',
      'titulo': 'Atualização de encaminhamento',
      'mensagem':
          'Seu encaminhamento foi atualizado. Consulte o status para mais informações.',
      'data': '23/08/2026, 14:40',
      'lida': true,
    },
  ];

  // ============================================================
  // QUANTIDADE DE NOTIFICAÇÕES NÃO LIDAS
  // ============================================================

  int get quantidadeNaoLidas {
    return notificacoes
        .where((notificacao) => notificacao['lida'] == false)
        .length;
  }

  // ============================================================
  // MARCAR TODAS COMO LIDAS
  // ============================================================

  void marcarTodasComoLidas() {
    setState(() {
      for (final notificacao in notificacoes) {
        notificacao['lida'] = true;
      }
    });
  }

  // ============================================================
  // MARCAR UMA NOTIFICAÇÃO COMO LIDA
  // ============================================================

  void marcarComoLida(int index) {
    setState(() {
      notificacoes[index]['lida'] = true;
    });
  }

  // ============================================================
  // EXCLUIR NOTIFICAÇÃO
  // ============================================================

  void excluirNotificacao(int index) {
    setState(() {
      notificacoes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Notificações',
          style: AppTextStyles.subtitulo,
        ),

        actions: [
          if (quantidadeNaoLidas > 0)
            IconButton(
              tooltip: 'Marcar todas como lidas',
              onPressed: marcarTodasComoLidas,
              icon: const Icon(
                Icons.done_all,
              ),
            ),

          const SizedBox(width: 5),
        ],
      ),

      body: Column(
        children: [

          // ======================================================
          // CABEÇALHO
          // ======================================================

          if (quantidadeNaoLidas > 0)
            Container(
              width: double.infinity,

              margin: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                5,
              ),

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: AppColors.azulClaro,

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.azulEscuro,
                    size: 25,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      quantidadeNaoLidas == 1
                          ? 'Você possui 1 notificação não lida.'
                          : 'Você possui $quantidadeNaoLidas notificações não lidas.',

                      style: AppTextStyles.texto.copyWith(
                        color: AppColors.azulEscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ======================================================
          // LISTA
          // ======================================================

          Expanded(
            child: notificacoes.isEmpty
                ? const _SemNotificacoes()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      15,
                      20,
                      30,
                    ),

                    itemCount: notificacoes.length,

                    itemBuilder: (context, index) {
                      final notificacao =
                          notificacoes[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: _NotificacaoCard(
                          tipo:
                              notificacao['tipo'],
                          titulo:
                              notificacao['titulo'],
                          mensagem:
                              notificacao['mensagem'],
                          data:
                              notificacao['data'],
                          lida:
                              notificacao['lida'],

                          onTap: () {
                            marcarComoLida(index);
                          },

                          onExcluir: () {
                            excluirNotificacao(index);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CARD DE NOTIFICAÇÃO
// ============================================================

class _NotificacaoCard extends StatelessWidget {
  final String tipo;
  final String titulo;
  final String mensagem;
  final String data;
  final bool lida;

  final VoidCallback onTap;
  final VoidCallback onExcluir;

  const _NotificacaoCard({
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.data,
    required this.lida,
    required this.onTap,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(
        '$titulo$data',
      ),

      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        onExcluir();
      },

      background: Container(
        alignment: Alignment.centerRight,

        padding: const EdgeInsets.only(
          right: 25,
        ),

        decoration: BoxDecoration(
          color: Colors.red.shade400,

          borderRadius:
              BorderRadius.circular(15),
        ),

        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(15),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: lida
                ? AppColors.branco
                : AppColors.azulClaro,

            borderRadius:
                BorderRadius.circular(15),

            border: Border.all(
              color: lida
                  ? AppColors.azulClaro
                  : AppColors.azulMedio,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.04,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // ÍCONE
              // ==================================================

              _IconeNotificacao(
                tipo: tipo,
              ),

              const SizedBox(width: 13),

              // ==================================================
              // TEXTO
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titulo,
                            style: AppTextStyles.texto.copyWith(
                              color:
                                  AppColors.azulEscuro,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        if (!lida)
                          Container(
                            width: 9,
                            height: 9,

                            decoration:
                                const BoxDecoration(
                              color:
                                  AppColors.azulMedio,
                              shape:
                                  BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      mensagem,
                      style:
                          AppTextStyles.textoPequeno,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      data,
                      style: AppTextStyles.textoPequeno.copyWith(
                        color:
                            AppColors.azulMedio,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// ÍCONE DA NOTIFICAÇÃO
// ============================================================

class _IconeNotificacao extends StatelessWidget {
  final String tipo;

  const _IconeNotificacao({
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    IconData icone;

    switch (tipo) {
      case 'consulta':
        icone = Icons.calendar_month_outlined;
        break;

      case 'vacina':
        icone = Icons.vaccines_outlined;
        break;

      case 'medicamento':
        icone = Icons.medication_outlined;
        break;

      case 'encaminhamento':
        icone = Icons.assignment_outlined;
        break;

      default:
        icone = Icons.notifications_none;
    }

    return Container(
      width: 48,
      height: 48,

      decoration: BoxDecoration(
        color: AppColors.branco,

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Icon(
        icone,
        color: AppColors.azulEscuro,
        size: 27,
      ),
    );
  }
}


// ============================================================
// SEM NOTIFICAÇÕES
// ============================================================

class _SemNotificacoes extends StatelessWidget {
  const _SemNotificacoes();

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
              Icons.notifications_none,
              size: 75,
              color: AppColors.azulMedio,
            ),

            const SizedBox(height: 20),

            Text(
              'Nenhuma notificação',
              style: AppTextStyles.subtitulo,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              'Quando houver novos avisos, eles aparecerão aqui.',
              style: AppTextStyles.texto,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}