import 'package:districorp/constant/images.dart';
import 'package:flutter/material.dart';

class GradientAppBarTotal extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color titleColor;
  final List<Widget>? actions; // Add the actions parameter
  final bool implyLeading;

  const GradientAppBarTotal({
    super.key, 
    this.title,
    this.titleColor = Colors.white,
    this.actions, // Initialize the actions parameter
    required this.implyLeading, 
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: implyLeading,
      
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            cLogoLateral,
            height: 62.595 //size.height * 0.065
          ),
          title != null ? GestureDetector(
            onTap: (){
              print(size.height);
            },
            child: Text(
              title!,
              style: TextStyle(color: titleColor, fontSize: 21),
            ),
          ) :
          Text("")
        ],
      ),

      actions: actions, // Use the actions in the AppBar

      iconTheme: IconThemeData(color: titleColor),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(235, 2, 56, 1)
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
