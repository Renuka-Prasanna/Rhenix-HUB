import "package:flutter/material.dart";

class TopSplashWidget extends StatelessWidget {
  final String imagePath;
  const TopSplashWidget({Key? key, required this.imagePath}) : super(key: key);
  static const Radius borderRadius = Radius.circular(20);
  static const double containerHeight = 0.12;
  static const double circleAvatarRadius = 0.08;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * containerHeight) + (MediaQuery.of(context).size.height * circleAvatarRadius),
      color: Colors.white,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * containerHeight,
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height * containerHeight) - (MediaQuery.of(context).size.height * circleAvatarRadius),
          left: (MediaQuery.of(context).size.width / 2) - (MediaQuery.of(context).size.height * circleAvatarRadius),
          child: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.white,
            radius: (MediaQuery.of(context).size.height * circleAvatarRadius),
          ),
        )
      ]),
    );
  }
}
