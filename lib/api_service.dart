import 'dart:convert';
import 'package:http/http.dart' as http;
import 'amiibo.dart';  // Pastikan Anda memiliki model Amiibo di project Anda

class ApiService {
  // URL endpoint API
  static const String _baseUrl = 'https://amiiboapi.com/api/amiibo/';

  // Fungsi untuk mengambil data Amiibo dari API
  static Future<List<Amiibo>> fetchAmiibos() async {
    try {
      // Melakukan request ke API
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Jika status code 200, parse response JSON menjadi List<Amiibo>
        final List<dynamic> data = json.decode(response.body)['amiibo'];
        return data.map((json) => Amiibo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load amiibo');
      }
    } catch (e) {
      throw Exception('Error fetching amiibo: $e');
    }
  }
}
