import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadePageItemCS extends StatelessWidget {
  FadePageItemCS({
    Key key,
    @required this.pageScrollPosition,
    @required this.pageNumber,
    @required this.child,
  }) : super(key: key);

  double deviceHeight, deviceWidth;
  final pageScrollPosition;
  final pageNumber;
  Widget child;

  @override
  Widget build(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height - statusHeight;

    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: Colors.white)),
        Positioned.fromRect(
          rect: getPageRect(),
          child: Opacity(
            opacity: getPageOpacity(),
            child: Scaffold(
                body: Container(
              child: child,
            )),
          ),
        ),
      ],
    );
  }

  Rect getPageRect() {
    if (checkPageUp()) return Offset(0, 0) & Size(deviceWidth, deviceHeight);

    double rectWidth = getRectWidth();
    double rectHeight = getRectHeight();

    double x = (deviceWidth - rectWidth) / 2;
    double y = (deviceHeight - rectHeight) + getNowScrollHeight();

    return Offset(x, y) & Size(rectWidth, rectHeight);
  }

  double getRectWidth() {
    double minWidthRatio = 0.80;
    double minRectWidth = deviceWidth * minWidthRatio;
    double rectWidthOffset = (deviceWidth - minRectWidth) * getScrollRatio();
    return minRectWidth + rectWidthOffset;
  }

  double getRectHeight() {
    double minHeightRatio = 0.85;
    double minRectHeight = deviceHeight * minHeightRatio;
    double rectHeightOffset = (deviceHeight - minRectHeight) * getScrollRatio();
    return minRectHeight + rectHeightOffset;
  }

  double getNowScrollHeight() {
    double startPagePosition = deviceHeight * pageNumber;
    return pageScrollPosition - startPagePosition;
  }

  double getScrollRatio() {
    double pageViewScrollOffset = deviceHeight - getNowScrollHeight();
    return pageViewScrollOffset / deviceHeight;
  }

  double getPageOpacity() {
    if (checkPageUp()) return 1;

    return getScrollRatio().clamp(0, 1).toDouble();
  }

  bool checkPageUp() {
    if (pageNumber == 0) return false;
    if (pageScrollPosition < deviceHeight * pageNumber) return true;
    return false;
  }
}
