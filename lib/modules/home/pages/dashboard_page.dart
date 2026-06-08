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
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.darkBlue.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.white,
          selectedItemColor: AppColor.green,
          unselectedItemColor: AppColor.grey.withValues(alpha: 0.5),
          showUnselectedLabels: true,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, height: 1.5),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, height: 1.5),
          items: const [
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 6), child: Icon(Icons.space_dashboard_rounded)), label: 'Home'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 6), child: Icon(Icons.calendar_month_rounded)), label: 'Schedule'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 6), child: Icon(Icons.folder_shared_rounded)), label: 'Records'),
            BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 6), child: Icon(Icons.person_rounded)), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends ConsumerStatefulWidget {
  const _HomeTab();

  @override
  ConsumerState<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<_HomeTab> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _switchClinic(Map<String, dynamic> selectedClinic) {
    HiveUser.saveSelectedClinic(selectedClinic);
    setState(() {}); // Rebuild to show new clinic logo and name
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Switched to ${selectedClinic['name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColor.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showClinicSelectionSheet() {
    final clinics = HiveUser.getAllClinics();
    final currentClinic = HiveUser.getSelectedClinic();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Select Clinic",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                "Choose a clinic to view specific records and book appointments.",
                style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              if (clinics.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No clinics found.", style: TextStyle(color: AppColor.grey)),
                )
              else
                ...clinics.map((clinicMap) {
                  final clinic = Map<String, dynamic>.from(clinicMap);
                  final isActive = currentClinic?['id'] == clinic['id'];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: isActive ? AppColor.green.withValues(alpha: 0.05) : AppColor.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: isActive ? null : () => _switchClinic(clinic),
                        borderRadius: BorderRadius.circular(20),
                        splashColor: AppColor.green.withValues(alpha: 0.1),
                        highlightColor: AppColor.green.withValues(alpha: 0.05),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isActive ? AppColor.green.withValues(alpha: 0.5) : AppColor.lightGrey.withValues(alpha: 0.6), width: isActive ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: AppColor.welcomeBgColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColor.lightGrey),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: clinic['logo'] ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.green)),
                                    errorWidget: (context, url, error) => const Icon(Icons.local_hospital, color: AppColor.green),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  clinic['name'] ?? 'Unknown Clinic',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: isActive ? AppColor.green : AppColor.darkBlue),
                                ),
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: AppColor.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                                  child: const Icon(Icons.check_circle_rounded, color: AppColor.green, size: 24),
                                )
                              else
                                const Icon(Icons.arrow_forward_ios_rounded, color: AppColor.grey, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinic = HiveUser.getSelectedClinic();
    final activePatient = HiveUser.getActivePatient();
    final String patientName = activePatient?['full_name'] ?? activePatient?['name'] ?? 'Preeti';
    
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHeader(clinic, patientName),
            const SizedBox(height: 24),
            _buildHealthInsights(),
            const SizedBox(height: 24),
            _buildUpcomingAppointmentCard(),
            const SizedBox(height: 32),
            _buildQuickActionBook(),
            const SizedBox(height: 32),
            _buildQuickAccessSection(),
            const SizedBox(height: 32),
            _buildHealthTipsBanner(),
            const SizedBox(height: 32),
            _buildRecentActivityTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Map<dynamic, dynamic>? clinic, String patientName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.green.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(), 
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColor.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  patientName, 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // PREMIUM CLINIC SELECTOR CHIP
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showClinicSelectionSheet,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.green.withValues(alpha: 0.3)),
                        boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_rounded, size: 14, color: AppColor.green),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              clinic?['name'] ?? 'Select Clinic',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColor.darkBlue),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColor.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  border: Border.all(color: AppColor.white, width: 2),
                ),
                child: Stack(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pushNamed(context, NotificationsPage.routerName),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.notifications_outlined, color: AppColor.darkBlue, size: 24),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        height: 10, width: 10,
                        decoration: BoxDecoration(color: AppColor.red, shape: BoxShape.circle, border: Border.all(color: AppColor.white, width: 2)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showClinicSelectionSheet,
                child: Container(
                  height: 48, width: 48,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppColor.green.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                    border: Border.all(color: AppColor.white, width: 2),
                  ),
                  child: clinic != null && clinic['logo'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: clinic['logo'],
                            fit: BoxFit.cover,
                            placeholder: (c, u) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.green)),
                            errorWidget: (c, u, e) => const Icon(Icons.local_hospital, color: AppColor.green),
                          ),
                        )
                      : const Icon(Icons.local_hospital, color: AppColor.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInsights() {
    final insights = [
      {"title": "Last Visit", "value": "2 Days Ago", "icon": Icons.history_rounded, "color": AppColor.darkBlue},
      {"title": "Next Checkup", "value": "Dental", "icon": Icons.health_and_safety_rounded, "color": AppColor.green},
      {"title": "Active Meds", "value": "2 Prescribed", "icon": Icons.medication_liquid_rounded, "color": const Color(0xFFF59E0B)},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final item = insights[index];
          final color = item['color'] as Color;
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              border: Border.all(color: AppColor.lightGrey, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(item['icon'] as IconData, size: 16, color: color),
                    const SizedBox(width: 6),
                    Text(item['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['value'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard() {
    const bool hasUpcoming = true;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [AppColor.darkBlue, Color(0xFF192F5D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            if (!hasUpcoming)
              // ignore: dead_code
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColor.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.event_available_rounded, color: AppColor.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text("Upcoming Appointment", style: TextStyle(color: AppColor.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("No upcoming visits", style: TextStyle(color: AppColor.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 6),
                    Text("Your schedule is clear right now.", style: TextStyle(color: AppColor.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColor.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.calendar_month_rounded, color: AppColor.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Text("Upcoming Appointment", style: TextStyle(color: AppColor.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColor.green.withValues(alpha: 0.2), 
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColor.green.withValues(alpha: 0.5)),
                          ),
                          child: const Text("Confirmed", style: TextStyle(color: AppColor.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Dr. Sarah Smith", style: TextStyle(color: AppColor.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 4),
                    Text("General Checkup • City Care Clinic", style: TextStyle(color: AppColor.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_filled_rounded, color: AppColor.white, size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tomorrow", style: TextStyle(color: AppColor.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text("10:30 AM", style: TextStyle(color: AppColor.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              final state = context.findAncestorStateOfType<_DashboardPageState>();
                              state?.setState(() => state._currentIndex = 1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(12)),
                              child: const Text("View Details", style: TextStyle(color: AppColor.darkBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBook() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColor.green, Color(0xFF10B981)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: AppColor.green.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, BookAppointmentPage.routerName),
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColor.white.withValues(alpha: 0.2),
            highlightColor: AppColor.white.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColor.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Book Appointment", style: TextStyle(color: AppColor.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text("Schedule a visit with your doctor", style: TextStyle(color: AppColor.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColor.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_rounded, color: AppColor.green, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  _buildPremiumGridCard(
                    Icons.receipt_long_rounded, 
                    "My Bills", 
                    "View & Pay", 
                    AppColor.darkBlue, 
                    () => Navigator.pushNamed(context, PatientBillingPage.routerName)
                  ),
                  const SizedBox(width: 16),
                  _buildPremiumGridCard(
                    Icons.medical_information_rounded, 
                    "Prescriptions", 
                    "Active Meds", 
                    AppColor.green, 
                    () {
                      final state = context.findAncestorStateOfType<_DashboardPageState>();
                      state?.setState(() => state._currentIndex = 2);
                    }
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildPremiumGridCard(
                    Icons.assignment_rounded, 
                    "Treatments", 
                    "Ongoing Plans", 
                    AppColor.lightNavColor, 
                    () => Navigator.pushNamed(context, PatientTreatmentsPage.routerName)
                  ),
                  const SizedBox(width: 16),
                  _buildPremiumGridCard(
                    Icons.photo_library_rounded, 
                    "Gallery", 
                    "Clinic Photos", 
                    const Color(0xFFF59E0B), 
                    () => Navigator.pushNamed(context, ClinicGalleryPage.routerName)
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumGridCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColor.white,
          boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
          border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: color.withValues(alpha: 0.05),
            highlightColor: color.withValues(alpha: 0.02),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColor.darkBlue)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColor.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthTipsBanner() {
    final tips = [
      {"icon": Icons.water_drop_rounded, "title": "Hydration", "text": "Drink at least 8 glasses of water daily.", "color": Colors.blue},
      {"icon": Icons.favorite_rounded, "title": "Heart Health", "text": "Regular checkups prevent critical issues.", "color": AppColor.red},
      {"icon": Icons.directions_walk_rounded, "title": "Stay Active", "text": "30 mins of daily walk improves health.", "color": AppColor.green},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text("Health Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
                  border: Border.all(color: AppColor.lightGrey, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: (tip['color'] as Color).withValues(alpha: 0.1), 
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(tip['icon'] as IconData, color: tip['color'] as Color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tip['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
                          const SizedBox(height: 6),
                          Text(
                            tip['text'] as String,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityTimeline() {
    final activities = [
      {"title": "Visited Dr. Sharma", "subtitle": "General Checkup", "time": "2 days ago", "icon": Icons.medical_services_rounded, "color": AppColor.darkBlue},
      {"title": "Prescription Added", "subtitle": "Paracetamol 500mg", "time": "2 days ago", "icon": Icons.medication_rounded, "color": AppColor.green},
      {"title": "Bill Generated", "subtitle": "INV-2023-1002", "time": "5 days ago", "icon": Icons.receipt_rounded, "color": AppColor.lightNavColor},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
              Text("View All", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.green)),
            ],
          ),
          const SizedBox(height: 20),
          if (activities.isEmpty)
            _buildEmptyState()
          else
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
                border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: List.generate(activities.length, (index) {
                  final act = activities[index];
                  final isLast = index == activities.length - 1;
                  return _buildTimelineItem(act, isLast);
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> act, bool isLast) {
    final color = act['color'] as Color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(act['icon'] as IconData, color: color, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(act['title'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColor.darkBlue)),
                      const SizedBox(height: 4),
                      Text(act['subtitle'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColor.grey)),
                    ],
                  ),
                ),
                Text(act['time'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColor.lightNavColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.lightGrey),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColor.welcomeBgColor, shape: BoxShape.circle),
            child: const Icon(Icons.history_rounded, size: 40, color: AppColor.green),
          ),
          const SizedBox(height: 16),
          const Text("No recent activities", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColor.darkBlue)),
          const SizedBox(height: 8),
          const Text("Your health timeline will appear here once you book an appointment.", textAlign: TextAlign.center, style: TextStyle(color: AppColor.grey, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}