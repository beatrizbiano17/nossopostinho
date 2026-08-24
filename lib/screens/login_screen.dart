import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _mostrarSenha = false;

  @override
  void dispose() {
    _cpfController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login validado!'),
        ),
      );
    }
  }

  void _cadastrar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tela de cadastro será implementada em breve.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 40,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/nosso_postinho_logo.png.jpeg',
                    width: 220,
                  ),
                ),

                const SizedBox(height: 35),

                // Título
                Text(
                  'Bem-vindo ao Nosso Postinho!',
                  style: AppTextStyles.titulo,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  'Entre para acessar seus serviços de saúde.',
                  style: AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulEscuro,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                // CPF
                Text(
                  'CPF',
                  style: AppTextStyles.subtitulo,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.texto,

                  decoration: const InputDecoration(
                    hintText: 'Digite seu CPF',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.azulMedio,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Digite seu CPF.';
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
                  style: AppTextStyles.texto,

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
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha.';
                    }

                    if (value.length < 6) {
                      return 'A senha deve possuir pelo menos 6 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Recuperação de senha será implementada posteriormente.',
                          ),
                        ),
                      );
                    },

                    child: Text(
                      'Esqueci minha senha',
                      style: AppTextStyles.textoPequeno.copyWith(
                        color: AppColors.azulEscuro,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Botão entrar
                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _entrar,

                    child: Text(
                      'ENTRAR',
                      style: AppTextStyles.botao,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Divisor
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: AppColors.azulClaro,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      child: Text(
                        'ou',
                        style: AppTextStyles.textoPequeno.copyWith(
                          color: AppColors.azulEscuro,
                        ),
                      ),
                    ),

                    const Expanded(
                      child: Divider(
                        color: AppColors.azulClaro,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Cadastro
                SizedBox(
                  height: 52,

                  child: OutlinedButton(
                    onPressed: _cadastrar,

                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.azulEscuro,

                      side: const BorderSide(
                        color: AppColors.azulMedio,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: Text(
                      'CRIAR UMA CONTA',
                      style: AppTextStyles.subtitulo.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  'Nosso Postinho',
                  style: AppTextStyles.textoPequeno.copyWith(
                    color: AppColors.azulMedio,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}