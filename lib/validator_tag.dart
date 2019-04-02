import 'package:flutter/material.dart';

class ValidatorTag extends StatelessWidget {
  ValidatorTag({this.pass, this.message});

  final String message;
  final bool pass;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: _CrossFadeChild(text: message,color: Colors.transparent,),
      secondChild: _CrossFadeChild(text: message, color: Colors.red),
      duration: Duration(milliseconds: 300),
      crossFadeState: pass == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      alignment: AlignmentDirectional.centerStart,
    );
  }
}

class _CrossFadeChild extends StatelessWidget {
  _CrossFadeChild({this.text, this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}
