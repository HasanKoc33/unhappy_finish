import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleep/data/models/sube.dart';
import 'package:sleep/utils/extensions.dart';

/// SubeEkle ekranı
class SubeEkle extends StatefulWidget {
  /// SubeEkle ekranı
  const SubeEkle({this.sube, super.key});
  final Sube? sube;
  @override
  State<SubeEkle> createState() => _SubeEkleState();
}

class _SubeEkleState extends State<SubeEkle> {
  final TextEditingController _subeAdiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sube != null) {
      _subeAdiController.text = widget.sube!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.sube == null ? 'Yeni Şube' : 'Şube Düzenle',
          style: TextStyle(
            color: Color(0xff285d63),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff285d63)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Şube Bilgileri',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff285d63),
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _subeAdiController,
                        decoration: InputDecoration(
                          labelText: 'Şube Adı',
                          labelStyle: TextStyle(color: Color(0xff285d63)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xff285d63)),
                          ),
                          prefixIcon:
                              Icon(Icons.business, color: Color(0xff285d63)),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_subeAdiController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Lütfen şube adını giriniz')),
                              );
                              return;
                            }

                            final sube = Sube(
                              id: widget.sube?.id ??
                                  FirebaseDatabase.instance
                                      .ref('subeler')
                                      .push()
                                      .key ??
                                  'asd',
                              name: _subeAdiController.text,
                              yetkiliKullanicilar:
                                  widget.sube?.yetkiliKullanicilar ?? [],
                            );

                            await FirebaseDatabase.instance
                                .ref('subeler')
                                .child(sube.id)
                                .set(sube.toJson());

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff285d63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.sube == null ? 'Ekle' : 'Güncelle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
