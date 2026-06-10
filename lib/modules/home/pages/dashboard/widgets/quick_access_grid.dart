import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';
import '../../../../billing/pages/patient_billing_page.dart';
import '../../../../gallery/pages/clinic_gallery_page.dart';
import '../../../../treatments/pages/patient_treatments_page.dart';

// Helper class to structure our action items cleanly
class _ActionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _ActionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class QuickActionList extends StatelessWidget {
  const QuickActionList({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the list of actions here. This makes it much easier to manage, 
    // add role-based visibility, or inject localized strings later.
    final List<_ActionItem> actions = [
      _ActionItem(
        icon: Icons.receipt_long_rounded,
        title: "My Bills",
        onTap: () => Navigator.pushNamed(context, PatientBillingPage.routerName),
      ),
      _ActionItem(
        icon: Icons.assignment_rounded,
        title: "Treatments",
        onTap: () => Navigator.pushNamed(context, PatientTreatmentsPage.routerName),
      ),
      _ActionItem(
        icon: Icons.photo_library_rounded,
        title: "Clinic Gallery",
        onTap: () => Navigator.pushNamed(context, ClinicGalleryPage.routerName),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.w700, 
              color: AppColor.grey, 
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Map through the action items dynamically
        ...actions.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildActionTile(context, action),
        )),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, _ActionItem action) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20), // Slightly softer radius for premium feel
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: action.onTap,
          splashColor: AppColor.green.withValues(alpha: 0.05), // Brand-matched splash
          highlightColor: AppColor.green.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  height: 44, // Slightly larger for better touch targeting
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(action.icon, color: AppColor.green, size: 22),
                ),
                const SizedBox(width: 16),
                
                // Title
                Expanded(
                  child: Text(
                    action.title,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600, 
                      color: AppColor.darkBlue,
                    ),
                  ),
                ),
                
                // Trailing Chevron
                Icon(
                  Icons.arrow_forward_ios_rounded, 
                  color: AppColor.grey.withValues(alpha: 0.6), 
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}