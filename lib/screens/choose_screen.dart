import 'package:flutter/material.dart';

class ChooseScreen extends StatefulWidget {
  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              InkWell(
                child: Container(
                  width: width * 0.72,
                  height: width * 0.96,
                  decoration: BoxDecoration(
                    border: Border.all(width: width * 0.003),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onTap: () {
                  _scaffoldkey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('hi'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
