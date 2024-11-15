import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void mesaj(String mes, {Color? color}) {
  Fluttertoast.showToast(
      msg: mes,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: color ?? Colors.orange,
      timeInSecForIosWeb: 1);
}

void hataMesaji(String mes) {
  Fluttertoast.showToast(
      msg: mes,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      timeInSecForIosWeb: 1);
}

Future<void> bildiri(BuildContext context, String mes) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: Text(
        mes,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Tamam"))
      ],
    ),
    barrierDismissible: true,
  );
}



Future<void> info(BuildContext context, String title,String body) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info,color: Colors.amber,),
          Text(
            title,
            style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),

        ],
      ),
      content: Text(
        body,
        style:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text("Tamam"))
      ],
    ),
    barrierDismissible: true,
  );
}


Future<void> bildiriProgres(BuildContext context) async {
  await showCupertinoDialog(
    context: context,
    builder: (context) => const CupertinoAlertDialog(
      content:Center(child: CircularProgressIndicator()),
    ),
    barrierDismissible: false,
  );

}



Future<bool> bildiriCevap(BuildContext context, String mes,
    {bool? important}) async {
  return await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Column(
            children: [
              important != null && important
                  ? const Icon(
                      Icons.question_mark_sharp,
                      color: Colors.red,
                    )
                  : const Center(),
              Text(
                mes,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child:  Text("Hayır")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child:  Text("Evet"))
          ],
        ),
        barrierDismissible: true,
      ) ??
      false;
}

Future<bool?> bildiriCevapNull(BuildContext context, String mes,
    {bool? important}) async {
  return await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: Column(
        children: [
          important != null && important
              ? const Icon(
                  Icons.question_mark_sharp,
                  color: Colors.red,
                )
              : const Center(),
          Text(
            mes,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child:  Text("Hayır")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child:  Text("Evet"))
      ],
    ),
    barrierDismissible: true,
  );
}

Future<String?> bildiriStringCevap(BuildContext context, String mes) async {
  return await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: SizedBox(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                mes,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              flex: 2,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: title,
                  textAlign: TextAlign.center,
                  decoration:  InputDecoration(
                    labelText: mes.toString(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("İptal")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, title.text);
              title.clear();
            },
            child: Text("Tamam"))
      ],
    ),
    barrierDismissible: true,
  );
}

Future<List<String>> bildiriOyuncular(BuildContext context, String mes,int oyuncuSayisi) async {
  List<TextEditingController> oyuncuAdi = [];
  List<String> oyuncuAdiString = [];
  for(int i=0;i<oyuncuSayisi;i++){
    oyuncuAdi.add(TextEditingController());
  }
  return await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: SizedBox(
        width: 300,
        height: (80*oyuncuSayisi).toDouble(),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                mes,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            for(int i=0;i<oyuncuSayisi;i++)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: oyuncuAdi[i],
                      textAlign: TextAlign.center,
                      decoration:  InputDecoration(
                        labelText: "Takım"+" ${i+1}",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              oyuncuAdi.forEach((element) {
                oyuncuAdiString.add(element.text.isNotEmpty?element.text.trim():"Oyuncu"+" ${oyuncuAdi.indexOf(element)+1}");
              });
              Navigator.pop(context, oyuncuAdiString);
              title.clear();
            },
            child: Text("Ayarla"))
      ],
    ),
    barrierDismissible: true,
  )??["Takım1","Takım2"];
}

Future<int> bildiriOyuncuSayisi(BuildContext context, String mes) async {
  return await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: SizedBox(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mes,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: title,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      labelText: mes.toString(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              try{
                int a = int.parse(title.text);
                Navigator.pop(context, a);
                title.clear();
              } catch (e) {
                Navigator.pop(context, 2);
                title.clear();
              }
            },
            child: Text("Ayarla"))
      ],
    ),
    barrierDismissible: true,
  )??2;
}


var title = TextEditingController();
var body = TextEditingController();
var text = TextEditingController();

void hataBildiri(BuildContext context, String mes) {
  showCupertinoDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData.from(
          colorScheme: const ColorScheme(
        primary: Colors.red,
        secondary: Colors.amber,
        surface: Colors.purpleAccent,
        background: Colors.red,
        error: Colors.red,
        onPrimary: Colors.red,
        onSecondary: Colors.deepOrange,
        onSurface: Colors.red,
        onBackground: Colors.red,
        onError: Colors.redAccent,
        brightness: Brightness.light,
      )),
      child: CupertinoAlertDialog(
        content: Column(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
            Text(
              mes,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text("Tamam"))
        ],
      ),
    ),
    barrierDismissible: true,
  );
}


void succBildiri(BuildContext context, String mes) {
  showCupertinoDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData.from(
          colorScheme: const ColorScheme(
            primary: Colors.green,
            secondary: Colors.amber,
            surface: Colors.purpleAccent,
            background: Colors.green,
            error: Colors.green,
            onPrimary: Colors.green,
            onSecondary: Colors.green,
            onSurface: Colors.green,
            onBackground: Colors.green,
            onError: Colors.green,
            brightness: Brightness.light,
          )),
      child: CupertinoAlertDialog(
        content: Column(
          children: [
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
            Text(
              mes,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text("Tamam"))
        ],
      ),
    ),
    barrierDismissible: true,
  );
}
