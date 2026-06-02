import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const String routerName = '/notifications';

  @override
  Widget build(BuildContext context) {
    // Mocked Notification Data
    final notifications = [
      {"title": "Appointment Reminder", "body": "Your appointment with Dr. Sarah is tomorrow at 10:30 AM.", "type": "appointment", "time": "2 hours ago"},
      {"title": "Payment Confirmed", "body": "We received your payment of ₹850.00 for INV-2023-1002.", "type": "payment", "time": "1 day ago"},
      {"title": "Follow-up Reminder", "body": "It's time for your 6-month dental checkup. Book now!", "type": "followup", "time": "3 days ago"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.darkBlue),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            IconData icon;
            Color color;

            if (notif['type'] == 'appointment') { icon = Icons.calendar_month; color = AppColor.darkBlue; }
            else if (notif['type'] == 'payment') { icon = Icons.check_circle; color = AppColor.green; }
            else { icon = Icons.notifications_active; color = AppColor.red; }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10)]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.darkBlue)),
                        const SizedBox(height: 4),
                        Text(notif['body']!, style: const TextStyle(color: AppColor.grey, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text(notif['time']!, style: const TextStyle(color: AppColor.lightNavColor, fontSize: 11)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}