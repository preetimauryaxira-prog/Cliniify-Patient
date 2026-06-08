import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../appointments/providers/patient_appointment_provider.dart';
import '../../auth/pages/mobile_login_page.dart';

class PatientProfilePage extends ConsumerStatefulWidget {
  const PatientProfilePage({super.key});

  @override
  ConsumerState<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends ConsumerState<PatientProfilePage> {
  void _switchProfile(Map<String, dynamic> selectedPatient) {
    HiveUser.saveActivePatient(selectedPatient);
    ref.invalidate(myAppointmentsProvider);
    setState(() {});
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Switched to ${selectedPatient['full_name'] ?? selectedPatient['name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColor.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _showSwitchProfileSheet() {
    final linkedPatients = HiveUser.getLinkedPatients();
    final activePatient = HiveUser.getActivePatient();

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
                "Switch Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select a family member account to manage",
                style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              ...linkedPatients.map((patientMap) {
                final patient = Map<String, dynamic>.from(patientMap);
                final isActive = activePatient?['id'] == patient['id'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: isActive ? AppColor.green.withValues(alpha: 0.05) : AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: isActive ? null : () => _switchProfile(patient),
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
                                color: isActive ? AppColor.green : AppColor.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person_rounded, color: isActive ? AppColor.white : AppColor.green, size: 26),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['full_name'] ?? patient['name'] ?? 'Unknown',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: isActive ? AppColor.green : AppColor.darkBlue),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isActive ? AppColor.green.withValues(alpha: 0.1) : AppColor.welcomeBgColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      patient['relation'] ?? 'Patient',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isActive ? AppColor.green : AppColor.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: AppColor.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                                child: const Icon(Icons.check_circle_rounded, color: AppColor.green, size: 24),
                              ),
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

  void _logout() {
    HiveUser.logout();
    Navigator.pushNamedAndRemoveUntil(context, MobileLoginPage.routerName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final activePatient = HiveUser.getActivePatient();
    final linkedPatients = HiveUser.getLinkedPatients();
    final String patientName = activePatient?['full_name'] ?? activePatient?['name'] ?? 'User';

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHeader(patientName),
            const SizedBox(height: 24),
            _buildActiveProfileCard(activePatient, linkedPatients.length > 1),
            const SizedBox(height: 32),
            _buildAccountOptions(),
            const SizedBox(height: 32),
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String patientName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.green.withValues(alpha: 0.1), Colors.transparent],
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
                const Text("Hello,", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.grey)),
                const SizedBox(height: 4),
                Text(
                  patientName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text("Manage your health profile", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.grey)),
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: AppColor.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
          //   ),
          //   child: const Icon(Icons.settings_outlined, color: AppColor.darkBlue, size: 24),
          // ),
        ],
      ),
    );
  }

  Widget _buildActiveProfileCard(Map<dynamic, dynamic>? activePatient, bool showSwitchBtn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 10))],
          border: Border.all(color: AppColor.green.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.green.withValues(alpha: 0.05)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: AppColor.green.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.green.withValues(alpha: 0.3), width: 2),
                        ),
                        child: const Icon(Icons.person_rounded, size: 36, color: AppColor.green),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColor.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Text("ACTIVE PROFILE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColor.green, letterSpacing: 0.5)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activePatient?['full_name'] ?? activePatient?['name'] ?? 'Unknown User',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _buildInfoChip(Icons.badge_rounded, "ID: ${activePatient?['patient_id'] ?? activePatient?['id'] ?? 'N/A'}"),
                                const SizedBox(width: 8),
                                if (activePatient != null && activePatient['relation'] != null)
                                  _buildInfoChip(Icons.family_restroom_rounded, activePatient['relation']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showSwitchBtn) ...[
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: AppColor.lightGrey),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _showSwitchProfileSheet,
                        icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                        label: const Text("Switch Profile", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.green,
                          side: const BorderSide(color: AppColor.green, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: AppColor.green.withValues(alpha: 0.05),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.welcomeBgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColor.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.grey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColor.grey)),
        ],
      ),
    );
  }

  Widget _buildAccountOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColor.darkBlue)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
              border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                _buildOptionTile(Icons.person_outline_rounded, "Personal Information", "Edit details and demographics", true),
                const Divider(height: 1, color: AppColor.lightGrey, indent: 64),
                _buildOptionTile(Icons.security_rounded, "Security & PIN", "Update your login PIN", true),
                const Divider(height: 1, color: AppColor.lightGrey, indent: 64),
                _buildOptionTile(Icons.support_agent_rounded, "Help & Support", "Contact clinic for assistance", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, String subtitle, bool isTop) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.vertical(top: Radius.circular(isTop ? 20 : 0), bottom: Radius.circular(!isTop ? 20 : 0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColor.darkBlue, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColor.darkBlue)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColor.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColor.grey, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        shadowColor: AppColor.darkBlue.withValues(alpha: 0.04),
        elevation: 8,
        child: InkWell(
          onTap: _logout,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColor.red.withValues(alpha: 0.1),
          highlightColor: AppColor.red.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.red.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColor.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.logout_rounded, color: AppColor.red, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Logout", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColor.red)),
                      SizedBox(height: 2),
                      Text("Securely sign out of your account", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColor.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}