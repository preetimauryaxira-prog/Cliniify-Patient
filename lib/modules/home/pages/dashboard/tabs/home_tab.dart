import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../utils/apptheme.dart';
import '../../../../../utils/hive_config.dart';
import '../../../../notification/pages/notifications_page.dart';
import '../widgets/clinic_selection_sheet.dart';
import '../widgets/health_insights_bar.dart';
import '../widgets/upcoming_appointment_card.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/health_tips_carousel.dart';
import '../widgets/recent_activity_timeline.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  
  // UX Upgrade: Simulating a data refresh for the dashboard
  Future<void> _handleRefresh() async {
    // Add your actual API refresh logic here (e.g., ref.refresh(patientProvider))
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {});
    }
  }

  // UX Upgrade: Dynamic greeting with contextual icons
  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String text;
    IconData icon;
    Color iconColor;

    if (hour < 12) {
      text = 'Good Morning';
      icon = Icons.wb_sunny_rounded;
      iconColor = const Color(0xFFF59E0B); // Warm amber
    } else if (hour < 17) {
      text = 'Good Afternoon';
      icon = Icons.cloud_rounded;
      iconColor = const Color(0xFF60A5FA); // Soft blue
    } else {
      text = 'Good Evening';
      icon = Icons.nights_stay_rounded;
      iconColor = const Color(0xFF6366F1); // Indigo
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColor.grey,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  void _showClinicSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClinicSelectionSheet(
        onClinicSwitched: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinic = HiveUser.getSelectedClinic();
    final activePatient = HiveUser.getActivePatient();
    final String patientName = activePatient?['full_name'] ?? activePatient?['name'] ?? 'Preeti';

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.globalBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          // UX Upgrade: Pull-to-refresh integration
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColor.green,
            backgroundColor: AppColor.white,
            strokeWidth: 3,
            edgeOffset: 20,
            child: ListView(
              // AlwaysScrollable is required so the refresh gesture works even on short screens
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(bottom: 120), 
              children: [
                _buildCustomHeader(clinic, patientName),
                const SizedBox(height: 8),
                const HealthInsightsBar(),
                const SizedBox(height: 24),
                const UpcomingAppointmentCard(),
                const SizedBox(height: 24),
                const QuickActionList(),
                const SizedBox(height: 24),
                const HealthTipsCarousel(),
                const SizedBox(height: 24),
                const RecentActivityTimeline(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(Map<dynamic, dynamic>? clinic, String patientName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Greeting & Clinic Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(), // Integrated dynamic greeting
                const SizedBox(height: 4),
                Text(
                  patientName,
                  style: const TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.w800, 
                    color: AppColor.darkBlue, 
                    letterSpacing: -0.5
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // UX Upgrade: Elevated Clinic Selector Pill
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.green.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Material(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: _showClinicSelection,
                      borderRadius: BorderRadius.circular(20),
                      splashColor: AppColor.green.withValues(alpha: 0.1),
                      highlightColor: AppColor.green.withValues(alpha: 0.05),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColor.green.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.business_rounded, size: 14, color: AppColor.green),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                clinic?['name'] ?? 'Select Clinic',
                                style: const TextStyle(
                                  fontSize: 12, 
                                  color: AppColor.green, 
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColor.green),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Right Side: Actions
          Row(
            children: [
              // Notification Bell with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Material(
                    color: AppColor.white.withValues(alpha: 0.6),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pushNamed(context, NotificationsPage.routerName),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.notifications_outlined, color: AppColor.darkBlue, size: 24),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: AppColor.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.white, width: 2),
                      ),
                    ),
                  )
                ],
              ),

              if (clinic != null && clinic['logo'] != null) ...[
                const SizedBox(width: 12),
                // UX Upgrade: Premium Avatar Ring
                Container(
                  height: 44, // Slightly larger for tap target
                  width: 44,
                  padding: const EdgeInsets.all(2), // Creates a profile ring effect
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.darkBlue.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: clinic['logo'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.green),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColor.welcomeBgColor,
                        child: const Icon(Icons.local_hospital_rounded, color: AppColor.green, size: 20),
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}