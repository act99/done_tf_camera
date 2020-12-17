import 'dart:async';
import 'dart:io';
import 'package:facefilter/tflite/app_helper.dart';
import 'package:facefilter/tflite/realtime_model.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {
  static List<Result> _outputs = List();
  static var modelLoaded = false;

  static Future<String> loadModel1() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/model_unquant1.tflite",
      labels: "assets/labels1.txt",
    );
  }

  static Future<String> loadModel2() async {
    AppHelper.log("loadModel", "Loading model..");

    return Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  static classifyImage(File image) async {
    await Tflite.runModelOnImage(
      path: image.path,
      numResults: 7,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    ).then((value) {
      if (value.isNotEmpty) {
        _outputs.clear();
        value.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));
        });
      }

      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));
    });
  }

  static void disposeModel() {
    Tflite.close();
  }
}
