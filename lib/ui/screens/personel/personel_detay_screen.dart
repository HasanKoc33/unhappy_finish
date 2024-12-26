import 'package:flutter/material.dart';
import 'package:sleep/data/models/personel.dart';
import 'package:sleep/data/models/seans.dart';
import 'package:sleep/ui/screens/view_screen/view_screen.dart';
import 'package:sleep/utils/extensions.dart';

/// PersonelDetayScreen ekranı
class PersonelDetayScreen extends StatefulWidget {
  /// PersonelDetayScreen ekranı
  const PersonelDetayScreen({required this.personel, super.key});

  final Personel personel;

  @override
  State<PersonelDetayScreen> createState() => _PersonelDetayScreenState();
}

class _PersonelDetayScreenState extends State<PersonelDetayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Personel Detayları',
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
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xff285d63),
                    child: Text(
                      widget.personel.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.personel.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff285d63),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactDeviceInfo(
                                'Sol Bileklik',
                                widget.personel.solBileklikId,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactDeviceInfo(
                                'Sağ Bileklik',
                                widget.personel.sagBileklikId,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seans Geçmişi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff285d63),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildSeansListesi(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDeviceInfo(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xff285d63).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Color(0xff285d63),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSeansListesi() {
    final seansCount = widget.personel.solBileklik?.seanslar.length ?? 0;

    if (seansCount == 0) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: Color(0xff285d63).withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'Henüz seans kaydı bulunmuyor',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: seansCount,
      itemBuilder: (context, index) {
        var solBileklik;
        var sagBileklik;

        if ((widget.personel.sagBileklik?.seanslar.length ?? 0) > index) {
          sagBileklik = widget.personel.sagBileklik?.seanslar[index];
        }
        if ((widget.personel.solBileklik?.seanslar.length ?? 0) > index) {
          solBileklik = widget.personel.solBileklik?.seanslar[index];
        }

        final seans = (solBileklik ?? sagBileklik) as Seans;

        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Color(0xff285d63).withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Color(0xff285d63),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'Seans ${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff285d63),
              ),
            ),
            subtitle: Text(
              seans.startTime.formattedDateTime,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.play_circle_outline,
                color: Color(0xff285d63),
                size: 32,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewScreen(
                      sagBileklik: sagBileklik,
                      solBileklik: solBileklik,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
