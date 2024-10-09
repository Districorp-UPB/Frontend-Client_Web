import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  final String texto;
  final IconData icono;
  final void Function()? onTap;
  final bool selected;
  final Color? color;

  const DrawerTile({
    super.key,
    required this.size,
    required this.texto,
    required this.icono,
    this.onTap,
    required this.selected, 
    required this.color,
  });

  final Size size;

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final shortestSide  = MediaQuery.of(context).size.shortestSide ;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
            _isHovered = true;
          });
      },
      onExit: (_) {
        setState(() {
            _isHovered = false;
          });
      },
      child: ListTile(
        leading: Icon(
          widget.icono,
          size: widget.size.height * 0.04,
        ),
        selected: widget.selected,
        selectedColor: widget.color,
        textColor: _isHovered ? Colors.amber : Colors.white,
        iconColor: _isHovered ? Colors.amber : Colors.white,
        title: screenWidth > 1000 ? Text(
          widget.texto,
          style: TextStyle(fontSize: shortestSide  * 0.02, overflow: TextOverflow.clip),
        ) : null, // Asigna null para ocultar el texto
        onTap: widget.onTap,
      ),
    );
  }
}