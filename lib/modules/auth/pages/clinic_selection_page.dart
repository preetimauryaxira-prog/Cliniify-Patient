import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../home/pages/dashboard/pages/dashboard_page.dart';

class ClinicSelectionPage extends StatelessWidget {
  const ClinicSelectionPage({super.key});
  static const String routerName = '/clinic_selection';

  @override
  Widget build(BuildContext context) {
    // Expecting clinics to be passed via arguments
    final List<Map<String, dynamic>> clinics = 
        ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>? ?? [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Select Your Clinic",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.darkBlue),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose the clinic to view your specific medical records and appointments.",
                style: TextStyle(fontSize: 14, color: AppColor.grey),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: clinics.length,
                  itemBuilder: (context, index) {
                    final clinic = clinics[index];
                    return _buildClinicCard(context, clinic);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClinicCard(BuildContext context, Map<String, dynamic> clinic) {
    return GestureDetector(
      onTap: () {
        // Save white-label context locally
        HiveUser.saveSelectedClinic(clinic);
        
        Navigator.pushNamedAndRemoveUntil(context, DashboardPage.routerName, (route) => false);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Switched to ${clinic['name']}"), 
          backgroundColor: AppColor.green,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            // Clinic Logo
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColor.welcomeBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGrey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: clinic['logo'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColor.green)),
                  errorWidget: (context, url, error) => const Icon(Icons.local_hospital, color: AppColor.green),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                clinic['name'] ?? 'Unknown Clinic',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.darkBlue),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColor.green),
          ],
        ),
      ),
    );
  }
}