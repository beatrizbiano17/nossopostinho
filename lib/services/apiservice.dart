import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String urlBase =
      'http://172.16.1.21/nosso_postinho_api';

  // Guarda o ID do usuário que está logado
  static int? usuarioIdLogado;

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<Map<String, dynamic>> fazerLogin(
    String cpf,
    String senha,
  ) async {
    final resposta = await http.post(
      Uri.parse('$urlBase/login.php'),
      body: {
        'cpf': cpf,
        'senha': senha,
      },
    );

    if (resposta.statusCode == 200) {
      final resultado = jsonDecode(resposta.body);

      // Se o login deu certo, guarda o ID do usuário
      if (resultado["sucesso"] == true) {
        usuarioIdLogado = resultado["usuario"]["id"];
      }

      return resultado;
    } else {
      throw Exception('Erro ao conectar com a API.');
    }
  }

  // ============================================================
  // CADASTRO
  // ============================================================

  static Future<Map<String, dynamic>> fazerCadastro({
    required String cpf,
    required String senha,
    required String nome,
    required String dataNascimento,
    String? telefone,
    String? email,
  }) async {
    final resposta = await http.post(
      Uri.parse('$urlBase/cadastro.php'),
      body: {
        'cpf': cpf,
        'senha': senha,
        'nome': nome,
        'data_nascimento': dataNascimento,
        'telefone': telefone ?? '',
        'email': email ?? '',
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Erro ao conectar com a API.');
    }
  }

  // ============================================================
  // PERFIL
  // ============================================================

  static Future<Map<String, dynamic>> buscarPerfil() async {
    if (usuarioIdLogado == null) {
      throw Exception('Nenhum usuário está logado.');
    }

    final resposta = await http.post(
      Uri.parse('$urlBase/perfil.php'),
      body: {
        'usuario_id': usuarioIdLogado.toString(),
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Erro ao buscar os dados do perfil.');
    }
  }
}