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
      content: Text(
        "Switched to ${selectedPatient['full_name'] ?? selectedPatient['name']}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
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
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColor.darkBlue,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select a family member account to manage",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.grey,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              ...linkedPatients.map((patientMap) {
                final patient = Map<String, dynamic>.from(patientMap);
                final isActive = activePatient?['id'] == patient['id'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: isActive
                        ? AppColor.green.withValues(alpha: 0.05)
                        : AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: isActive ? null : () => _switchProfile(patient),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive
                                ? AppColor.green
                                : AppColor.lightGrey.withValues(alpha: 0.6),
                            width: isActive ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColor.green
                                    : AppColor.welcomeBgColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: isActive
                                    ? AppColor.white
                                    : AppColor.darkBlue.withValues(alpha: 0.5),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['full_name'] ??
                                        patient['name'] ??
                                        'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: isActive
                                          ? AppColor.green
                                          : AppColor.darkBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    patient['relation'] ?? 'Patient',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isActive)
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColor.green, size: 24)
                            else
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: AppColor.grey, size: 16),
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
    Navigator.pushNamedAndRemoveUntil(
        context, MobileLoginPage.routerName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final activePatient = HiveUser.getActivePatient();
    final linkedPatients = HiveUser.getLinkedPatients();
    final String patientName =
        activePatient?['full_name'] ?? activePatient?['name'] ?? 'Preeti';

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColor.darkBlue,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 120, top: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildActiveProfileCard(
                activePatient, patientName, linkedPatients.length > 1),
            const SizedBox(height: 32),
            _buildAccountOptions(),
            const SizedBox(height: 32),
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveProfileCard(
      Map<dynamic, dynamic>? activePatient, String patientName, bool showSwitchBtn) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 32, color: AppColor.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColor.darkBlue,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                              Icons.badge_rounded,
                              "ID: ${activePatient?['patient_id'] ?? activePatient?['id'] ?? 'N/A'}"),
                          const SizedBox(width: 8),
                          if (activePatient != null &&
                              activePatient['relation'] != null)
                            _buildInfoChip(Icons.family_restroom_rounded,
                                activePatient['relation']),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showSwitchBtn) ...[
            const Divider(height: 1, color: AppColor.welcomeBgColor, thickness: 1.5),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showSwitchProfileSheet,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz_rounded,
                          size: 20, color: AppColor.green),
                      SizedBox(width: 8),
                      Text(
                        "Switch Profile",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.green),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.welcomeBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.grey),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColor.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            "Account Settings",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.grey,
                letterSpacing: 0.5),
          ),
        ),
        _buildOptionTile(
            Icons.person_outline_rounded, "Personal Information", true),
        _buildOptionTile(Icons.security_rounded, "Security & PIN", true),
        _buildOptionTile(Icons.support_agent_rounded, "Help & Support", false),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, bool showDivider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColor.green, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.darkBlue),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColor.grey, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.red.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _logout,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColor.red.withValues(alpha: 0.1),
          highlightColor: AppColor.red.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: AppColor.red, size: 22),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.red),
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