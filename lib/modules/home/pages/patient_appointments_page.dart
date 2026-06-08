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
      child: SafeArea(
        child: Column(
          children: [
            _header(context),

            Expanded(
              child: apptsAsync.when(
                data: (appts) {
                  if (appts.isEmpty) {
                    return _emptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(myAppointmentsProvider.future),
                    color: AppColor.green,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: appts.length,
                      itemBuilder: (c, i) =>
                          _buildApptCard(c, appts[i]),
                    ),
                  );
                },
                loading: () => _loadingState(),
                error: (e, stack) => _errorState(e),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "My Appointments",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColor.darkBlue,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () =>
                Navigator.pushNamed(context, BookAppointmentPage.routerName),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColor.green, size: 26),
            ),
          )
        ],
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month,
                size: 60, color: AppColor.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              "No Appointments Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.darkBlue,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Book your first appointment and stay on track with your health.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOADING =================
  Widget _loadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColor.green),
    );
  }

  // ================= ERROR =================
  Widget _errorState(dynamic e) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColor.red),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildApptCard(BuildContext context, dynamic appt) {
    final date = DateTime.parse(appt['scheduled_date']);
    final isUpcoming =
        date.isAfter(DateTime.now()) && appt['status'] != 'Cancelled';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUpcoming
                ? AppColor.green.withValues(alpha: 0.25)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkBlue.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, MMM d, yyyy').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkBlue,
                  ),
                ),
                _statusBadge(appt['status'], isUpcoming),
              ],
            ),

            const SizedBox(height: 14),

            // DOCTOR INFO
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: AppColor.green),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt['doctor']['full_name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appt['procedure']['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColor.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  appt['scheduled_time'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkBlue,
                  ),
                ),
              ],
            ),

            // ACTIONS
            if (isUpcoming) ...[
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Reschedule requested")),
                      );
                    },
                    child: const Text(
                      "Reschedule",
                      style: TextStyle(
                        color: AppColor.darkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Cancellation requested")),
                      );
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  // ================= STATUS =================
  Widget _statusBadge(String status, bool isUpcoming) {
    Color bg;
    Color text;

    if (status == 'Cancelled') {
      bg = AppColor.snackBgRed;
      text = AppColor.red;
    } else if (isUpcoming) {
      bg = AppColor.snackBgGreen;
      text = AppColor.snackGreen;
    } else {
      bg = AppColor.lightGrey;
      text = AppColor.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}