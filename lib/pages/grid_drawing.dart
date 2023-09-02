import 'dart:ui';
import '../utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:ran_man/pages/result_page.dart';
import 'package:ran_man/utils/Optimal.dart';

class GridDrawingPage extends StatefulWidget {
  const GridDrawingPage({super.key});

  @override
  State<GridDrawingPage> createState() => _GridDrawingPageState();
}

class _GridDrawingPageState extends State<GridDrawingPage> {
  final numPointsController = TextEditingController(text: "03");
  final rainAngleController = TextEditingController(text: "00");
  final rainSpeedController = TextEditingController(text: "10");
  final rainIntensityController = TextEditingController(text: "5");

  final numVerticalController = TextEditingController(text: '02');

  GlobalKey<_DrawingBoardState> drawingBoardKey = GlobalKey();
  GlobalKey<_PathDrawBoardState> pathDrawBoardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    numPointsController.addListener(() {
      setState(() {});
    });
    numVerticalController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Rain Man'),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.navigate_before),
            )),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Object',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DrawingBoard(
                          key: drawingBoardKey,
                          numPoints: int.parse(numPointsController.text.trim()),
                        )
                      ],
                    ),
                    8.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          30.height,
                          TextField(
                            controller: numPointsController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number of points',
                            ),
                          ),
                          8.height,
                          TextField(
                            controller: rainAngleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rain Angle(degrees)',
                            ),
                          ),
                          8.height,
                          TextField(
                            controller: rainSpeedController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rain Speed (m/s)',
                            ),
                          ),
                          8.height,
                          TextField(
                            controller: rainIntensityController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rain Intensity(drops/m^2)',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                20.height,
                Text(
                  'Draw Path',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                12.height,
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextField(
                    controller: numVerticalController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number of Vertices',
                    ),
                  ),
                ),
                12.height,
                PathDrawBoard(
                    key: pathDrawBoardKey,
                    numVertex: int.parse(numVerticalController.text)),
                16.height,
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ResultPage(
                        game: getGame(),
                      ),
                    ));
                  },
                  child: Text(
                    'Show Results',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: BorderSide(color: Colors.white, width: 1),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  ),
                )
              ]),
        ));
  }

  Game getGame() {
    final rainAngle = double.parse(rainAngleController.text.trim());
    final rainSpeed = double.parse(rainSpeedController.text.trim());
    final rainIntensity = double.parse(rainIntensityController.text.trim());

    final objectDrawing = drawingBoardKey.currentState!.points;
    final object = objectDrawing
        .getRange(
          0,
          objectDrawing.length - 1,
        )
        .toList();
    final pathDrawing = pathDrawBoardKey.currentState!.points;

    final path = pathDrawing
        .getRange(
          0,
          pathDrawing.length - 1,
        )
        .toList();
    return Game(rainSpeed, rainAngle, rainIntensity, 1, 0, path, object);
  }
}

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key, required this.numPoints});
  final int numPoints;

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<Offset> points = [];

  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => setState(() {
        if (isDrawing == false) {
          isDrawing = true;
          points.clear();
          points.add(details.localPosition);
        }
        if (points.length == widget.numPoints) {
          isDrawing = false;
          points.add(points.first);
        } else {
          points.add(details.localPosition);
        }
      }),
      child: MouseRegion(
        onHover: (event) {
          if (isDrawing) {
            setState(() {
              points.last = event.localPosition;
            });
          }
          print(event.localPosition);
        },
        child: Container(
          width: 600,
          height: 400,
          color: Colors.grey[300],
          child: CustomPaint(
            painter: LinePainter(points: [points]),
          ),
        ),
      ),
    );
  }
}

class PathDrawBoard extends StatefulWidget {
  const PathDrawBoard({super.key, required this.numVertex});
  final int numVertex;

  @override
  State<PathDrawBoard> createState() => _PathDrawBoardState();
}

class _PathDrawBoardState extends State<PathDrawBoard> {
  List<Offset> points = [];
  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => setState(() {
        if (isDrawing == false) {
          isDrawing = true;
          points.clear();
          points.add(details.localPosition);
        }
        if (points.length == widget.numVertex) {
          isDrawing = false;
        }
        points.add(details.localPosition);
      }),
      child: MouseRegion(
        onHover: (event) {
          if (isDrawing) {
            setState(() {
              points.last = event.localPosition;
            });
          }
          print(event.localPosition);
        },
        child: Container(
          width: 600,
          height: 400,
          color: Colors.grey[300],
          child: CustomPaint(
            painter: LinePainter(points: [points]),
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<List<Offset>> points;

  const LinePainter({this.points = const []});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final pointPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length; i++) {
      canvas.drawPoints(PointMode.points, points[i], pointPaint);
      for (int j = 0; j < points[i].length - 1; j++) {
        canvas.drawLine(points[i][j], points[i][j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height(),
      width: context.width(),
      color: Colors.grey[200],
    );
  }
}
