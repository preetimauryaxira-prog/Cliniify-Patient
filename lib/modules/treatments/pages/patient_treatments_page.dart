import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';

class PatientTreatmentsPage extends StatelessWidget {
  const PatientTreatmentsPage({super.key});
  static const String routerName = '/treatments';

  @override
  Widget build(BuildContext context) {
    // Mocked Treatment Plans with added semantic icons
    final activePlans = [
      {
        "name": "Root Canal Treatment", 
        "doctor": "Dr. John Doe", 
        "total_sessions": 3, 
        "completed_sessions": 1, 
        "status": "In Progress",
        "icon": Icons.medical_services_rounded,
      },
      {
        "name": "Laser Hair Removal", 
        "doctor": "Dr. Sarah Smith", 
        "total_sessions": 6, 
        "completed_sessions": 6, 
        "status": "Completed",
        "icon": Icons.healing_rounded,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.globalBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Treatment Plans", 
            style: TextStyle(
              fontSize: 22, 
              color: AppColor.darkBlue, 
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColor.darkBlue),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 40),
          itemCount: activePlans.length,
          itemBuilder: (context, index) {
            final plan = activePlans[index];
            final int total = plan['total_sessions'] as int;
            final int completed = plan['completed_sessions'] as int;
            final double progress = completed / total;
            final bool isCompleted = progress >= 1.0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.white, 
                borderRadius: BorderRadius.circular(24), 
                boxShadow: [
                  BoxShadow(
                    color: AppColor.darkBlue.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColor.green.withValues(alpha: 0.1) : AppColor.welcomeBgColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          plan['icon'] as IconData? ?? Icons.assignment_rounded, 
                          color: isCompleted ? AppColor.green : AppColor.darkBlue, 
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['name'].toString(), 
                              style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w800, 
                                color: AppColor.darkBlue, 
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Assigned by ${plan['doctor']}", 
                              style: const TextStyle(
                                color: AppColor.grey, 
                                fontSize: 13, 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColor.green.withValues(alpha: 0.1) : AppColor.darkBlue.withValues(alpha: 0.05), 
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          plan['status'].toString().toUpperCase(), 
                          style: TextStyle(
                            fontSize: 10, 
                            fontWeight: FontWeight.w900, 
                            color: isCompleted ? AppColor.green : AppColor.darkBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        "$completed of $total Sessions", 
                        style: TextStyle(
                          fontWeight: FontWeight.w700, 
                          fontSize: 13,
                          color: isCompleted ? AppColor.green : AppColor.darkBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColor.welcomeBgColor,
                      color: isCompleted ? AppColor.green : AppColor.darkBlue,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}