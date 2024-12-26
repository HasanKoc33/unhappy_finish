import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sleep/core/providers/porsonel_provider.dart';
import 'package:sleep/core/providers/sube_provider.dart';
import 'package:sleep/data/models/data.dart';
import 'package:sleep/data/services/tflate_service.dart';
import 'package:sleep/ui/screens/sube/sube_listesi.dart';
import 'package:sleep/ui/screens/view_screen/view_screen.dart';
import 'package:sleep/utils/extensions.dart';
import 'home_screen_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Sleep Monitor',
          style: TextStyle(
            color: Color(0xff285d63),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Color(0xff285d63)),
            onPressed: showHomeMenu,
          ),
        ],
      ),
      body: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      context,
                      title: 'Şube',
                      icon: Icons.business,
                      valueBuilder: (context) =>
                          '${context.watch<SubeProvider>().subeler.length}',
                      gradient: [Color(0xff285d63), Color(0xff488b8f)],
                      onTap: () => setState(() => pageIndex = 1),
                    ),
                    _buildStatCard(
                      context,
                      title: 'Personel',
                      icon: Icons.people,
                      valueBuilder: (context) =>
                          '${context.watch<PersonelProvider>().personeller.length}',
                      gradient: [Color(0xff488b8f), Color(0xff285d63)],
                      onTap: () async {
                        String content = await rootBundle
                            .loadString('assets/models/test.txt');
                        final list = content.split('\n');
                        final datas = list
                            .map((e) => Data.fromJson(
                                {DateTime.now().toIso8601String(): e}))
                            .toList();
                        final response =
                            await TfliteService.instance.run(datas);
                        print('Hatalı Hareket Sayısı: ${response}');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Devam Eden Seanslar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff285d63),
                  ),
                ),
              ),
              Consumer<PersonelProvider>(
                builder: (context, provider, child) {
                  final personeller = provider.personeller
                      .where(
                          (element) => element.sagBileklik?.continuing != null)
                      .toList();
                  if (personeller.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xff285d63).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.nightlight_round,
                                  size: 48,
                                  color: Color(0xff285d63),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Aktif Seans Yok',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff285d63),
                                ),
                              ),
                              SizedBox(height: 8),
                            
                              Text(
                                'Şu anda devam eden bir masaj seansı bulunmuyor.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: personeller.length,
                    itemBuilder: (context, index) {
                      final personel = personeller[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewScreen(
                                  sagBileklik:
                                      personel.sagBileklik!.continuing!,
                                  solBileklik:
                                      personel.solBileklik!.continuing!,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Color(0xff285d63),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            '${personel.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Başlangıç: ${personel.sagBileklik?.continuing?.startTime.formattedDateTime}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        SubeListesi(),
      ][pageIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xff285d63),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare),
              label: 'Şubeler',
            ),
          ],
          currentIndex: pageIndex,
          onTap: (index) => setState(() => pageIndex = index),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String Function(BuildContext) valueBuilder,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width * 0.4,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(height: 12),
            Text(
              valueBuilder(context),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
