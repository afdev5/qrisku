import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class CustomRollingSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  // final String textOff;
  // final String textOn;
  final Color colorOn;
  final Color colorOff;
  // final double textSize;
  final Duration animationDuration;
  final IconData iconOn;
  final IconData iconOff;
  final Function(bool)? onTap;
  final Function()? onDoubleTap;
  final Function()? onSwipe;

  CustomRollingSwitch({
    this.value = false,
    // this.textOff = 'Off',
    // this.textOn = 'On',
    // this.textSize = 14.0,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff = Icons.flag,
    this.iconOn = Icons.check,
    this.animationDuration = const Duration(milliseconds: 600),
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    required this.onChanged,
  });

  @override
  _CustomRollingSwitchState createState() => _CustomRollingSwitchState();
}

class _CustomRollingSwitchState extends State<CustomRollingSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double value = 0.0;

  late bool turnState;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    var transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap!;
      },
      onTap: () {
        _action();
        widget.onTap;
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe!;
        //widget.onSwipe();
      },
      child: Container(
        padding: EdgeInsets.all(4),
        width: 50,
        height: 25,
        decoration: BoxDecoration(
            color: transitionColor, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: <Widget>[
            // IF widget need Text
            // Transform.translate(
            //   offset: Offset(10 * value, 0), //original
            //   child: Opacity(
            //     opacity: (1 - value).clamp(0.0, 1.0),
            //     child: Container(
            //       padding: EdgeInsets.only(right: 10),
            //       alignment: Alignment.centerRight,
            //       height: 40,
            //       child: Text(
            //         widget.textOff,
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: widget.textSize),
            //       ),
            //     ),
            //   ),
            // ),
            // Transform.translate(
            //   offset: Offset(10 * (1 - value), 0), //original
            //   child: Opacity(
            //     opacity: value.clamp(0.0, 1.0),
            //     child: Container(
            //       padding: EdgeInsets.only(/*top: 10,*/ left: 5),
            //       alignment: Alignment.centerLeft,
            //       height: 40,
            //       child: Text(
            //         widget.textOn,
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: widget.textSize),
            //       ),
            //     ),
            //   ),
            // ),
            Transform.translate(
              offset: Offset(22 * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value)!,
                child: Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: Icon(
                            widget.iconOff,
                            size: 12,
                            color: transitionColor,
                          ),
                        ),
                      ),
                      Center(
                          child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Icon(
                                widget.iconOn,
                                size: 12,
                                color: transitionColor,
                              ))),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _action() {
    _determineAction(changeState: true);
  }

  void _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();
    });
  }

  void _determineAction({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

      widget.onChanged(turnState);
    });
  }
}
