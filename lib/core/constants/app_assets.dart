/// AppAsets enum
enum AppAsets {
  humanBody('assets/3d_models/human.obj'),
  handL('assets/3d_models/hand_r.obj'),
  handR('assets/3d_models/hand.obj'),
  tflateModel('assets/models/model.tflite'),
  ;

  const AppAsets(
    this.value,
  );

  /// AppAsets degeri
  final String value;
}
