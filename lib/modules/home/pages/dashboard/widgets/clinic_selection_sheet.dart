import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';
import '../../../../../utils/hive_config.dart';

class ClinicSelectionSheet extends StatelessWidget {
  final VoidCallback onClinicSwitched;

  const ClinicSelectionSheet({super.key, required this.onClinicSwitched});

  void _switchClinic(BuildContext context, Map<String, dynamic> selectedClinic) {
    HiveUser.saveSelectedClinic(selectedClinic);
    onClinicSwitched();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Switched to ${selectedClinic['name']}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        backgroundColor: AppColor.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinics = HiveUser.getAllClinics();
    final currentClinic = HiveUser.getSelectedClinic();
    
    // Grabs the bottom safe area to prevent overlapping with iOS home indicators
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 32 + bottomPadding),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)), // Slightly softer top radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Softer, more modern drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColor.grey.withValues(alpha: 0.2), 
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 28),
          
          // 2. Header Content
          const Text(
            "Select Clinic",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColor.darkBlue, letterSpacing: -0.5),
          ),
          const SizedBox(height: 6),
          const Text(
            "Choose a clinic to view specific records and book your next appointment.",
            style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500, height: 1.4),
          ),
          const SizedBox(height: 24),
          
          // 3. Dynamic List / Empty State
          if (clinics.isEmpty)
            _buildEmptyState()
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: clinics.map((clinicMap) {
                  final clinic = Map<String, dynamic>.from(clinicMap);
                  final isActive = currentClinic?['id'] == clinic['id'];

                  return _buildClinicCard(context, clinic, isActive);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClinicCard(BuildContext context, Map<String, dynamic> clinic, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive ? AppColor.green.withValues(alpha: 0.05) : AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isActive) // Only cast shadow if unselected to maintain the clean layout
            BoxShadow(
              color: AppColor.darkBlue.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: isActive ? AppColor.green.withValues(alpha: 0.8) : AppColor.lightGrey.withValues(alpha: 0.6),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? null : () => _switchClinic(context, clinic),
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColor.green.withValues(alpha: 0.1),
          highlightColor: AppColor.green.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Enhanced Avatar Container
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColor.welcomeBgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: CachedNetworkImage(
                      imageUrl: clinic['logo'] ?? '',
                      fit: BoxFit.cover,
                      // Added a loading spinner for slower network conditions
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.green),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.local_hospital_rounded, color: AppColor.green, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Clinic Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic['name'] ?? 'Unknown Clinic',
                        style: TextStyle(
                          fontWeight: FontWeight.w700, 
                          fontSize: 16, 
                          color: isActive ? AppColor.green : AppColor.darkBlue,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 2),
                        const Text("Currently Active", style: TextStyle(fontSize: 12, color: AppColor.green, fontWeight: FontWeight.w600)),
                      ]
                    ],
                  ),
                ),
                
                // Active State Checkmark vs Default Arrow
                if (isActive)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColor.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: AppColor.white, size: 16),
                  )
                else
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColor.grey, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Friendly Empty State Widget
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColor.welcomeBgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.business_rounded, size: 32, color: AppColor.grey),
          ),
          const SizedBox(height: 16),
          const Text("No Clinics Found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColor.darkBlue)),
          const SizedBox(height: 8),
          const Text(
            "You aren't linked to any clinics yet. Your clinics will appear here automatically.", 
            textAlign: TextAlign.center, 
            style: TextStyle(color: AppColor.grey, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}