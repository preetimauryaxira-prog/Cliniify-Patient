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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Medical Records", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
              ),
              const TabBar(
                indicatorColor: AppColor.green,
                labelColor: AppColor.green,
                unselectedLabelColor: AppColor.grey,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Prescriptions"),
                  Tab(text: "Lab Reports & Files"),
                ],
              ),
              Expanded(
                child: TabBarView(
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
    );
  }

  Widget _buildPrescriptionsTab(WidgetRef ref) {
    final asyncData = ref.watch(prescriptionsProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColor.green)),
      error: (e, _) => Center(child: Text("Error loading prescriptions: $e")),
      data: (prescriptions) {
        if (prescriptions.isEmpty) return const Center(child: Text("No prescriptions found."));
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final rx = prescriptions[index];
            final drugs = List<dynamic>.from(rx['drugs'] ?? []);

            return Card(
              color: AppColor.white,
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColor.lightGrey)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rx['date'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.green)),
                        const Icon(Icons.medical_information_rounded, color: AppColor.grey),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Dr. ${rx['doctor_name']} • ${rx['diagnosis']}", style: const TextStyle(fontWeight: FontWeight.w600, color: AppColor.darkBlue)),
                    const Divider(height: 24),
                    ...drugs.map((d) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medication_rounded, size: 18, color: AppColor.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColor.darkBlue)),
                                Text("Take: ${d['dosage']} • For: ${d['duration']}", style: const TextStyle(fontSize: 12, color: AppColor.grey)),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilesTab(WidgetRef ref) {
    final asyncData = ref.watch(emrFilesProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColor.green)),
      error: (e, _) => Center(child: Text("Error loading files: $e")),
      data: (files) {
        if (files.isEmpty) return const Center(child: Text("No files uploaded."));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final isPdf = file['type'] == 'pdf';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tileColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColor.lightGrey)),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: isPdf ? AppColor.snackBgRed : AppColor.welcomeBgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded, color: isPdf ? AppColor.red : AppColor.darkBlue),
              ),
              title: Text(file['file_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text("Uploaded: ${file['date']}", style: const TextStyle(fontSize: 12, color: AppColor.grey)),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColor.green),
                onPressed: () {
                  // TODO: Implement file download logic
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading file...")));
                },
              ),
            );
          },
        );
      },
    );
  }
}