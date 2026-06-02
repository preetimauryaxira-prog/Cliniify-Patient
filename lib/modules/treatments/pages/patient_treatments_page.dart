import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';

class PatientTreatmentsPage extends StatelessWidget {
  const PatientTreatmentsPage({super.key});
  static const String routerName = '/treatments';

  @override
  Widget build(BuildContext context) {
    // Mocked Treatment Plans
    final activePlans = [
      {"name": "Root Canal Treatment Package", "doctor": "Dr. John Doe", "total_sessions": 3, "completed_sessions": 1, "status": "In Progress"},
      {"name": "Laser Hair Removal - 6 Sessions", "doctor": "Dr. Sarah Smith", "total_sessions": 6, "completed_sessions": 6, "status": "Completed"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Treatment Plans", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.darkBlue),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: activePlans.length,
          itemBuilder: (context, index) {
            final plan = activePlans[index];
            final int total = plan['total_sessions'] as int;
            final int completed = plan['completed_sessions'] as int;
            final double progress = completed / total;
            final isCompleted = progress >= 1.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColor.lightGrey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(plan['name'].toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.darkBlue))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: isCompleted ? AppColor.snackBgGreen : AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Text(plan['status'].toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isCompleted ? AppColor.snackGreen : AppColor.darkBlue)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Assigned by ${plan['doctor']}", style: const TextStyle(color: AppColor.grey, fontSize: 13)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Progress", style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.darkBlue)),
                      Text("$completed / $total Sessions", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.green)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColor.lightGrey,
                    color: isCompleted ? AppColor.green : AppColor.darkBlue,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
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