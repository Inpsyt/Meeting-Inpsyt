import 'package:flutter/material.dart';
import 'package:inpsyt_meeting/constants/const_colors.dart';

class DiamondBorder extends ShapeBorder {
  const DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close()
    ;
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class GradientButton extends StatefulWidget {

  final double height;
  final double width;
  final double padding;
  final Widget child;
  final Color gradientStart;
  final Color gradientEnd ;
  final Function onPressed;

  GradientButton(this.child,this.gradientStart,this.gradientEnd,this.height,this.width,this.padding,this.onPressed);

  @override
  _GradientButtonState createState() => _GradientButtonState( this.child,this.gradientStart,this.gradientEnd,this.height,width,this.padding,this.onPressed);
}

class _GradientButtonState extends State<GradientButton> {

  final double height;
  final double width;
  final double padding;
  final Widget child;
  final Color gradientStart;
  final Color gradientEnd ;
  final Function onPressed;

  _GradientButtonState(this.child,this.gradientStart,this.gradientEnd,this.height,this.width,this.padding,this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: this.onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: width, minHeight: height),
            alignment: Alignment.center,
            child:child
          ),
        ),
      ),
    );
  }
}
