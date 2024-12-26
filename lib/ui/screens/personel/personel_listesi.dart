import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep/core/providers/porsonel_provider.dart';
import 'package:sleep/data/models/sube.dart';
import 'package:sleep/ui/screens/personel/personel_ekle.dart';
import 'package:sleep/ui/screens/personel/personel_detay_screen.dart';
import 'package:sleep/utils/extensions.dart';

/// PersonelListesi ekranı
class PersonelListesi extends StatefulWidget {
  /// PersonelListesi ekranı
  const PersonelListesi({required this.sube, super.key});

  final Sube sube;
  @override
  State<PersonelListesi> createState() => _PersonelListesiState();
}

class _PersonelListesiState extends State<PersonelListesi> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Personel Listesi',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Personel Ara...',
                prefixIcon: Icon(Icons.search, color: Color(0xff285d63)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final personeller = context
                    .watch<PersonelProvider>()
                    .getPersonelBySube(widget.sube.id)
                    .where((personel) => personel.name
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))
                    .toList();

                if (personeller.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Color(0xff285d63).withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Personel Bulunamadı',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: personeller.length,
                  itemBuilder: (context, index) {
                    final personel = personeller[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xff285d63),
                          child: Text(
                            personel.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          personel.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.watch,
                                    size: 16, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Sol: ${personel.solBileklikId}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.watch,
                                    size: 16, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Sağ: ${personel.sagBileklikId}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility,
                                  color: Color(0xff285d63)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PersonelDetayScreen(personel: personel),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xff285d63)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonelEkle(
                                      sube: widget.sube,
                                      personel: personel,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonelEkle(sube: widget.sube),
            ),
          );
        },
        backgroundColor: Color(0xff285d63),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
