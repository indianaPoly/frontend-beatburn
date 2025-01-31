import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
 final Widget mainContent;
 final EdgeInsets margin;
 
 const Indicator({
   required this.mainContent,
   this.margin = const EdgeInsets.symmetric(horizontal: 16),
 });

 static final textColors = {
   'primary': Color(0xFF6B7280),   // 차분한 회색
   'secondary': Color(0xFF9CA3AF), // 부드러운 회색
   'accent': Color(0xFF8B5CF6),    // 세련된 보라색
 };

 @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [mainContent],
      ),
    );
  }
}
