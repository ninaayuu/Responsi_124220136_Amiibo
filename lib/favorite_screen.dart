import 'package:flutter/material.dart';
import 'amiibo.dart';
import 'local_storage.dart';
import 'amiibo_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isLoading = true;
  List<Amiibo> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesData = await LocalStorage.getFavorites();
    setState(() {
      favorites = favoritesData;
      isLoading = false;
    });
  }

  void _removeFavorite(Amiibo amiibo) async {
    await LocalStorage.removeFavorite(amiibo);
    setState(() {
      favorites.remove(amiibo); // Menghapus dari daftar favorit
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text('Favorites', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final amiibo = favorites[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.network(amiibo.image, width: 50, height: 50),
                    title: Text(amiibo.name),
                    subtitle: Text(amiibo.gameSeries),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.pink),
                      onPressed: () {
                        _removeFavorite(amiibo); // Menghapus favorit dari daftar
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AmiiboDetailScreen(amiibo: amiibo),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
