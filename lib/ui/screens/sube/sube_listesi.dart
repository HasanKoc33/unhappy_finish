import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:sleep/core/providers/sube_provider.dart';import 'package:sleep/ui/screens/personel/personel_listesi.dart';import 'package:sleep/ui/screens/sube/sube_ekle.dart';import 'package:sleep/utils/extensions.dart';/// SubeListesi ekranıclass SubeListesi extends StatefulWidget {  /// SubeListesi ekranı  const SubeListesi({super.key});  @override  State<SubeListesi> createState() => _SubeListesiState();}class _SubeListesiState extends State<SubeListesi> {  @override  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(        title: Text('Şube Listesi'),        actions: [          IconButton(            icon: Icon(Icons.add),            onPressed: () {              Navigator.push(                context,                MaterialPageRoute(                  builder: (context) => SubeEkle(),                ),              );            },          ),        ],      ),      body: Container(          width: context.width,          height: context.height,          child: Builder(builder: (context) {            final subeler = context.watch<SubeProvider>().subeler;            return ListView.builder(              itemCount: subeler.length,              itemBuilder: (context, index) {                final sube = subeler[index];                return Padding(                  padding: const EdgeInsets.all(8.0),                  child: Container(                    decoration: BoxDecoration(                      borderRadius: BorderRadius.circular(8),                      color: Colors.grey.shade200,                    ),                    child: ListTile(                      title: Text(sube.name),                      onTap: () {                        Navigator.push(                          context,                          MaterialPageRoute(                            builder: (context) => PersonelListesi(sube: sube),                          ),                        );                      },                      trailing: IconButton(                          onPressed: () {                            Navigator.push(                              context,                              MaterialPageRoute(                                builder: (context) => SubeEkle(sube: sube),                              ),                            );                          },                          icon: Icon(Icons.delete)),                    )),                );              },            );          })),    );  }}