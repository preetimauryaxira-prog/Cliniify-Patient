import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';

class RecentActivityTimeline extends StatelessWidget {
  const RecentActivityTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    // Moved the data to a realistic state simulation. 
    // Added a color property to give different activity types semantic meaning.
    final activities = [
      {
        "title": "Visited Dr. Sarah Smith", 
        "subtitle": "General Checkup", 
        "time": "2 days ago", 
        "icon": Icons.medical_services_rounded,
        "color": AppColor.darkBlue,
      },
      {
        "title": "Prescription Added", 
        "subtitle": "Paracetamol 500mg • 2x Daily", 
        "time": "2 days ago", 
        "icon": Icons.medication_rounded,
        "color": AppColor.green,
      },
      {
        "title": "Lab Results Ready", 
        "subtitle": "Complete Blood Count (CBC)", 
        "time": "1 week ago", 
        "icon": Icons.science_rounded,
        "color": const Color(0xFFF59E0B), // Semantic warning/amber for alerts or labs
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w800, 
              color: AppColor.darkBlue, 
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Use List.generate to easily identify the last item (to hide the final connecting line)
        ...List.generate(activities.length, (index) {
          final act = activities[index];
          final bool isLast = index == activities.length - 1;
          final Color itemColor = act['color'] as Color;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. The Timeline Track (Node + Connecting Line)
                Column(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: itemColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: itemColor.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: Icon(act['icon'] as IconData, color: itemColor, size: 20),
                    ),
                    // Draw the connecting line only if it's not the last item
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 50, // Height of the gap between nodes
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // 2. The Activity Content Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16), // Space below the card
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.darkBlue.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                act['title'] as String, 
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700, 
                                  fontSize: 15, 
                                  color: AppColor.darkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              act['time'] as String, 
                              style: const TextStyle(
                                fontSize: 11, 
                                color: AppColor.grey, 
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          act['subtitle'] as String, 
                          style: const TextStyle(
                            fontSize: 13, 
                            color: AppColor.grey, 
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}