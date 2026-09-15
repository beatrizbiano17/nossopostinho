import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String urlBase =
      'http://192.168.0.9/nosso_postinho_api';

  // Guarda o ID do usuário que está logado
  static int? usuarioIdLogado;

  // LOGIN
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

      if (resultado["sucesso"] == true) {
        usuarioIdLogado =
            int.tryParse(resultado["usuario"]["id"].toString());
      }

      return resultado;
    } else {
      throw Exception('Erro ao conectar com a API.');
    }
  }

  // CADASTRO
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

  // PERFIL
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

  // CONSULTAS
  static Future<Map<String, dynamic>> buscarConsultas() async {
    if (usuarioIdLogado == null) {
      throw Exception('Nenhum usuário está logado.');
    }

    final resposta = await http.post(
      Uri.parse('$urlBase/consultas.php'),
      body: {
        'usuario_id': usuarioIdLogado.toString(),
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Erro ao buscar as consultas.');
    }
  }
    // ENCAMINHAMENTOS
  static Future<Map<String, dynamic>> buscarEncaminhamentos() async {
    if (usuarioIdLogado == null) {
      throw Exception('Nenhum usuário está logado.');
    }

    final resposta = await http.post(
      Uri.parse('$urlBase/encaminhamentos.php'),
      body: {
        'usuario_id': usuarioIdLogado.toString(),
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Erro ao buscar os encaminhamentos.');
    }
  }
    // HISTÓRICO DE ATENDIMENTOS
  static Future<Map<String, dynamic>> buscarHistorico() async {
    if (usuarioIdLogado == null) {
      throw Exception('Nenhum usuário está logado.');
    }

    final resposta = await http.post(
      Uri.parse('$urlBase/atendimentos.php'),
      body: {
        'usuario_id': usuarioIdLogado.toString(),
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Erro ao buscar o histórico.');
    }
  }
    // VACINAÇÃO
  static Future<Map<String, dynamic>> buscarVacinacao() async {
    if (usuarioIdLogado == null) {
      throw Exception('Nenhum usuário está logado.');
    }

    final resposta = await http.post(
      Uri.parse('$urlBase/vacinacao.php'),
      body: {
        'usuario_id': usuarioIdLogado.toString(),
      },
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception(
        'Erro ao buscar os dados de vacinação.',
      );
    }
  }
  // MEDICAMENTOS
static Future<Map<String, dynamic>> buscarMedicamentos() async {
  final resposta = await http.get(
    Uri.parse('$urlBase/medicamentos.php'),
  );

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    throw Exception(
      'Erro ao buscar os medicamentos.',
    );
  }
}
// NOTIFICAÇÕES
static Future<Map<String, dynamic>> buscarNotificacoes() async {
  if (usuarioIdLogado == null) {
    throw Exception('Nenhum usuário está logado.');
  }

  final resposta = await http.post(
    Uri.parse('$urlBase/notificacoes.php'),
    body: {
      'usuario_id': usuarioIdLogado.toString(),
    },
  );

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    throw Exception(
      'Erro ao buscar as notificações.',
    );
  }
}
}