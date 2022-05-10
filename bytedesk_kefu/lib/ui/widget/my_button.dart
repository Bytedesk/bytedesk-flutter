import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    this.text = '',
    @required this.onPressed,
  }) : super(key: key);

  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton( // FlatButton
        onPressed: onPressed,
        // textColor: Colors.white,
        child: Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              text!,
              style: TextStyle(
                fontSize: 18,
              ),
            )));
  }
}
