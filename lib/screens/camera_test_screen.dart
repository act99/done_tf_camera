// import 'package:camera/camera.dart';
// import 'package:facefilter/tflite/realtime_helper_male.dart';
// import 'package:facefilter/tflite/realtime_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class CameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   CameraScreen({this.camera});
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen>
//     with TickerProviderStateMixin {
//   CameraController _cameraController;
//   Future<void> _initializeControllerFuture;
//   String albumName = 'PhotoAi';
//   List<CameraDescription> _availableCameras;

// // 퍼센트 나타내기 위한 컨트롤러
//   AnimationController _colorAnimController;
//   Animation _colorTween;
//   List<Result> outputs;

// // Tflite & camera 연동을 위한
//   bool isDetecting = false;
//   static Future<void> initializeControllerFuture;

//   void _setupAnimation() {
//     _colorAnimController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     _colorTween = ColorTween(begin: Colors.green, end: Colors.red)
//         .animate(_colorAnimController);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // 카메라의 현재 출력물을 보여주기 위해 CameraController를 생성합니다.
//     _cameraController = CameraController(
//       // 이용 가능한 카메라 목록에서 특정 카메라를 가져옵니다.
//       widget.camera,
//       // 적용할 해상도를 지정합니다.
//       ResolutionPreset.high,
//     );

//     // 다음으로 controller를 초기화합니다. 초기화 메서드는 Future를 반환합니다.
//     _initializeControllerFuture = _cameraController.initialize();
//     // 앞뒤 반전에 필요한 코드
//     _getAvailableCameras();
//     // TFLite를 사용하기 위한
//     TFLiteHelperRealMale.loadModel().then((value) {
//       setState(() {
//         TFLiteHelperRealMale.modelLoaded = true;
//       });
//     });
//     //Setup Animation
//     _setupAnimation();
//     // TFlite 스트림을 위한 빌드업
//     TFLiteHelperRealMale.tfLiteResultsController.stream.listen(
//         (value) {
//           value.forEach((element) {
//             _colorAnimController.animateTo(element.confidence,
//                 curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
//           });

//           //Set Results
//           outputs = value;

//           //Update results on screen
//           setState(() {
//             //Set bit to false to allow detection again
//           });
//         },
//         onDone: () {},
//         onError: (error) {
//           AppHelperRealMale.log("listen", error);
//         });
//   }

//   // 카메라 좌우반전을 위한 카메라 가능 기능 겟

//   Future<void> _getAvailableCameras() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     _availableCameras = await availableCameras();
//     _initCamera(_availableCameras.first);
//   }

//   // init camera
//   Future<void> _initCamera(CameraDescription description) async {
//     _cameraController = CameraController(
//         description,
//         defaultTargetPlatform == TargetPlatform.iOS
//             ? ResolutionPreset.low
//             : ResolutionPreset.max,
//         enableAudio: false);
//     initializeControllerFuture = _cameraController.initialize().then((value) {
//       AppHelperRealMale.log(
//           "_initializeCamera", "Camera initialized, starting camera stream..");

//       _cameraController.startImageStream((CameraImage image) {
//         if (!TFLiteHelperRealMale.modelLoaded) return;
//         if (isDetecting) return;
//         isDetecting = true;
//         try {
//           TFLiteHelperRealMale.classifyImage(image);
//         } catch (e) {
//           print(e);
//         }
//       });
//     });
//     // try {
//     //   await _cameraController.initialize();
//     //   // to notify the widgets that camera has been initialized and now camera preview can be done
//     //   setState(() {});
//     // } catch (e) {
//     //   print(e);
//     // }
//     AppHelperRealMale.log("_initializeCamera", "Initializing camera..");
//   }

//   // 카메라렌즈 전후 반전 토글

//   void _toggleCameraLens() {
//     // get current lens direction (front / rear)
//     final lensDirection = _cameraController.description.lensDirection;
//     CameraDescription newDescription;
//     if (lensDirection == CameraLensDirection.front) {
//       newDescription = _availableCameras.firstWhere((description) =>
//           description.lensDirection == CameraLensDirection.back);
//     } else {
//       newDescription = _availableCameras.firstWhere((description) =>
//           description.lensDirection == CameraLensDirection.front);
//     }

//     if (newDescription != null) {
//       _initCamera(newDescription);
//     } else {
//       print('Asked camera not available');
//     }
//   }

//   @override
//   void dispose() {
//     // 위젯의 생명주기 종료시 컨트롤러 해제
//     _cameraController.dispose();
//     TFLiteHelperRealMale.disposeModel();
//     AppHelperRealMale.log("dispose", "Clear resources.");

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//     double height = screenSize.height;
//     return Scaffold(
//       // 카메라 프리뷰를 보여주기 전에 컨트롤러 초기화를 기다려야 합니다. 컨트롤러 초기화가
//       // 완료될 때까지 FutureBuilder를 사용하여 로딩 스피너를 보여주세요.
//       body: SafeArea(
//         child: Stack(
//           children: [
//             FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   // Future가 완료되면, 프리뷰를 보여줍니다.
//                   return CameraPreview(_cameraController);
//                 } else {
//                   // 그렇지 않다면, 진행 표시기를 보여줍니다.
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.only(bottom: height * 0.05),
//                 width: height * 0.1,
//                 height: height * 0.1,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(300)),
//                 child: FlatButton(
//                   onPressed: () async {
//                     // try / catch 블럭에서 사진을 촬영합니다. 만약 뭔가 잘못된다면 에러에
//                     // 대응할 수 있습니다.
//                     try {
//                       // 카메라 초기화가 완료됐는지 확인합니다.
//                       await _initializeControllerFuture;

//                       // path 패키지를 사용하여 이미지가 저장될 경로를 지정합니다.
//                       final path = join(
//                         // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
//                         // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
//                         (await getApplicationDocumentsDirectory()).path,
//                         '${DateTime.now()}.png',
//                       );

//                       // 사진 촬영을 시도하고 저장되는 경로를 로그로 남깁니다.
//                       await _cameraController.takePicture(path);

//                       print(path);
//                       // 사진을 촬영하면, 새로운 화면으로 넘어갑니다.
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DisplayPictureScreen(
//                             imagePath: path,
//                             albumName: albumName,
//                           ),
//                         ),
//                       );
//                     } catch (e) {
//                       // 만약 에러가 발생하면, 콘솔에 에러 로그를 남깁니다.
//                       print(e);
//                     }
//                   },
//                   child: Icon(
//                     Icons.camera_alt,
//                     color: Colors.grey,
//                     size: width * 0.1,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(
//             Icons.flip_camera_android,
//             size: width * 0.09,
//           ),
//           // onPressed 콜백을 제공합니다.
//           onPressed: () {
//             // setState(() {});
//             _toggleCameraLens();
//           }),
//     );
//   }

//   // Widget _buildResultsWidget(double width, List<Result> outputs) {
//   //   return Positioned.fill(
//   //     child: Align(
//   //       alignment: Alignment.bottomCenter,
//   //       child: Container(
//   //         height: 200.0,
//   //         width: width,
//   //         color: Colors.white,
//   //         child: outputs != null && outputs.isNotEmpty
//   //             ? ListView.builder(
//   //                 itemCount: outputs.length,
//   //                 shrinkWrap: true,
//   //                 padding: const EdgeInsets.all(20.0),
//   //                 itemBuilder: (BuildContext context, int index) {
//   //                   return Column(
//   //                     children: <Widget>[
//   //                       Text(
//   //                         outputs[index].label,
//   //                         style: TextStyle(
//   //                           color: _colorTween.value,
//   //                           fontSize: 20.0,
//   //                         ),
//   //                       ),
//   //                       AnimatedBuilder(
//   //                           animation: _colorAnimController,
//   //                           builder: (context, child) => LinearPercentIndicator(
//   //                                 width: width * 0.88,
//   //                                 lineHeight: 14.0,
//   //                                 percent: outputs[index].confidence,
//   //                                 progressColor: _colorTween.value,
//   //                               )),
//   //                       Text(
//   //                         "${(outputs[index].confidence * 100.0).toStringAsFixed(2)} %",
//   //                         style: TextStyle(
//   //                           color: _colorTween.value,
//   //                           fontSize: 16.0,
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   );
//   //                 })
//   //             : Center(
//   //                 child: Text("Wating for model to detect..",
//   //                     style: TextStyle(
//   //                       color: Colors.black,
//   //                       fontSize: 20.0,
//   //                     ))),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//   final String albumName;
//   const DisplayPictureScreen({Key key, this.imagePath, this.albumName})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width;
//     double height = screenSize.height;
//     return Scaffold(
//       // 이미지는 디바이스에 파일로 저장됩니다. 이미지를 보여주기 위해 주어진
//       // 경로로 `Image.file`을 생성하세요.
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 height: width * 1.5,
//                 child: Image.file(File(imagePath)),
//               ),
//               FlatButton(
//                 onPressed: () {
//                   GallerySaver.saveImage(imagePath, albumName: albumName);
//                 },
//                 child: Icon(Icons.check),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
