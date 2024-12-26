import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:sleep/core/constants/app_assets.dart';
import 'package:sleep/data/models/data.dart';
import 'package:sleep/data/models/seans.dart';
import 'package:sleep/data/services/cordinat_service.dart';
import 'package:sleep/data/services/tflate_service.dart';
import 'package:sleep/ui/screens/view_screen/view_screen.dart';

/// ViewScreen mixin sınıfı
mixin ViewScreenMixin on State<ViewScreen> {
  ValueNotifier<double> solBileklikProgres = ValueNotifier<double>(0);
  int solIndex = 0;
  ValueNotifier<double> sagBileklikProgres = ValueNotifier<double>(0);
  int sagIndex = 0;
  Timer? solTimer;
  Timer? sagTimer;

  late Seans solBileklik;
  late Seans sagBileklik;

  @override
  void initState() {
    super.initState();
    TfliteService.instance.init();
    solBileklik = widget.solBileklik ??
        Seans(
          datas: [],
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );
    sagBileklik = widget.sagBileklik ??
        Seans(
          datas: [],
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );
    startTimer();

  }

  @override
  void dispose() {
    solTimer?.cancel();
    sagTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    solTimer = Timer.periodic(
        Duration(milliseconds: 100), (Timer t) => updateRigthData(t));
    sagTimer = Timer.periodic(
        Duration(milliseconds: 100), (Timer t) => updateLeftData(t));
  }

  void updateRigthData(Timer t) {
    sagBileklikProgres.value += 1 / (sagBileklik.datas.length);
    if (sagIndex < sagBileklik.datas.length) {
      updateRightHandRotation(sagBileklik.datas[sagIndex]);
    }
    sagIndex++;
    if (sagBileklikProgres.value >= 1.0) {
      sagBileklikProgres.value = 1.0;
      if (sagIndex >= sagBileklik.datas.length) {
        t.cancel();
      }
    }
    sagBileklikProgres.notifyListeners();
  }

  void updateLeftData(Timer t) {
    solBileklikProgres.value += 1 / (solBileklik.datas.length);
    print('solIndex: ${solBileklikProgres.value}}');
    if (solIndex < solBileklik.datas.length) {
      updateLeftHandRotation(solBileklik.datas[solIndex]);
    }
    solIndex++;
    if (solBileklikProgres.value >= 1.0) {
      solBileklikProgres.value = 1;
      if (solIndex >= solBileklik.datas.length) {
        t.cancel();
      }
    }
    solBileklikProgres.notifyListeners();
  }

  Object? leftHandObject;
  Object? rightHandObject;
  Object? humanObject;
  Scene? scene;
  Vector3 minHandPosition = Vector3(-2, -2, 0);
  Vector3 maxHandPosition = Vector3(2, 2, 0);
  double roll = 45.311893;
  double pitch = 67.96784;
  double yaw = -110.311893;

  // vicudu ters çevir
  Future<void> humanFrontRotation() async {
    humanObject!.rotation.setValues(90, 0, 0);
    humanObject!.updateTransform();
    scene?.update();
  }

  Future<void> humanBackRotation() async {
    humanObject!.rotation.setValues(90, 180, 0);
    humanObject!.updateTransform();
    scene?.update();
  }

  void sahne(Scene scene) {
    this.scene = scene;

    // İnsan modelini yatay pozisyonda gösterelim
    humanObject = Object(
      fileName: AppAsets.humanBody.value,
      name: 'human',
      isAsset: true,
      position: Vector3(-100, 0, 0),
      rotation: Vector3(0, 180, 90),
      scale: Vector3(500, 500, 500),
      lighting: true,
      backfaceCulling: true,
    );

    // Sol el
    leftHandObject = Object(
      fileName: AppAsets.handL.value,
      scale: Vector3(20, 20, 20),
      position: Vector3(-90, -80, 0),
      rotation: Vector3(0, 80, -90),
      lighting: true,
    );

    // Sağ el (aynı modeli kullanıp ters çevireceğiz)
    rightHandObject = Object(
      fileName: AppAsets.handR.value,
      scale: Vector3(-20, 20, 20),
      position: Vector3(-50, -80, 0),
      rotation: Vector3(90, 90,90),
      lighting: true,
    );

    // Modelleri sahneye ekleyelim
    scene.world.add(humanObject!);
    scene.world.add(leftHandObject!);
    scene.world.add(rightHandObject!);

    // Kamera ve ışık ayarları aynı kalacak
    scene.camera.zoom = 1.3;
    scene.camera.position.setValues(0, 0, -300);
    scene.camera.target.setValues(0, 0, 0);

    scene.light.position.setFrom(Vector3(0, 0, -500));
    scene.light.setColor(
      Colors.white,
      0.3,
      0.7,
      0.2,
    );

    scene.update();
    Future.delayed(Duration(milliseconds: 100), () {
      scene.update();
    });
  }

  void updateLeftHandRotation(Data data) {
    final roll = data.x;
    final pitch = data.y;
    final yaw = 10.0; //data.z;
    print('pitch: $pitch, roll: $roll, yaw: $yaw');
    leftHandObject!.position.setValues(pitch, roll, yaw);
    leftHandObject!.updateTransform();
    scene?.update();
  }

  void updateRightHandRotation(Data data) {
    final roll = data.x;
    final pitch = data.y;
    final yaw = 10.0; //data.z;
    rightHandObject!.position.setValues(pitch, roll, yaw);
    rightHandObject!.updateTransform();
    scene?.update();
  }
}
