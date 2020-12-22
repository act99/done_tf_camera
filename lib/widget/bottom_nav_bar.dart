import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Container(
      height: height * 0.08,
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only()),
      child: Stack(
        children: [
          TabBar(
            indicatorColor: Colors.black54,
            unselectedLabelColor: Colors.black54,
            labelColor: Colors.blueGrey,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.home),
              ),
              SizedBox(),
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
