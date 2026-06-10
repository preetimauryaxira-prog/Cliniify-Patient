import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';

class HealthTipsCarousel extends StatelessWidget {
  const HealthTipsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {"icon": Icons.water_drop_rounded, "title": "Hydration", "text": "Drink at least 8 glasses of water daily.", "color": Colors.blue},
      {"icon": Icons.directions_walk_rounded, "title": "Stay Active", "text": "30 mins of daily walk improves health.", "color": AppColor.green},
      {"icon": Icons.bedtime_rounded, "title": "Quality Sleep", "text": "Aim for 7-8 hours of uninterrupted rest.", "color": Colors.indigo},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Text(
            'Daily Health Tips',
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w700, 
              color: AppColor.grey, 
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 120, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              final color = tip['color'] as Color;

              return Container(
                width: 280, 
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.darkBlue.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // TODO: Route to full article or details view
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(tip['icon'] as IconData, color: color, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tip['title'] as String, 
                                  style: const TextStyle(
                                    fontSize: 15, 
                                    fontWeight: FontWeight.w700, 
                                    color: AppColor.darkBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tip['text'] as String, 
                                  style: const TextStyle(
                                    fontSize: 12, 
                                    color: AppColor.grey, 
                                    height: 1.3,
                                  ), 
                                  maxLines: 2, 
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColor.grey.withValues(alpha: 0.4),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}