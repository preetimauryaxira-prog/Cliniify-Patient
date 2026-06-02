import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/apptheme.dart';
import '../../appointments/providers/patient_appointment_provider.dart';
import 'book_appointment_page.dart';

class PatientAppointmentsPage extends ConsumerWidget {
  const PatientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apptsAsync = ref.watch(myAppointmentsProvider);

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Appointments", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, BookAppointmentPage.routerName),
                    icon: const Icon(Icons.add_circle_outline_rounded, color: AppColor.green, size: 28),
                  )
                ],
              ),
            ),
            Expanded(
              child: apptsAsync.when(
                data: (appts) {
                  if (appts.isEmpty) {
                    return const Center(child: Text("No appointments found", style: TextStyle(color: AppColor.grey)));
                  }
                  return RefreshIndicator(
                    onRefresh: () async => ref.refresh(myAppointmentsProvider.future),
                    color: AppColor.green,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: appts.length,
                      itemBuilder: (c, i) => _buildApptCard(c, appts[i]),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColor.green)),
                error: (e, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      e.toString(), 
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColor.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApptCard(BuildContext context, dynamic appt) {
    final date = DateTime.parse(appt['scheduled_date']);
    final isUpcoming = date.isAfter(DateTime.now()) && appt['status'] != 'Cancelled';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUpcoming ? AppColor.green.withValues(alpha: 0.3) : Colors.transparent),
        boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('EEE, MMM d, yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: appt['status'] == 'Cancelled' ? AppColor.snackBgRed : (isUpcoming ? AppColor.snackBgGreen : AppColor.lightGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appt['status'],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: appt['status'] == 'Cancelled' ? AppColor.red : (isUpcoming ? AppColor.snackGreen : AppColor.grey)),
                ),
              )
            ],
          ),
          const Divider(height: 24, color: AppColor.lightGrey),
          Row(
            children: [
              const Icon(Icons.person, color: AppColor.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt['doctor']['full_name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                    Text(appt['procedure']['name'], style: const TextStyle(fontSize: 13, color: AppColor.grey)),
                  ],
                ),
              ),
              Text(appt['scheduled_time'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
            ],
          ),
          // NEW: Actions for Upcoming Appointments
          if (isUpcoming) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reschedule feature requested.")));
                    // TODO: Route to BookAppointmentPage with edit parameters
                  },
                  child: const Text("Reschedule", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cancellation request sent.")));
                  },
                  child: const Text("Cancel", style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold)),
                )
              ],
            )
          ]
        ],
      ),
    );
  }
}