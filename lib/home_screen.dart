import 'package:flutter/material.dart';
import 'amiibo.dart';
import 'amiibo_detail_screen.dart';
import 'favorite_screen.dart'; // Pastikan Anda sudah memiliki FavoriteScreen
import 'local_storage.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Amiibo> amiibos = [];
  Set<String> favoriteIds = Set<String>();  // Menyimpan ID favorit
  int _selectedIndex = 0;  // Menyimpan index yang dipilih di BottomNavigationBar

  @override
  void initState() {
    super.initState();
    fetchAmiibos();
    _loadFavorites(); // Memuat favorite dari local storage
  }

  Future<void> fetchAmiibos() async {
    final data = await ApiService.fetchAmiibos();
    setState(() {
      amiibos = data;
      isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final favorites = await LocalStorage.getFavorites();
    setState(() {
      favoriteIds = Set<String>.from(favorites.map((amiibo) => amiibo.name));
    });
  }

  void _addFavorite(Amiibo amiibo) async {
    if (!favoriteIds.contains(amiibo.name)) {
      await LocalStorage.addFavorite(amiibo);
      setState(() {
        favoriteIds.add(amiibo.name); // Menambah ke favorit
      });
    } else {
      await LocalStorage.removeFavorite(amiibo);
      setState(() {
        favoriteIds.remove(amiibo.name); // Menghapus dari favorit
      });
    }
  }

  // Fungsi untuk mengubah halaman berdasarkan index BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoriteScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text('Nintendo Amiibo', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: amiibos.length,
              itemBuilder: (context, index) {
                final amiibo = amiibos[index];
                bool isFavorite = favoriteIds.contains(amiibo.name);
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
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.pink : null, // Warna pink jika sudah favorit
                      ),
                      onPressed: () {
                        _addFavorite(amiibo);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink, // Setel warna ikon yang dipilih menjadi pink
        unselectedItemColor: Colors.pink, // Setel warna ikon yang tidak dipilih menjadi pink
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
