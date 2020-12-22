import 'dart:io';
import 'package:facefilter/main.dart';
import 'package:facefilter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile1;
  final File imageFile2;
  final List output1;
  final List output2;
  final bool loading1;
  final bool loading2;
  ResultScreen(
      {this.imageFile1,
      this.imageFile2,
      this.output1,
      this.output2,
      this.loading1,
      this.loading2});
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: width * 0.06, left: width * 0.06),
              width: width * 1,
              height: height * 0.1,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결과!!',
                    style:
                        TextStyle(color: Colors.black, fontSize: width * 0.06),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              width: width * 1,
              height: height * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: width * 0.48,
                    height: width * 0.72,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color(0xffbf6d74),
                          width: width * 0.01,
                        )),
                    child: Image.file(
                        File(
                          widget.imageFile1.path,
                        ),
                        fit: BoxFit.cover),
                  ),
                  Container(
                    width: width * 0.48,
                    height: width * 0.72,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Color(0xffbf6d74), width: width * 0.01)),
                    child: Image.file(
                        File(
                          widget.imageFile2.path,
                        ),
                        fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
            // widget.output1[0]['label'].toString() == '3 잘생김4'
            //     ? Text('${widget.output1[0]['confidence']}')
            //     : Text('1'),
            // Text(
            //   (widget.output2[0]['confidence'] * 100).toString(),
            // ),
            // Text(
            //   (widget.output2[0]['index'] + 1).toString(),
            // ),
            Text(
              (widget.output2[0]['confidence'] *
                      100 /
                      (widget.output2[0]['index'] + 1))
                  .toString(),
            ),
            _calculation(context, widget.output1, widget.output2),
            Container(
              height: 100.0,
              width: width,
              color: Colors.white,
              child: widget.output1 != null && widget.output1.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.output1.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Text(
                              "${(widget.output1[index]['confidence'] * 100.0).toStringAsFixed(2)} %",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              widget.output1[index]['label'],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            LinearPercentIndicator(
                              width: width * 0.88,
                              lineHeight: 14.0,
                              percent: widget.output1[index]['confidence'],
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text("Wating for model to detect..",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ))),
            ),
            Container(
              height: 100.0,
              width: width,
              color: Colors.white,
              child: widget.output2 != null && widget.output2.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.output2.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Text(
                              "${(widget.output2[index]['confidence'] * 100.0).toStringAsFixed(2)} %",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              widget.output2[index]['label'],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            LinearPercentIndicator(
                              width: width * 0.88,
                              lineHeight: 14.0,
                              percent: widget.output2[index]['confidence'],
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Wating for model to detect..",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
            ),
            Container(
              width: width * 0.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xfff8a0d3)),
              child: FlatButton(
                onPressed: () {
                  // loading1 = false;
                  // loading2 = false;

                  // widget.output1 = null;
                  // widget.output2 = null;
                  // widget.imageFile1 = null;
                  // widget.imageFile2 = null;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Text(
                  '재선택',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.06),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

Widget _calculation(BuildContext context, List output1, List output2) {
  // for (int i = 0; i < output1.length; i++) {
  //   var a =
  // }
  double outputResult1;
  double outputResult2;
  if (output1.length == 1) {
    var a = output1[0]['confidence'] * 100;
    var ai = output1[0]['index'];
    var sum1 = a;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var result1 = sumAveragea * (7 - ai);
    outputResult1 = result1;
  }
  if (output1.length == 2) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var sum1 = a + b;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var result1 = sumAveragea * (7 - ai) + sumAverageb * (7 - bi);
    outputResult1 = result1;
  }
  if (output1.length == 3) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var c = output1[2]['confidence'] * 100;

    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var ci = output1[2]['index'];

    var sum1 = a + b + c;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci);
    outputResult1 = result1;
  }
  if (output1.length == 4) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var c = output1[2]['confidence'] * 100;
    var d = output1[3]['confidence'] * 100;

    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var ci = output1[2]['index'];
    var di = output1[3]['index'];

    var sum1 = a + b + c + d;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di);

    outputResult1 = result1;
  }
  if (output1.length == 5) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var c = output1[2]['confidence'] * 100;
    var d = output1[3]['confidence'] * 100;
    var e = output1[4]['confidence'] * 100;

    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var ci = output1[2]['index'];
    var di = output1[3]['index'];
    var ei = output1[4]['index'];

    var sum1 = a + b + c + d + e;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei);

    outputResult1 = result1;
  }
  if (output1.length == 6) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var c = output1[2]['confidence'] * 100;
    var d = output1[3]['confidence'] * 100;
    var e = output1[4]['confidence'] * 100;
    var f = output1[5]['confidence'] * 100;

    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var ci = output1[2]['index'];
    var di = output1[3]['index'];
    var ei = output1[4]['index'];
    var fi = output1[5]['index'];

    var sum1 = a + b + c + d + e + f;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);
    var sumAveragef = f + f / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei) +
        sumAveragef * (7 - fi);

    outputResult1 = result1;
  }
  if (output1.length == 7) {
    var a = output1[0]['confidence'] * 100;
    var b = output1[1]['confidence'] * 100;
    var c = output1[2]['confidence'] * 100;
    var d = output1[3]['confidence'] * 100;
    var e = output1[4]['confidence'] * 100;
    var f = output1[5]['confidence'] * 100;
    var g = output1[6]['confidence'] * 100;

    var ai = output1[0]['index'];
    var bi = output1[1]['index'];
    var ci = output1[2]['index'];
    var di = output1[3]['index'];
    var ei = output1[4]['index'];
    var fi = output1[5]['index'];
    var gi = output1[6]['index'];

    var sum1 = a + b + c + d + e + f + g;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);
    var sumAveragef = f + f / sum1 * (100 - sum1);
    var sumAverageg = f + f / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei) +
        sumAveragef * (7 - fi) +
        sumAverageg * (7 - gi);

    outputResult1 = result1;
  }
  if (output2.length == 1) {
    var a = output2[0]['confidence'] * 100;
    var ai = output2[0]['index'];
    var sum1 = a;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var result1 = sumAveragea * (7 - ai);
    outputResult2 = result1;
  }
  if (output2.length == 2) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var sum1 = a + b;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var result1 = sumAveragea * (7 - ai) + sumAverageb * (7 - bi);
    outputResult2 = result1;
  }
  if (output2.length == 3) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var c = output2[2]['confidence'] * 100;

    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var ci = output2[2]['index'];

    var sum1 = a + b + c;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci);
    outputResult2 = result1;
  }
  if (output2.length == 4) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var c = output2[2]['confidence'] * 100;
    var d = output2[3]['confidence'] * 100;

    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var ci = output2[2]['index'];
    var di = output2[3]['index'];

    var sum1 = a + b + c + d;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di);

    outputResult2 = result1;
  }
  if (output2.length == 5) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var c = output2[2]['confidence'] * 100;
    var d = output2[3]['confidence'] * 100;
    var e = output2[4]['confidence'] * 100;

    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var ci = output2[2]['index'];
    var di = output2[3]['index'];
    var ei = output2[4]['index'];

    var sum1 = a + b + c + d + e;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei);

    outputResult2 = result1;
  }
  if (output2.length == 6) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var c = output2[2]['confidence'] * 100;
    var d = output2[3]['confidence'] * 100;
    var e = output2[4]['confidence'] * 100;
    var f = output2[5]['confidence'] * 100;

    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var ci = output2[2]['index'];
    var di = output2[3]['index'];
    var ei = output2[4]['index'];
    var fi = output2[5]['index'];

    var sum1 = a + b + c + d + e + f;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);
    var sumAveragef = f + f / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei) +
        sumAveragef * (7 - fi);

    outputResult2 = result1;
  }
  if (output2.length == 7) {
    var a = output2[0]['confidence'] * 100;
    var b = output2[1]['confidence'] * 100;
    var c = output2[2]['confidence'] * 100;
    var d = output2[3]['confidence'] * 100;
    var e = output2[4]['confidence'] * 100;
    var f = output2[5]['confidence'] * 100;
    var g = output2[6]['confidence'] * 100;

    var ai = output2[0]['index'];
    var bi = output2[1]['index'];
    var ci = output2[2]['index'];
    var di = output2[3]['index'];
    var ei = output2[4]['index'];
    var fi = output2[5]['index'];
    var gi = output2[6]['index'];

    var sum1 = a + b + c + d + e + f + g;
    var sumAveragea = a + a / sum1 * (100 - sum1);
    var sumAverageb = b + b / sum1 * (100 - sum1);
    var sumAveragec = c + c / sum1 * (100 - sum1);
    var sumAveraged = d + d / sum1 * (100 - sum1);
    var sumAveragee = e + e / sum1 * (100 - sum1);
    var sumAveragef = f + f / sum1 * (100 - sum1);
    var sumAverageg = f + f / sum1 * (100 - sum1);

    var result1 = sumAveragea * (7 - ai) +
        sumAverageb * (7 - bi) +
        sumAveragec * (7 - ci) +
        sumAveraged * (7 - di) +
        sumAveragee * (7 - ei) +
        sumAveragef * (7 - fi) +
        sumAverageg * (7 - gi);

    outputResult2 = result1;
  }
  if (outputResult1 > outputResult2) {
    return Text('>');
  } else if (outputResult1 < outputResult2) {
    return Text('<');
  } else
    return Text('=');
}
// var a = output1[0]['confidence'] * 100;
// var b = output1[1]['confidence'] != null ? output1[1]['confidence'] * 100 : 0;
// var c = output1[2]['confidence'] != null ? output1[2]['confidence'] * 100 : 0;
// var d = output1[3]['confidence'] != null ? output1[3]['confidence'] * 100 : 0;
// var e = output1[4]['confidence'] != null ? output1[4]['confidence'] * 100 : 0;
// var f = output1[5]['confidence'] != null ? output1[5]['confidence'] * 100 : 0;
// var g = output1[6]['confidence'] != null ? output1[6]['confidence'] * 100 : 0;
// var ai = output1[0]['index'];
// var bi = output1[1]['index'] != null ? output1[1]['index'] : 0;
// var ci = output1[2]['index'] != null ? output1[2]['index'] : 0;
// var di = output1[3]['index'] != null ? output1[3]['index'] : 0;
// var ei = output1[4]['index'] != null ? output1[4]['index'] : 0;
// var fi = output1[5]['index'] != null ? output1[5]['index'] : 0;
// var gi = output1[6]['index'] != null ? output1[6]['index'] : 0;

// var sum1 = a + b + c + d + e + f + g;
// var sumAveragea = a + a / sum1 * (100 - sum1);
// var sumAverageb = b + b / sum1 * (100 - sum1);
// var sumAveragec = c + c / sum1 * (100 - sum1);
// var sumAveraged = d + d / sum1 * (100 - sum1);
// var sumAveragee = e + e / sum1 * (100 - sum1);
// var sumAveragef = f + f / sum1 * (100 - sum1);
// var sumAverageg = g + g / sum1 * (100 - sum1);
// var result1 = sumAveragea * (7 - ai) +
//     sumAverageb * (7 - bi) +
//     sumAveragec * (7 - ci) +
//     sumAveraged * (7 - di) +
//     sumAveragee * (7 - ei) +
//     sumAveragef * (7 - fi) +
//     sumAverageg * (7 - gi);

// return Text(result1.toString());
