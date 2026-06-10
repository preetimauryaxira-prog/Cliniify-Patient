import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../providers/patient_records_provider.dart';

class PatientRecordsPage extends ConsumerWidget {
  const PatientRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildTabBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildPrescriptionsTab(ref),
                      _buildFilesTab(ref),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: const Icon(Icons.folder_shared_rounded, color: AppColor.green, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medical Records", 
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColor.darkBlue, letterSpacing: -0.5)
                ),
                SizedBox(height: 4),
                Text(
                  "Access your prescriptions & reports", 
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColor.grey)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.6), // Frosted glass effect
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.white, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColor.green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: AppColor.green.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            labelColor: AppColor.white,
            unselectedLabelColor: AppColor.darkBlue.withValues(alpha: 0.6),
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.2),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            splashBorderRadius: BorderRadius.circular(12),
            tabs: const [
              Tab(text: "Prescriptions"),
              Tab(text: "Lab Reports"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionsTab(WidgetRef ref) {
    final asyncData = ref.watch(prescriptionsProvider);

    return asyncData.when(
      loading: () => _buildSkeletonLoading(),
      error: (e, _) => _buildEmptyState("Failed to load", e.toString(), Icons.error_outline_rounded),
      data: (prescriptions) {
        if (prescriptions.isEmpty) {
          return _buildEmptyState("No Prescriptions", "You don't have any digital prescriptions yet.", Icons.receipt_long_rounded);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 100), // Extra bottom padding for custom nav bar
          physics: const BouncingScrollPhysics(),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final rx = prescriptions[index];
            final drugs = List<dynamic>.from(rx['drugs'] ?? []);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColor.green, width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section with subtle background
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.green.withValues(alpha: 0.05), Colors.transparent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 48, width: 48,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))
                                  ],
                                ),
                                child: const Icon(Icons.medical_services_rounded, color: AppColor.green),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Dr. ${rx['doctor_name']}", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColor.darkBlue)),
                                    const SizedBox(height: 4),
                                    Text(rx['diagnosis'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColor.grey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColor.lightGrey),
                                ),
                                child: Text(rx['date'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColor.darkBlue)),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppColor.lightGrey),
                        
                        // Medicines Section
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Prescribed Medicines", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColor.darkBlue, letterSpacing: 0.2)),
                              const SizedBox(height: 16),
                              ...drugs.map((d) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(color: AppColor.welcomeBgColor, shape: BoxShape.circle),
                                      child: const Icon(Icons.medication_rounded, size: 16, color: AppColor.green),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(d['name'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColor.darkBlue)),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              _buildMedicineChip(Icons.watch_later_outlined, d['dosage']),
                                              _buildMedicineChip(Icons.calendar_month_outlined, d['duration']),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        
                        // Interactive Footer
                        Material(
                          color: AppColor.welcomeBgColor.withValues(alpha: 0.6),
                          child: InkWell(
                            onTap: () {
                              // Navigate to detailed prescription view
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: AppColor.lightGrey)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("View Full Prescription", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColor.green)),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded, color: AppColor.green, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMedicineChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColor.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.grey)),
        ],
      ),
    );
  }

  Widget _buildFilesTab(WidgetRef ref) {
    final asyncData = ref.watch(emrFilesProvider);

    return asyncData.when(
      loading: () => _buildSkeletonLoading(),
      error: (e, _) => _buildEmptyState("Failed to load", e.toString(), Icons.error_outline_rounded),
      data: (files) {
        if (files.isEmpty) {
          return _buildEmptyState("No Lab Reports", "Your lab reports and documents will appear here securely.", Icons.folder_open_rounded);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
          physics: const BouncingScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final isPdf = file['type'] == 'pdf';
            final color = isPdf ? AppColor.red : AppColor.darkBlue;
            final bgColor = isPdf ? AppColor.snackBgRed : AppColor.welcomeBgColor;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            height: 56, width: 56,
                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
                            child: Icon(isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded, color: color, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file['file_name'], 
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColor.darkBlue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 12, color: AppColor.grey.withValues(alpha: 0.8)),
                                    const SizedBox(width: 4),
                                    Text(file['date'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.grey)),
                                    const SizedBox(width: 12),
                                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColor.lightGrey, shape: BoxShape.circle)),
                                    const SizedBox(width: 12),
                                    const Text("1.2 MB", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.file_download_outlined, color: AppColor.green, size: 20),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Downloading file...", style: TextStyle(fontWeight: FontWeight.bold)),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: AppColor.green,
                                )
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Icon(icon, size: 48, color: AppColor.green),
            ),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColor.darkBlue)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.grey, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 160,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.lightGrey.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(height: 48, width: 48, decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(14))),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: 120, decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 10),
                        Container(height: 12, width: 80, decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                Container(height: 12, width: 200, decoration: BoxDecoration(color: AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        );
      },
    );
  }
}