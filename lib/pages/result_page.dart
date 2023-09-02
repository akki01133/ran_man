import 'package:flutter/material.dart';
import 'package:ran_man/pages/grid_drawing.dart';
import 'package:ran_man/utils/Optimal.dart';
import 'package:ran_man/utils/Utils.dart';

class ResultPage extends StatefulWidget {
  final Game game;
  const ResultPage({super.key, required this.game});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int rainParticles = 0;
  int speed = 0;

  bool isCalculated = false;

  @override
  void initState() {
    super.initState();
    widget.game.opmtimalTotalRainfall();
    rainParticles = widget.game.minRain.toInt();
    speed = widget.game.minOv.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Result'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rain Particles: $rainParticles'),
              8.height,
              Text('Speed: $speed(m/s)'),
              8.height,
              Text('Object Angle: ${widget.game.minAlpha} degrees'),
              8.height,
              Container(
                width: 1200,
                height: 800,
                color: Colors.grey[300],
                child: CustomPaint(
                  painter: LinePainter(points: [
                    Utils().shiftPolygon(
                        Utils().rotatePolygon(
                            widget.game.object..add(widget.game.object.first),
                            widget.game.minAlpha),
                        Offset(600, 400)),
                    Utils().shiftPolygon(widget.game.path, Offset(600, 400)),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
