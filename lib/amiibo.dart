class Amiibo {
  final String name;
  final String gameSeries;
  final String image;
  final String type;
  final String head;
  final String tail;

  Amiibo({
    required this.name,
    required this.gameSeries,
    required this.image,
    required this.type,
    required this.head,
    required this.tail,
  });

  // Konversi dari JSON ke objek Amiibo
  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      name: json['name'],
      gameSeries: json['gameSeries'],
      image: json['image'],
      type: json['type'],
      head: json['head'],
      tail: json['tail'],
    );
  }

  // Konversi dari objek Amiibo ke JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gameSeries': gameSeries,
      'image': image,
      'type': type,
      'head': head,
      'tail': tail,
    };
  }
}
