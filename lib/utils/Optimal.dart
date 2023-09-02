import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ran_man/utils/Utils.dart';

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}

class Game {
  // rain velocity m/s
  double rv;
  // angle of rain in degree
  double ra;
  // rain intensity 1/m^2
  double rho;
  // object velocity m/s
  double ov;
  // oject rotation angle in degree
  double alpha;
  // path lenghts
  List<Offset> path;

  List<Offset> object;

  double minRain = 0;
  double minOv = 0;

  Game(this.rv, this.ra, this.rho, this.ov, this.alpha, this.path, this.object);

  final Utils utils = Utils();

  @override
  String toString() {
    return 'Game{rv: $rv, ra: $ra, rho: $rho, ov: $ov, oa: $alpha, path: $path, object: $object}';
  }

  double getTheta(Offset a, Offset b) {
    return ra + utils.degrees(atan(utils.slope(a, b)));
  }

  double rainSpeed(double theta) {
    return sqrt(rv * rv + ov * ov - 2 * rv * ov * sin(utils.radians(theta)));
  }

  double rainfall(
    Offset a,
    Offset b,
  ) {
    double theta = getTheta(a, b);
    double rainSpeed = this.rainSpeed(theta);
    double delta = utils.calculateAngle(rv, ov, theta);
    double distance =
        sqrt(pow(scale(a.dx - b.dx), 2) + pow(scale(a.dy - b.dy), 2));
    double rain = rainSpeed * rho * distance * projection(delta) / ov;
    return rain;
  }

  void opmtimalTotalRainfall() {
    double minRain = 10000000;
    double minOv = 0;
    double minAlpha = 0;
    for (int alpha = 0; alpha < 360; alpha++) {
      this.alpha = alpha.toDouble();
      for (int velocity = 1; velocity < 1000; velocity++) {
        double rain = 0;
        this.ov = velocity.toDouble();
        for (int i = 0; i < path.length - 1; i++) {
          rain += rainfall(path[i], path[i + 1]);
        }
        if (minRain > rain) {
          minRain = rain;
          minOv = ov;
          minAlpha = alpha.toDouble();
        }
      }
    }
    this.minRain = minRain;
    this.minOv = minOv;
    this.minAlpha = minAlpha;
  }

  double minAlpha = 0;

  double projection(double delta) {
    List<Offset> rotatedObject = utils.rotatePolygon(object, alpha - delta);
    double minX = rotatedObject[0].dx;
    double maxX = rotatedObject[0].dx;
    for (Offset vertex in rotatedObject) {
      if (vertex.dx < minX) {
        minX = vertex.dx;
      }
      if (vertex.dx > maxX) {
        maxX = vertex.dx;
      }
    }
    return scale(maxX - minX);
  }

  double scale(double x) {
    return x / 100;
  }
}
