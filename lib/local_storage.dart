import 'package:shared_preferences/shared_preferences.dart';
import 'amiibo.dart';
import 'dart:convert';

class LocalStorage {
  static const _favoriteKey = 'favorites';

  // Menambahkan Amiibo ke favorit
  static Future<void> addFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoriteKey) ?? [];
    
    // Menambahkan Amiibo jika belum ada
    if (!favorites.contains(amiibo.name)) {
      favorites.add(jsonEncode(amiibo.toJson()));
      await prefs.setStringList(_favoriteKey, favorites);
    }
  }

  // Menghapus Amiibo dari favorit
  static Future<void> removeFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoriteKey) ?? [];
    
    // Menghapus Amiibo dari favorit jika ada
    favorites.removeWhere((item) => jsonDecode(item)['name'] == amiibo.name);
    
    await prefs.setStringList(_favoriteKey, favorites);
  }

  // Mendapatkan daftar favorit
  static Future<List<Amiibo>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoriteKey) ?? [];
    
    // Mengonversi string favorit menjadi objek Amiibo
    return favorites
        .map((item) => Amiibo.fromJson(jsonDecode(item)))
        .toList();
  }
}
