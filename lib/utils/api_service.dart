import 'dart:convert';
import 'package:http/http.dart' as http;
import '../home/user.dart';

class ApiService {
  final String apiUrl = 'https://randomuser.me/api';

  Future<User?> fetchUser() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parseamos la respuesta JSON
        final data = jsonDecode(response.body);
        // Accedemos al primer usuario en la lista de resultados
        final userData = data['results'][0];
        return User.fromJson(userData);
      } else {
        throw Exception('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
