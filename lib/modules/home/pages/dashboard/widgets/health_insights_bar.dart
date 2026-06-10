import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';

class HealthInsightsBar extends StatelessWidget {
  const HealthInsightsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final insights = [
      {"title": "Last Visit", "value": "2 Days Ago", "icon": Icons.history_rounded, "color": AppColor.darkBlue},
      {"title": "Next Checkup", "value": "Dental", "icon": Icons.health_and_safety_rounded, "color": AppColor.green},
      {"title": "Active Meds", "value": "2 Active", "icon": Icons.medication_liquid_rounded, "color": const Color(0xFFF59E0B)},
    ];

    return SizedBox(
      height: 84,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final item = insights[index];
          return Container(
            width: 142,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(item['icon'] as IconData, size: 14, color: item['color'] as Color),
                    const SizedBox(width: 6),
                    Text(item['title'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColor.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item['value'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
              ],
            ),
          );
        },
      ),
    );
  }
}