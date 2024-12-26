import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep/core/providers/sube_provider.dart';
import 'package:sleep/core/providers/porsonel_provider.dart';
import 'package:sleep/ui/screens/sube/sube_ekle.dart';
import 'package:sleep/ui/screens/personel/personel_listesi.dart';
import 'package:sleep/utils/extensions.dart';

class SubeListesi extends StatefulWidget {
  const SubeListesi({super.key});

  @override
  State<SubeListesi> createState() => _SubeListesiState();
}

class _SubeListesiState extends State<SubeListesi> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<SubeProvider>(
        builder: (context, provider, child) {
          final subeler = provider.subeler.where((sube) {
            return sube.name.toLowerCase().contains(_searchText.toLowerCase());
          }).toList();

          if (provider.subeler.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: Color(0xff285d63).withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz şube bulunmuyor',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (subeler.isEmpty) {
            return CustomScrollView(
              slivers: [
                _buildSearchAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Color(0xff285d63).withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Arama sonucu bulunamadı',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return CustomScrollView(
            slivers: [
              _buildSearchAppBar(),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final sube = subeler[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PersonelListesi(sube: sube),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xff285d63),
                                  radius: 25,
                                  child: Text(
                                    sube.name.substring(0, 1).toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sube.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xff285d63),
                                        ),
                                      ),
                                      Consumer<PersonelProvider>(
                                        builder: (context, provider, child) {
                                          final personelCount = provider
                                              .getPersonelBySube(sube.id)
                                              .length;
                                          return Text(
                                            'Personel Sayısı: $personelCount',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Color(0xff285d63)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SubeEkle(sube: sube),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: subeler.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubeEkle(),
            ),
          );
        },
        backgroundColor: Color(0xff285d63),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  SliverAppBar _buildSearchAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      title: Text(
        'Şubeler',
        style: TextStyle(
          color: Color(0xff285d63),
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Şube Ara...',
              prefixIcon: Icon(Icons.search, color: Color(0xff285d63)),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
