import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../providers/patient_billing_provider.dart';

class PatientBillingPage extends ConsumerWidget {
  const PatientBillingPage({super.key});
  static const String routerName = '/billing';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(patientInvoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bills", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.darkBlue),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: asyncData.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColor.green)),
          error: (e, _) => Center(child: Text("Error loading bills: $e")),
          data: (invoices) {
            if (invoices.isEmpty) {
              return const Center(child: Text("No invoices found.", style: TextStyle(color: AppColor.grey)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                final isPaid = invoice['status']?.toLowerCase() == 'paid';
                final statusColor = isPaid ? AppColor.snackGreen : AppColor.red;
                final statusBg = isPaid ? AppColor.snackBgGreen : AppColor.snackBgRed;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColor.darkBlue.withValues(alpha: 0.05), blurRadius: 10)],
                    border: Border.all(color: AppColor.lightGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Invoice ID & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(invoice['invoice_id'] ?? 'INV-XXXX', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              invoice['status'] ?? 'Unknown',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Doctor & Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColor.grey),
                          const SizedBox(width: 4),
                          Text(invoice['date'] ?? '', style: const TextStyle(fontSize: 13, color: AppColor.grey)),
                          const Spacer(),
                          Text(invoice['doctor_name'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.darkBlue)),
                        ],
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: AppColor.lightGrey),
                      ),
                      
                      // Amount & Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Amount", style: TextStyle(fontSize: 12, color: AppColor.grey)),
                              Text(
                                "₹${invoice['total_amount']?.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.darkBlue),
                              ),
                            ],
                          ),
                          if (!isPaid)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.green,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              onPressed: () {
                                // TODO: Integrate Razorpay/Stripe or Payment Gateway here
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Gateway Coming Soon")));
                              },
                              child: const Text("Pay Now", style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold)),
                            )
                          else
                            TextButton.icon(
                              onPressed: () {
                                // TODO: Download PDF receipt
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading Receipt...")));
                              },
                              icon: const Icon(Icons.download_rounded, size: 16, color: AppColor.green),
                              label: const Text("Receipt", style: TextStyle(color: AppColor.green)),
                            )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}