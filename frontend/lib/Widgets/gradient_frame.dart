import 'package:flutter/material.dart';

class GradientCircleAvatar extends StatelessWidget {
  final String image;
  final double radius;
  final bool showFrame;
  final double frameThickness;
  final Color backgroundColor;

  GradientCircleAvatar({this.image,this.backgroundColor, this.radius, this.frameThickness = 2.0, this.showFrame = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(frameThickness),
      decoration: showFrame != null ??
      showFrame ? BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Colors.yellow,Colors.pinkAccent])
        ) : null,
      child: Container(
        padding: EdgeInsets.all(frameThickness),
        decoration: BoxDecoration(color: backgroundColor,shape: BoxShape.circle),
        child: CircleAvatar(backgroundImage: NetworkImage(image),radius: radius)),
    );
  }
}