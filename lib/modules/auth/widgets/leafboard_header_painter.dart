import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../utils/apptheme.dart';

class LeafboardHeaderPainter extends CustomPainter {
  const LeafboardHeaderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = ui.PaintingStyle.fill;

    // CHANGED: Configured the linear gradient vector to run diagonally
    // from top-left (0, 0) to bottom-right (size.width, size.height)
    paint.shader = ui.Gradient.linear(
      Offset(size.width, 0),     // Start point (Top-Right)
      Offset(0, size.height),    // End point (Bottom-Left)
      [
        // 1. Core start color
        AppColor.darkBlue.withValues(alpha: 0.9), 
        
        // 2. Interstitial transition color (softens the dark-to-light shift)
        AppColor.darkBlue.withValues(alpha: 0.8),  
        
        // 3. Main accent color mid-point
        AppColor.green.withValues(alpha: 0.7),     
        
        // 4. Smooth terminating color anchor
        AppColor.green.withValues(alpha: 0.6),      
      ],
      // Proportional stops spacing giving colors room to blend
      [0.0, 0.2, 0.6, 1.0], 
    );

    final Path path = Path();
    path.lineTo(0, size.height * 0.65);
    
    // Smooth custom wave sweeping downwards into an elegant anchor cup
    path.cubicTo(
      size.width * 0.25, size.height,
      size.width * 0.75, size.height,
      size.width, size.height * 1.15,
    );
    
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}