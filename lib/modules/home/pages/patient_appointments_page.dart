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
      decoration: BoxDecoration(
        gradient: AppTheme.globalBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let the gradient shine through
        body: SafeArea(
          bottom: false, // Prevent clipping behind the nav bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: apptsAsync.when(
                  data: (appts) {
                    if (appts.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async =>
                          ref.refresh(myAppointmentsProvider.future),
                      color: AppColor.green,
                      backgroundColor: AppColor.white,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        // Bottom padding ensures the last card sits above the custom floating nav bar
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 100),
                        itemCount: appts.length,
                        itemBuilder: (c, i) => _buildApptCard(c, appts[i]),
                      ),
                    );
                  },
                  loading: () => _buildLoadingState(),
                  error: (e, stack) => _buildErrorState(e),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Appointments",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColor.darkBlue,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Manage your schedule",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.grey,
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pushNamed(context, BookAppointmentPage.routerName),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.green,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.green.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add_rounded, color: AppColor.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Book New",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColor.welcomeBgColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_busy_rounded, size: 50, color: AppColor.green),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Appointments Yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColor.darkBlue,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Book your first appointment and stay on track with your health journey.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOADING =================
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColor.green, strokeWidth: 3),
    );
  }

  // ================= ERROR =================
  Widget _buildErrorState(dynamic e) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColor.red, size: 40),
            const SizedBox(height: 16),
            const Text(
              "Unable to load appointments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.darkBlue),
            ),
            const SizedBox(height: 8),
            Text(
              e.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColor.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildApptCard(BuildContext context, dynamic appt) {
    final date = DateTime.parse(appt['scheduled_date']);
    final isUpcoming = date.isAfter(DateTime.now()) && appt['status'] != 'Cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24), // Softer, more modern radius
        border: Border.all(
          color: isUpcoming ? AppColor.green.withValues(alpha: 0.3) : AppColor.lightGrey.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: Date, Time & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d, yyyy').format(date),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: AppColor.grey),
                        const SizedBox(width: 4),
                        Text(
                          appt['scheduled_time'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _statusBadge(appt['status'], isUpcoming),
            ],
          ),

          const SizedBox(height: 20),

          // DOCTOR INFO
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.welcomeBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.medical_services_rounded, color: AppColor.green, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt['doctor']['full_name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appt['procedure']['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ACTIONS (Only for upcoming)
          if (isUpcoming) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1, color: AppColor.welcomeBgColor, thickness: 1.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // De-emphasized Destructive Action
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cancellation requested")),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Cancel Visit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                
                // Emphasized Primary Action
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.green,
                    side: const BorderSide(color: AppColor.green, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reschedule requested")),
                    );
                  },
                  child: const Text(
                    "Reschedule",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                )
              ],
            )
          ]
        ],
      ),
    );
  }

  // ================= STATUS =================
  Widget _statusBadge(String status, bool isUpcoming) {
    Color bg;
    Color text;

    if (status == 'Cancelled') {
      bg = AppColor.red.withValues(alpha: 0.1);
      text = AppColor.red;
    } else if (isUpcoming) {
      bg = AppColor.green.withValues(alpha: 0.1);
      text = AppColor.green;
    } else {
      bg = AppColor.grey.withValues(alpha: 0.1);
      text = AppColor.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: text,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}