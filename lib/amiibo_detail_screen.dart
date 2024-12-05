import 'package:flutter/material.dart';
import 'amiibo.dart';
import 'local_storage.dart';

class AmiiboDetailScreen extends StatelessWidget {
  final Amiibo amiibo;

  AmiiboDetailScreen({required this.amiibo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(amiibo.name, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () async {
              await LocalStorage.addFavorite(amiibo);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${amiibo.name} added to favorites!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(amiibo.image, width: 150, height: 150, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(amiibo.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[600])),
            SizedBox(height: 8),
            Text('Game Series: ${amiibo.gameSeries}', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.pink[400])),
            SizedBox(height: 16),
            Text('Details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink[600])),
            SizedBox(height: 8),
            _buildDetailRow('Name', amiibo.name),
            _buildDetailRow('Game Series', amiibo.gameSeries),
            _buildDetailRow('Type', amiibo.type),
            _buildDetailRow('Head', amiibo.head),
            _buildDetailRow('Tail', amiibo.tail),
            _buildDetailRow('Image URL', amiibo.image),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink[600])),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16, color: Colors.pink[400]))),
        ],
      ),
    );
  }
}
