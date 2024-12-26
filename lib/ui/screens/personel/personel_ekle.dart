import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleep/data/models/device.dart';
import 'package:sleep/data/models/personel.dart';
import 'package:sleep/data/models/sube.dart';

/// PersonelEkle ekranı
class PersonelEkle extends StatefulWidget {
  /// PersonelEkle ekranı
  const PersonelEkle({required this.sube, this.personel, super.key});

  final Sube sube;
  final Personel? personel;

  @override
  State<PersonelEkle> createState() => _PersonelEkleState();
}

class _PersonelEkleState extends State<PersonelEkle> {
  final TextEditingController _personelAdiController = TextEditingController();
  final TextEditingController _solBileklikIdController =
      TextEditingController();
  final TextEditingController _sagBileklikIdController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.personel != null) {
      _personelAdiController.text = widget.personel!.name;
      _solBileklikIdController.text = widget.personel!.solBileklikId;
      _sagBileklikIdController.text = widget.personel!.sagBileklikId;
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
          widget.personel == null ? 'Yeni Personel' : 'Personel Düzenle',
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
              Text(
                'Personel Bilgileri',
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
                      _buildTextField(
                        controller: _personelAdiController,
                        label: 'Personel Adı',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _solBileklikIdController,
                        label: 'Sol Bileklik ID',
                        icon: Icons.watch,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _sagBileklikIdController,
                        label: 'Sağ Bileklik ID',
                        icon: Icons.watch,
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_personelAdiController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Lütfen personel adını giriniz')),
                              );
                              return;
                            }

                            final personel = Personel(
                              id: widget.personel?.id ??
                                  FirebaseDatabase.instance
                                      .ref('personeller')
                                      .push()
                                      .key ??
                                  'asd',
                              name: _personelAdiController.text,
                              subeId: widget.sube.id,
                              solBileklikId: _solBileklikIdController.text,
                              sagBileklikId: _sagBileklikIdController.text,
                            );

                            if (widget.personel != null) {
                              await FirebaseDatabase.instance
                                  .ref('personeller')
                                  .child(personel.id)
                                  .update(personel.toJson());
                            } else {
                              await FirebaseDatabase.instance
                                  .ref('personeller')
                                  .child(personel.id)
                                  .set(personel.toJson());
                            }

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
                            widget.personel != null ? 'Güncelle' : 'Ekle',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xff285d63)),
        prefixIcon: Icon(icon, color: Color(0xff285d63)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff285d63)),
        ),
      ),
    );
  }
}
