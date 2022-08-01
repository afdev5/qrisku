import 'package:flutter/material.dart';

class CardBackgroundWithTextDot extends StatelessWidget {
  final String title;
  final double width;
  final double? height;
  final Widget widget;
  final Color backgroundContainer;
  final Color backgroundHeaderText;
  final Color borderColor;
  final Color textBorderColor;
  final Color dotColor;
  final EdgeInsets padding;

  CardBackgroundWithTextDot({
    required this.title,
    required this.widget,
    this.height,
    this.width = double.infinity,
    this.backgroundContainer = Colors.white,
    this.backgroundHeaderText = Colors.white,
    this.borderColor = Colors.black,
    this.textBorderColor = Colors.black,
    this.dotColor = Colors.black,
    this.padding = const EdgeInsets.fromLTRB(0, 12, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
              color: backgroundContainer,
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: widget,
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: Container(
              color: backgroundHeaderText,
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 2),
                  Icon(
                    Icons.circle,
                    size: 11,
                    color: dotColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    title,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
