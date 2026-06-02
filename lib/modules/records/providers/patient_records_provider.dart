import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/hive_config.dart';

class PatientRecordsService {
  PatientRecordsService(this._dioClient);
  final DioClient _dioClient;

  Future<List<dynamic>> getPatientPrescriptions() async {
    final activePatient = HiveUser.getActivePatient();
    final patientId = activePatient?['id'];
    
    // TODO: Uncomment when backend is ready
    // final response = await _dioClient.get('/api/patient/$patientId/prescriptions');
    // return response.data['data'];

    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        "id": 1,
        "date": "2023-10-15",
        "doctor_name": "Dr. Sarah Smith",
        "diagnosis": "Viral Fever",
        "drugs": [
          {"name": "Paracetamol 500mg", "dosage": "1-0-1", "duration": "5 Days"},
          {"name": "Azithromycin 250mg", "dosage": "1-0-0", "duration": "3 Days"}
        ]
      }
    ]; // Mock Data
  }

  Future<List<dynamic>> getPatientFiles() async {
    final patientId = HiveUser.getActivePatient()?['id'];
    
    // TODO: Uncomment when backend is ready
    // final response = await _dioClient.get('/api/patient/$patientId/files');
    // return response.data['data'];

    await Future.delayed(const Duration(milliseconds: 800));
    return [
      {"id": 1, "file_name": "Blood_Test_Report.pdf", "date": "2023-10-10", "type": "pdf"},
      {"id": 2, "file_name": "Dental_XRay.png", "date": "2023-09-05", "type": "image"},
    ]; // Mock Data
  }
}

// --- Providers ---
final patientRecordsServiceProvider = Provider<PatientRecordsService>((ref) {
  return PatientRecordsService(ref.read(dioClientProvider));
});

final prescriptionsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return await ref.read(patientRecordsServiceProvider).getPatientPrescriptions();
});

final emrFilesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return await ref.read(patientRecordsServiceProvider).getPatientFiles();
});