import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintext;

  const SearchBarCustom({
    super.key,
    required this.controller,
    required this.onChanged, 
    required this.hintext,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(235, 2, 56, 1),
                        Color.fromRGBO(120, 50, 220, 1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: onChanged,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: hintext,
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            );
  }
}
