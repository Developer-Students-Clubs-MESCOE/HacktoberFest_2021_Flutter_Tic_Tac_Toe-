import 'package:flutter/material.dart';

class CustomGradient {
  static final Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFECD2),  // Start color
      Color(0xFFFCB69F),  // End color
    ],
  );
  static final Gradient secondGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA9F1DF),  // Start color
      Color(0xFF0FBBBB),  // End color
    ],
  );


}



