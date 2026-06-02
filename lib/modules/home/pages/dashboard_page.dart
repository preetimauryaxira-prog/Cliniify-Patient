import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../billing/pages/patient_billing_page.dart';
import '../../gallery/pages/clinic_gallery_page.dart';
import '../../notification/pages/notifications_page.dart';
import '../../profile/pages/patient_profile_page.dart';
import '../../records/pages/patient_records_page.dart';
import '../../treatments/pages/patient_treatments_page.dart';
import 'book_appointment_page.dart';
import 'patient_appointments_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const String routerName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeTab(),
    const PatientAppointmentsPage(),
    const PatientRecordsPage(),
    const PatientProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.1), blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.white,
          selectedItemColor: AppColor.green,
          unselectedItemColor: AppColor.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_shared_rounded), label: 'Records'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// --- HOME TAB VIEW ---
class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinic = HiveUser.getSelectedClinic();
    
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // Header with White-label Clinic Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello,", style: TextStyle(fontSize: 16, color: AppColor.grey)),
                    Text("Your Health Portal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                  ],
                ),
                Row(
                  children: [
                    // Bell Icon for Notifications
                    IconButton(
                      icon: const Icon(Icons.notifications_active_rounded, color: AppColor.darkBlue),
                      onPressed: () => Navigator.pushNamed(context, NotificationsPage.routerName),
                    ),
                    if (clinic != null && clinic['logo'] != null)
                      const SizedBox(
                        height: 40, width: 40, // ... Your existing logo code
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Quick Action: Book Appointment
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, BookAppointmentPage.routerName),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.green,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColor.green.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColor.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, color: AppColor.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Book Appointment", style: TextStyle(color: AppColor.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Schedule a visit with your doctor", style: TextStyle(color: AppColor.white, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Quick Links Grid
            const Text("Quick Access", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    _buildQuickCard(Icons.receipt_long_rounded, "My Bills", AppColor.darkBlue, () => Navigator.pushNamed(context, '/billing')),
                    const SizedBox(width: 12),
                    _buildQuickCard(Icons.medical_information_rounded, "Prescriptions", AppColor.green, () { /* Switch bottom nav to records */ }),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuickCard(Icons.assignment_rounded, "Treatments", AppColor.lightNavColor, () => Navigator.pushNamed(context, PatientTreatmentsPage.routerName)),
                    const SizedBox(width: 12),
                    _buildQuickCard(Icons.photo_library_rounded, "Gallery", const Color(0xFFF59E0B), () => Navigator.pushNamed(context, ClinicGalleryPage.routerName)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColor.darkBlue)),
            ],
          ),
        ),
      ),
    );
  }
}