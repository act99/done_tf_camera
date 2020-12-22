import 'dart:io';
import 'package:facefilter/screens/result_screen.dart';
import 'package:facefilter/tflite/photo_helper.dart';
import 'package:facefilter/widget/fade_page_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ChooseScreen extends StatefulWidget {
  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  // pageview
  PageController pageController;
  double pageScrollPosition = 1;

  // pick image
  bool gender;
  File _imageFile1;
  dynamic _pickImageError1;
  String _retrieveDataError1;
  File _imageFile2;
  dynamic _pickImageError2;
  String _retrieveDataError2;

  bool _loading = false;
  bool _loading1 = false;
  bool _loading2 = false;

  ImagePicker _picker = ImagePicker();

  List outputs1;
  List outputs2;

// ------------- tflite tools & image picker tools

  void updatePageState() {
    setState(() {
      pageScrollPosition = pageController.position.pixels.abs();
    });
  }

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModelMale().then((value) {
      setState(() {
        TFLiteHelper.modelLoaded = true;
        _loading = true;
      });
    });
    pageController = PageController(keepPage: true);
    pageController.addListener(updatePageState);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Widget _addPhoto1(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Container(
      width: width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            minWidth: width * 0.25,
            height: width * 0.25,
            onPressed: () {
              _onImageButtonPressed1(ImageSource.gallery, context: context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              width: width * 0.2,
              height: width * 0.2,
              child: Icon(
                Icons.photo_library,
                color: Colors.white,
                size: width * 0.1,
              ),
            ),
          ),
          FlatButton(
            minWidth: width * 0.25,
            height: width * 0.25,
            onPressed: () {
              _onImageButtonPressed1(ImageSource.camera, context: context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              width: width * 0.2,
              height: width * 0.2,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: width * 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPhoto2(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Container(
      width: width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            minWidth: width * 0.25,
            height: width * 0.25,
            onPressed: () {
              _onImageButtonPressed2(ImageSource.gallery, context: context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              width: width * 0.2,
              height: width * 0.2,
              child: Icon(
                Icons.photo_library,
                color: Colors.white,
                size: width * 0.1,
              ),
            ),
          ),
          FlatButton(
            minWidth: width * 0.25,
            height: width * 0.25,
            onPressed: () {
              _onImageButtonPressed2(ImageSource.camera, context: context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              width: width * 0.2,
              height: width * 0.2,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: width * 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewImage1(BoxFit option) {
    final Text retrieveError = _getRetrieveErrorWidget1();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile1 != null) {
      if (kIsWeb) {
        return Image.network(
          _imageFile1.path,
          fit: option,
        );
      } else {
        return Semantics(
            child: Image.file(
                File(
                  _imageFile1.path,
                ),
                fit: option),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError1 != null) {
      return Text(
        'Pick image error: $_pickImageError1',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewImage2(BoxFit option) {
    final Text retrieveError = _getRetrieveErrorWidget2();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile2 != null) {
      if (kIsWeb) {
        return Image.network(
          _imageFile2.path,
          fit: option,
        );
      } else {
        return Semantics(
            child: Image.file(
                File(
                  _imageFile2.path,
                ),
                fit: option),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError2 != null) {
      return Text(
        'Pick image error: $_pickImageError2',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return _loading
        ? Scaffold(
            key: _scaffoldkey,
            body: SafeArea(
              child: Center(
                  child: !kIsWeb
                      // && defaultTargetPlatform == TargetPlatform.android
                      ? FutureBuilder<void>(
                          future: retrieveLostData1(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                              // return const Text(
                              //   'You have not yet picked an image.',
                              //   textAlign: TextAlign.center,
                              // );
                              case ConnectionState.done:
                                return PageView(
                                  controller: pageController,
                                  scrollDirection: Axis.vertical,
                                  children: <Widget>[
                                    FadePageItemCS(
                                      pageNumber: 0,
                                      pageScrollPosition: pageScrollPosition,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            color: Colors.transparent,
                                            width: width * 1,
                                            height: width * 1.6,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: width * 1,
                                                  height: width * 1.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: width * 0.01,
                                                      )),
                                                  child: _imageFile1 != null
                                                      ? _previewImage1(
                                                          BoxFit.cover)
                                                      : _addPhoto1(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                          _loading1
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.007),
                                                      child: _imageFile1 != null
                                                          ? Container(
                                                              width:
                                                                  width * 0.4,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                color: Colors
                                                                    .blueGrey,
                                                              ),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  _imageFile1 =
                                                                      null;
                                                                  setState(() {
                                                                    _loading1 =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  '재선택',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          width *
                                                                              0.06),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width:
                                                                  width * 0.4,
                                                            ),
                                                    ),
                                                    Container(
                                                      width: width * 0.5,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: Color(
                                                              0xfff8a0d3)),
                                                      child: FlatButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          '다음',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    FadePageItemCS(
                                      pageNumber: 1,
                                      pageScrollPosition: pageScrollPosition,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            color: Colors.transparent,
                                            width: width * 1,
                                            height: width * 1.6,
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: width * 1,
                                                      height: width * 1.5,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color: Color(
                                                                0xffbf6d74),
                                                            width: width * 0.01,
                                                          )),
                                                      child: _imageFile2 != null
                                                          ? _previewImage2(
                                                              BoxFit.cover)
                                                          : _addPhoto2(context),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.007),
                                                      child: _imageFile2 != null
                                                          ? Container(
                                                              width:
                                                                  width * 0.4,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  color: Color(
                                                                      0xfff8a0d3)),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  _imageFile1 =
                                                                      null;
                                                                  setState(() {
                                                                    _loading1 =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  '재선택',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          width *
                                                                              0.06),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width:
                                                                  width * 0.4,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          _loading1 && _loading2
                                              ? Container(
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Color(0xfff8a0d3)),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ResultScreen(
                                                                    imageFile1:
                                                                        _imageFile1,
                                                                    imageFile2:
                                                                        _imageFile2,
                                                                    output1:
                                                                        outputs1,
                                                                    output2:
                                                                        outputs2,
                                                                    loading1:
                                                                        _loading1,
                                                                    loading2:
                                                                        _loading2,
                                                                  )));
                                                    },
                                                    child: Text(
                                                      '결과보기',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: width * 0.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Color(0xfff8a0d3)),
                                                  child: FlatButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      '다음',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );

                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Pick image/video error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return const Text(
                                    'You have not yet picked an image.',
                                    textAlign: TextAlign.center,
                                  );
                                }
                            }
                          },
                        )
                      : Container()),
            ),
          )
        : Center(
            child: Container(
              width: width * 0.1,
              height: width * 0.1,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ),
            ),
          );
  }

  Future<void> retrieveLostData1() async {
    final LostData response1 = await _picker.getLostData();
    final LostData response2 = await _picker.getLostData();
    if (response1.isEmpty && response2.isEmpty) {
      return;
    }
    if (response1.file != null && response2.file != null) {
      setState(() {
        _imageFile1 = File(response1.file.path);
        _imageFile2 = File(response2.file.path);
      });
    } else {
      _retrieveDataError1 = response1.exception.code;
      _retrieveDataError2 = response2.exception.code;
    }
  }

  Text _getRetrieveErrorWidget1() {
    if (_retrieveDataError1 != null) {
      final Text result = Text(_retrieveDataError1);
      _retrieveDataError1 = null;
      return result;
    }
    return null;
  }

  Text _getRetrieveErrorWidget2() {
    if (_retrieveDataError2 != null) {
      final Text result = Text(_retrieveDataError1);
      _retrieveDataError2 = null;
      return result;
    }
    return null;
  }

  classifyImage1(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 7,
    );
    setState(() {
      outputs1 = output;
      _loading1 = true;
    });
  }

  classifyImage2(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 7,
    );
    setState(() {
      outputs2 = output;
      _loading2 = true;
    });
  }

  void _onImageButtonPressed1(ImageSource source,
      {BuildContext context}) async {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile1 = File(pickedFile.path);
      });
      classifyImage1(File(pickedFile.path));
    } catch (e) {
      setState(() {
        _pickImageError1 = e;
      });
    }
  }

  void _onImageButtonPressed2(ImageSource source,
      {BuildContext context}) async {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _imageFile2 = File(pickedFile.path);
      });
      classifyImage2(File(pickedFile.path));
    } catch (e) {
      setState(() {
        _pickImageError2 = e;
      });
    }
  }
}
