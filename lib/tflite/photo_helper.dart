import 'dart:async';
import 'dart:io';
import 'package:facefilter/tflite/app_helper.dart';
import 'package:facefilter/tflite/realtime_model.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {
  static List<Result> _outputs = List();
  static var modelLoaded = false;

  static Future<String> loadModelFemale() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/model_unquant1.tflite",
      labels: "assets/labels1.txt",
    );
  }

  static Future<String> loadModelMale() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  static void disposeModel() {
    Tflite.close();
  }
}
