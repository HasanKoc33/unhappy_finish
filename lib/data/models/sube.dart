class Sube {
  String id;
  String name;
  List<String> yetkiliKullanicilar;
  List<String> personeller;

  Sube({
    required this.id,
    required this.name,
    required this.yetkiliKullanicilar,
    this.personeller = const [],
  });
  factory Sube.fromJson(Map<String, dynamic> json) {
    return Sube(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      yetkiliKullanicilar: json['yetkiliKullanicilar'] != null
          ? List<String>.from(json['yetkiliKullanicilar'])
          : [],
      personeller: json['personeller'] != null
          ? List<String>.from(json['personeller'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'yetkiliKullanicilar': yetkiliKullanicilar,
      'personeller': personeller,
    };
  }
}
