import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../appointments/providers/patient_appointment_provider.dart'; // To refresh data on switch
import '../../auth/pages/mobile_login_page.dart';

class PatientProfilePage extends ConsumerStatefulWidget {
  const PatientProfilePage({super.key});

  @override
  ConsumerState<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends ConsumerState<PatientProfilePage> {
  
  void _switchProfile(Map<String, dynamic> selectedPatient) {
    // 1. Save the new active patient
    HiveUser.saveActivePatient(selectedPatient);
    
    // 2. Invalidate data providers so the Dashboard & Appointments fetch data for the new patient
    ref.invalidate(myAppointmentsProvider);
    
    // 3. Update UI
    setState(() {});
    Navigator.pop(context); // Close bottom sheet
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Switched to ${selectedPatient['full_name'] ?? selectedPatient['name']}"), 
      backgroundColor: AppColor.green
    ));
  }

  void _showSwitchProfileSheet() {
    final linkedPatients = HiveUser.getLinkedPatients();
    final activePatient = HiveUser.getActivePatient();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Switch Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
              const SizedBox(height: 8),
              const Text("Select a family member account", style: TextStyle(color: AppColor.grey)),
              const SizedBox(height: 16),
              ...linkedPatients.map((patientMap) {
                final patient = Map<String, dynamic>.from(patientMap);
                final isActive = activePatient?['id'] == patient['id'];
                
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColor.green.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: AppColor.green),
                  ),
                  title: Text(patient['full_name'] ?? patient['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(patient['relation'] ?? 'Patient', style: const TextStyle(fontSize: 12, color: AppColor.grey)),
                  trailing: isActive ? const Icon(Icons.check_circle_rounded, color: AppColor.green) : null,
                  onTap: isActive ? null : () => _switchProfile(patient),
                );
              }),
            ],
          ),
        );
      }
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

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("My Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
            const SizedBox(height: 24),
            
            // Active Patient Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(color: AppColor.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.person, size: 30, color: AppColor.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activePatient?['full_name'] ?? activePatient?['name'] ?? 'Unknown User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                        const SizedBox(height: 4),
                        Text("ID: ${activePatient?['patient_id'] ?? activePatient?['id'] ?? 'N/A'}", style: const TextStyle(color: AppColor.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  if (linkedPatients.length > 1) // Only show switch button if multiple patients exist
                    IconButton(
                      tooltip: "Switch Profile",
                      icon: const Icon(Icons.swap_horiz_rounded, color: AppColor.green, size: 28),
                      onPressed: _showSwitchProfileSheet,
                    )
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Settings / Logout
            ListTile(
              onTap: _logout,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: AppColor.red.withValues(alpha: 0.1),
              leading: const Icon(Icons.logout_rounded, color: AppColor.red),
              title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.red)),
            )
          ],
        ),
      ),
    );
  }
}