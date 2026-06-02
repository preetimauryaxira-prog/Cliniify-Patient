import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart'; // Adjust to your DioClient path
import '../../../core/network/patient_endpoints.dart';

class PatientAuthService {
  PatientAuthService(this._dioClient);
  final DioClient _dioClient;

  // Real Backend Login Call (Bypassing OTP as requested)
  Future<Map<String, dynamic>> loginWithMobile(String mobileNumber) async {
    try {
      final Response response = await _dioClient.post(
        PatientEndpoints.mobileLogin, 
        data: {'phone': mobileNumber} // Adjust payload key based on your backend
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        // Expected Backend Response Structure:
        // { 
        //   "status": true, 
        //   "data": { 
        //     "token": "...", 
        //     "clinics": [...], 
        //     "linked_patients": [{"id": 1, "name": "John"}, {"id": 2, "name": "Child"}] 
        //   } 
        // }
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to login. Please check your mobile number.');
    }
  }
}

// Update the provider to inject the DioClient
final patientAuthProvider = Provider<PatientAuthService>((ref) {
  final dioClient = ref.read(dioClientProvider); // Assuming you have this from the Doctor App
  return PatientAuthService(dioClient);
});

final authLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);