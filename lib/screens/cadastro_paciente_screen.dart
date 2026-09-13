import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({super.key});

  @override
  State<CadastroPacienteScreen> createState() =>
      _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState
    extends State<CadastroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController =
      TextEditingController();

  final TextEditingController _cpfController =
      TextEditingController();

  final TextEditingController _senhaController =
      TextEditingController();

  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();

    super.dispose();
  }

void _cadastrar() {
  if (_formKey.currentState!.validate()) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: AppTextStyles.subtitulo,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/nosso_postinho_logo.png.jpeg',
                    width: 190,
                  ),
                ),

                const SizedBox(height: 20),

                // Título
                Text(
                  'Crie sua conta',
                  style: AppTextStyles.titulo,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Preencha seus dados para utilizar o Nosso Postinho.',
                  style: AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulEscuro,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Nome
                Text(
                  'Nome completo',
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nomeController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,

                  decoration: const InputDecoration(
                    hintText: 'Digite seu nome completo',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.azulMedio,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Digite seu nome completo.';
                    }

                    if (value.trim().length < 3) {
                      return 'Digite um nome válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // CPF
                Text(
                  'CPF',
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    hintText: 'Digite seu CPF',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: AppColors.azulMedio,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Digite seu CPF.';
                    }

                    if (value.trim().length < 11) {
                      return 'Digite um CPF válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Senha
                Text(
                  'Senha',
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,

                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.azulMedio,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },

                      icon: Icon(
                        _mostrarSenha
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.azulMedio,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Digite uma senha.';
                    }

                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirmar senha
                Text(
                  'Confirmar senha',
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: !_mostrarConfirmacao,

                  decoration: InputDecoration(
                    hintText: 'Digite sua senha novamente',

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.azulMedio,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarConfirmacao =
                              !_mostrarConfirmacao;
                        });
                      },

                      icon: Icon(
                        _mostrarConfirmacao
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.azulMedio,
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Confirme sua senha.';
                    }

                    if (value != _senhaController.text) {
                      return 'As senhas não são iguais.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Botão cadastrar
                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _cadastrar,

                    child: Text(
                      'CADASTRAR',
                      style: AppTextStyles.botao,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: Text(
                    'Já tenho uma conta',
                    style: AppTextStyles.textoPequeno.copyWith(
                      color: AppColors.azulEscuro,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}