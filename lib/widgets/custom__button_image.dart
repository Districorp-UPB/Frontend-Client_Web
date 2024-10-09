import 'package:flutter/material.dart';

class CustomImageButton extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onPressed;
  final String tooltip;

  const CustomImageButton({
    Key? key,
    required this.imageUrl,
    required this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  _CustomImageButtonState createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton> {

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Tooltip(
          message: widget.tooltip,
          child: Image.asset(
            widget.imageUrl,
            width: 80,
            height: 80,
            
          ),
        ),
      ),
    );
  }
}
