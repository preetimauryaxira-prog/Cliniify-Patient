import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    // 1. Calculate Safe Active Area
    final double barWidth = size.width - 32; // Total width of the painted bar
    const double horizontalPadding = 16.0; // Pushes outer tabs inward to avoid corner radius collision
    final double activeWidth = barWidth - (horizontalPadding * 2);
    
    const int totalItems = 4; 
    final double itemWidth = activeWidth / totalItems;
    
    // Target position guarantees the cutout stays on the flat top edge
    final double targetCenterPosition = horizontalPadding + (currentIndex * itemWidth) + (itemWidth / 2);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: targetCenterPosition, end: targetCenterPosition),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        builder: (context, animatedCenter, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Bar
              CustomPaint(
                size: Size(barWidth, 70),
                painter: NavCustomPainter(
                  curveCenter: animatedCenter,
                  backgroundColor: AppColor.white,
                  shadowColor: AppColor.darkBlue.withValues(alpha: 0.4),
                  borderColor: AppColor.black.withValues(alpha: 0.2),
                ),
              ),
              
              // Floating Selected Icon Circle
              Positioned(
                left: animatedCenter - 26, // Follows animated curve tick
                top: -18, 
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.darkBlue.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: AppColor.black.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        _getIconForIndex(currentIndex),
                        key: ValueKey<int>(currentIndex),
                        color: AppColor.green, 
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

              // Transparent Touch Layer
              SizedBox(
                 height: 68,
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                   child: Row(
                     children: [
                       _buildTabItem(0, Icons.home_rounded, 'Home'),
                       _buildTabItem(1, Icons.calendar_month_rounded, 'Schedule'),
                       _buildTabItem(2, Icons.folder_shared_rounded, 'Records'),
                       _buildTabItem(3, Icons.person_rounded, 'Profile'),
                     ],
                   ),
                 ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 0.0 : 1.0,
              child: Icon(
                icon,
                color: AppColor.darkBlue,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.green : AppColor.darkBlue,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10), 
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.calendar_month_rounded;
      case 2: return Icons.folder_shared_rounded;
      case 3: return Icons.person_rounded;
      default: return Icons.home_rounded;
    }
  }
}

class NavCustomPainter extends CustomPainter {
  final double curveCenter;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;

  NavCustomPainter({
    required this.curveCenter,
    required this.backgroundColor,
    required this.shadowColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Softened to 22 to leave ample flat space for the cutout to rest on
    const double radius = 25; 

    // 1. Create a perfectly smooth rounded rectangle base
    final Path baseBarPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    // 2. Create the precise cutout notch path
    final Path cutoutPath = Path();
    
    // Start safely above the bar to create a clean cutting mask
    cutoutPath.moveTo(curveCenter - 38, -20);
    cutoutPath.lineTo(curveCenter - 38, 0); 

    cutoutPath.cubicTo(
      curveCenter - 22, 0,
      curveCenter - 20, 26, // Pulled slightly deeper to wrap the circle beautifully
      curveCenter, 26,
    );

    cutoutPath.cubicTo(
      curveCenter + 20, 26,
      curveCenter + 22, 0,
      curveCenter + 38, 0,
    );

    cutoutPath.lineTo(curveCenter + 38, -20); // Return above the bar
    cutoutPath.close(); // Close the mask shape

    // 3. Subtract the cutout mask from the base bar
    final Path finalPath = Path.combine(
      PathOperation.difference,
      baseBarPath,
      cutoutPath,
    );

    // 4. Draw ambient shadow
    canvas.drawPath(
      finalPath,
      Paint()
        ..color = shadowColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // 5. Fill the final combined shape
    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = ui.PaintingStyle.fill;
    canvas.drawPath(finalPath, fillPaint);

    // 6. Stroke the final combined shape for contrast
    final Paint strokePaint = Paint()
      ..color = borderColor
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawPath(finalPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant NavCustomPainter oldDelegate) {
    return oldDelegate.curveCenter != curveCenter ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.borderColor != borderColor;
  }
}