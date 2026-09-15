import 'package:flutter/material.dart';

import '../services/apiservice.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  List<Map<String, dynamic>> notificacoes = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarNotificacoes();
  }

  Future<void> _carregarNotificacoes() async {
    try {
      final resultado = await ApiService.buscarNotificacoes();

      if (!mounted) return;

      if (resultado['sucesso'] == true) {
        setState(() {
          notificacoes = List<Map<String, dynamic>>.from(
            resultado['notificacoes'] ?? [],
          );

          carregando = false;
          erro = null;
        });
      } else {
        setState(() {
          carregando = false;
          erro = resultado['mensagem'] ??
              'Não foi possível carregar as notificações.';
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

  int get quantidadeNaoLidas {
    return notificacoes.where((notificacao) {
      return notificacao['lida'].toString() == '0';
    }).length;
  }

  void marcarTodasComoLidas() {
    setState(() {
      for (final notificacao in notificacoes) {
        notificacao['lida'] = 1;
      }
    });
  }

  void marcarComoLida(int index) {
    setState(() {
      notificacoes[index]['lida'] = 1;
    });
  }

  void excluirNotificacao(int index) {
    setState(() {
      notificacoes.removeAt(index);
    });
  }

  String _formatarData(String? data) {
    if (data == null || data.isEmpty) {
      return '';
    }

    try {
      final dataHora = DateTime.parse(data);

      final dia = dataHora.day.toString().padLeft(2, '0');
      final mes = dataHora.month.toString().padLeft(2, '0');
      final ano = dataHora.year.toString();

      final hora = dataHora.hour.toString().padLeft(2, '0');
      final minuto = dataHora.minute.toString().padLeft(2, '0');

      return '$dia/$mes/$ano, $hora:$minuto';
    } catch (e) {
      return data;
    }
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
          if (!carregando && quantidadeNaoLidas > 0)
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
      body: _conteudo(),
    );
  }

  Widget _conteudo() {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                'Não foi possível carregar as notificações.',
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

                  _carregarNotificacoes();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (notificacoes.isEmpty) {
      return const _SemNotificacoes();
    }

    return Column(
      children: [
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
              borderRadius: BorderRadius.circular(12),
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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              30,
            ),
            itemCount: notificacoes.length,
            itemBuilder: (context, index) {
              final notificacao = notificacoes[index];

              final tipo =
                  notificacao['tipo']?.toString() ?? 'geral';

              final titulo =
                  notificacao['titulo']?.toString() ??
                      'Notificação';

              final mensagem =
                  notificacao['mensagem']?.toString() ??
                      '';

              final data = _formatarData(
                notificacao['data_envio']?.toString(),
              );

              final lida =
                  notificacao['lida'].toString() == '1';

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _NotificacaoCard(
                  tipo: tipo,
                  titulo: titulo,
                  mensagem: mensagem,
                  data: data,
                  lida: lida,
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
    );
  }
}

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
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lida
                ? AppColors.branco
                : AppColors.azulClaro,
            borderRadius: BorderRadius.circular(15),
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
              _IconeNotificacao(
                tipo: tipo,
              ),
              const SizedBox(width: 13),
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
                            style:
                                AppTextStyles.texto.copyWith(
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
                              shape: BoxShape.circle,
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
                      style:
                          AppTextStyles.textoPequeno.copyWith(
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

      case 'campanha':
        icone = Icons.campaign_outlined;
        break;

      default:
        icone = Icons.notifications_none;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icone,
        color: AppColors.azulEscuro,
        size: 27,
      ),
    );
  }
}

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