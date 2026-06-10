import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final VoidCallback? onTap;

  const UpcomingAppointmentCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap ?? () {}, // Ensure the card provides touch feedback
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_month_rounded, color: AppColor.green, size: 16),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Upcoming Visit",
                          style: TextStyle(color: AppColor.darkBlue, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.green.withValues(alpha: 0.1), 
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColor.green.withValues(alpha: 0.2)),
                      ),
                      child: const Text("Confirmed", style: TextStyle(color: AppColor.green, fontSize: 11, fontWeight: FontWeight.w800)),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                
                // 2. Doctor Info Row
                Row(
                  children: [
                    // Doctor Avatar Placeholder
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: AppColor.welcomeBgColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.lightGrey, width: 1),
                      ),
                      // Replace Icon with CachedNetworkImage when you have the doctor's photo
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: AppColor.grey, size: 28),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dr. Sarah Smith", style: TextStyle(color: AppColor.darkBlue, fontSize: 18, fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text("General Checkup • City Care Clinic", style: TextStyle(color: AppColor.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // 3. Date & Time Footer Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.welcomeBgColor, // Very light tinted background separates logistics from details
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.access_time_filled_rounded, color: AppColor.darkBlue, size: 18),
                          SizedBox(width: 8),
                          Text("Tomorrow, 10:30 AM", style: TextStyle(color: AppColor.darkBlue, fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColor.darkBlue),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}