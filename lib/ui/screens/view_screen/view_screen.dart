import 'package:flutter/material.dart';
import 'package:sleep/core/constants/app_assets.dart';
import 'package:sleep/data/models/seans.dart';
import 'package:sleep/data/services/tflate_service.dart';
import 'package:sleep/ui/screens/view_screen/view_screen_mixin.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:sleep/utils/extensions.dart';

/// ViewScreen ekranı
class ViewScreen extends StatefulWidget {
  /// ViewScreen ekranı
  ViewScreen({required this.sagBileklik, required this.solBileklik, super.key});

  Seans? sagBileklik;
  Seans? solBileklik;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> with ViewScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Seans Görüntüleme',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Cube(
                    onSceneCreated: sahne,
                    interactive: true,
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.rotate_left,
                                  color: Color(0xff285d63)),
                              onPressed: () => humanFrontRotation(),
                              tooltip: 'Önden Görünüm',
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            IconButton(
                              icon: Icon(Icons.rotate_right,
                                  color: Color(0xff285d63)),
                              onPressed: () => humanBackRotation(),
                              tooltip: 'Arkadan Görünüm',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Color(0xff285d63),
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.solBileklik?.startTime.formattedDateTime ??
                                  'Tarih yok',
                              style: TextStyle(
                                color: Color(0xff285d63),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  _buildSectionTitle('İlerleme Durumu'),
                  SizedBox(height: 8),
                  _buildProgressCard(
                    'Sol Bileklik',
                    solBileklikProgres,
                    Color(0xff285d63),
                  ),
                  SizedBox(height: 12),
                  _buildProgressCard(
                    'Sağ Bileklik',
                    sagBileklikProgres,
                    Color(0xff488b8f),
                  ),
                  SizedBox(height: 24),
                  _buildSectionTitle('İstenmeyen Hareketler'),
                  SizedBox(height: 8),
                  _buildUnwantedMovementsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xff285d63),
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    ValueNotifier<double> progress,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff285d63),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: progress,
                  builder: (context, double value, child) {
                    return Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, double value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnwantedMovementsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUnwantedMovementRow(
              'Sol Bileklik',
              widget.solBileklik?.datas != null
                  ? TfliteService.instance.run(widget.solBileklik!.datas)
                  : Future.value(0),
            ),
            Divider(height: 24),
            _buildUnwantedMovementRow(
              'Sağ Bileklik',
              widget.sagBileklik?.datas != null
                  ? TfliteService.instance.run(widget.sagBileklik!.datas)
                  : Future.value(0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnwantedMovementRow(String title, Future<dynamic> future) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff285d63),
          ),
        ),
        FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff285d63)),
                ),
              );
            }
            if (snapshot.hasError) {
              return Icon(Icons.error, color: Colors.red);
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: snapshot.data == 0 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                snapshot.data.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
