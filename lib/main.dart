import 'package:facefilter/screens/camera_screen.dart';
import 'package:facefilter/screens/home_screen.dart';
import 'package:facefilter/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  // 이용가능한 카메라 목록에서 특정 카메라를 얻습니다.
  final firstCamera = cameras.first;
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: MyApp(
      camera: firstCamera,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;
  MyApp({this.camera});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            HomeScreen(),
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
        floatingActionButton: Container(
          padding: EdgeInsets.only(top: height * 0.02),
          width: width * 0.2,
          height: width * 0.2,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CameraScreen(
                            camera: widget.camera,
                          )));
            },
            tooltip: 'Increment',
            child: Container(
              width: width * 0.15,
              height: width * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(300),
                border:
                    Border.all(width: width * 0.007, color: Colors.blueGrey),
              ),
            ),
            elevation: 0.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
