import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/hive_config.dart';

class PatientBillingService {
  PatientBillingService(this._dioClient);
  final DioClient _dioClient;

  Future<List<dynamic>> getPatientInvoices() async {
    final activePatient = HiveUser.getActivePatient();
    final patientId = activePatient?['id'];
    
    // ==========================================
    // TODO: UNCOMMENT WHEN BACKEND IS READY
    // ==========================================
    // final response = await _dioClient.get(
    //   '/api/patient/invoices/', 
    //   queryParameters: {'patient_id': patientId}
    // );
    // return response.data['data'];

    // ==========================================
    // DEV BYPASS: MOCK INVOICES
    // ==========================================
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        "invoice_id": "INV-2023-1002",
        "date": "2023-11-02",
        "doctor_name": "Dr. Sarah Smith",
        "total_amount": 850.00,
        "status": "Unpaid",
        "items": [
          {"name": "General Consultation", "price": 500.00},
          {"name": "Blood Test", "price": 350.00}
        ]
      },
      {
        "invoice_id": "INV-2023-0945",
        "date": "2023-10-15",
        "doctor_name": "Dr. John Doe",
        "total_amount": 1500.00,
        "status": "Paid",
        "items": [
          {"name": "Root Canal Treatment", "price": 1500.00}
        ]
      }
    ];
  }
}

// --- Providers ---
final patientBillingServiceProvider = Provider<PatientBillingService>((ref) {
  return PatientBillingService(ref.read(dioClientProvider));
});

final patientInvoicesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return await ref.read(patientBillingServiceProvider).getPatientInvoices();
});