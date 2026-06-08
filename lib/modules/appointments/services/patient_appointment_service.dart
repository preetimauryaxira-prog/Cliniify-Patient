import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/patient_endpoints.dart';
import '../../../utils/hive_config.dart';

class PatientAppointmentService {
  PatientAppointmentService(this._dioClient);
  final DioClient _dioClient;

  Future<List<dynamic>> getMyAppointments() async {
    try {
      final activePatient = HiveUser.getActivePatient();
      final patientId = activePatient?['id'];
      if (patientId == null) {
        throw Exception('No active patient found');
      }
      /*
      final Response response = await _dioClient.get(
        PatientEndpoints.getPatientAppointments,
        queryParameters: {'patient_id': patientId}
      );
      return response.data['data'] ?? [];
      */

      // ==========================================
      // DEV BYPASS: MOCK APPOINTMENTS DATA
      // ==========================================
      await Future.delayed(const Duration(seconds: 1)); // Simulate network loading
      
      return [
        {
          "id": 101,
          "scheduled_date": DateTime.now().add(const Duration(days: 2)).toIso8601String(), // 2 days from now
          "scheduled_time": "10:30 AM",
          "status": "Confirmed",
          "doctor": {"id": 1, "full_name": "Dr. Sarah Smith", "designation": "Dentist"},
          "procedure": {"id": 1, "name": "General Checkup"}
        },
        {
          "id": 102,
          "scheduled_date": DateTime.now().subtract(const Duration(days: 15)).toIso8601String(), // 15 days ago
          "scheduled_time": "02:00 PM",
          "status": "Completed",
          "doctor": {"id": 2, "full_name": "Dr. John Doe", "designation": "Orthodontist"},
          "procedure": {"id": 2, "name": "Root Canal"}
        },
        {
          "id": 103,
          "scheduled_date": DateTime.now().add(const Duration(days: 5)).toIso8601String(), // 5 days from now
          "scheduled_time": "11:00 AM",
          "status": "Cancelled",
          "doctor": {"id": 1, "full_name": "Dr. Sarah Smith", "designation": "Dentist"},
          "procedure": {"id": 3, "name": "Teeth Whitening"}
        }
      ];
      // ==========================================

    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Server Error: ${e.response?.statusCode}');
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  Future<bool> bookAppointment(Map<String, dynamic> apptData) async {
    try {
      /*
      // Adjust '/api/patient/book/' to your real booking endpoint
      final Response response = await _dioClient.post('/api/patient/book/', data: apptData);
      return response.statusCode == 200 || response.statusCode == 201;
      */

      await Future.delayed(const Duration(seconds: 1));
      return true;

    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }
}