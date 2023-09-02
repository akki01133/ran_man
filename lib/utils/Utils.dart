import 'dart:math';
import 'package:flutter/material.dart';

class Utils {
  double radians(double degree) {
    return degree * pi / 180;
  }

  double degrees(double radian) {
    return radian * 180.0 / pi;
  }

  double calculateAngle(double v, double r, double theta) {
    // Calculate the lengths of the sides
    double perpendicularSide = v * cos(radians(theta));
    double hypotenuseSide =
        sqrt(v * v + r * r - 2 * v * r * sin(radians(theta)));

    // Calculate the angle in radians using arccosine
    double angle = asin(perpendicularSide / hypotenuseSide);

    // Convert the angle from radians to degrees
    double angleInDegrees = angle * (180.0 / pi);

    return angleInDegrees;
  }

  List<Offset> rotatePolygon(List<Offset> vertices, double alpha) {
    // Extract the coordinates of the first point as the center of rotation
    double x0 = vertices[0].dx;
    double y0 = vertices[0].dy;

    // Calculate the sine and cosine of the rotation angle
    double cosAlpha = cos(radians(alpha));
    double sinAlpha = sin(radians(alpha));

    // Initialize an empty list to store the rotated vertices
    List<Offset> rotatedVertices = [];

    // Apply the rotation transformation to each vertex
    for (Offset vertex in vertices) {
      double x = vertex.dx;
      double y = vertex.dy;
      double xPrime = (x - x0) * cosAlpha - (y - y0) * sinAlpha + x0;
      double yPrime = (x - x0) * sinAlpha + (y - y0) * cosAlpha + y0;
      rotatedVertices.add(Offset(xPrime, yPrime));
    }

    return rotatedVertices;
  }

  List<Offset> shiftPolygon(List<Offset> vertices, Offset shift){
    List<Offset> shiftedVertices = [];
    for(Offset vertex in vertices){
      double x = vertex.dx;
      double y = vertex.dy;
      double xPrime = x + shift.dx;
      double yPrime = y + shift.dy;
      shiftedVertices.add(Offset(xPrime, yPrime));
    }
    return shiftedVertices;
  }

  double slope(Offset a, Offset b) {
    return (b.dy - a.dy) / (b.dx - a.dx);
  }
}


extension Dimensions on BuildContext{
  double width(){
    return MediaQuery.of(this).size.width;
  }

  double height(){
    return MediaQuery.of(this).size.height;
  }
}

extension Boxer on int{
  SizedBox get width => SizedBox(width: this.toDouble());
  SizedBox get height => SizedBox(height: this.toDouble());
}