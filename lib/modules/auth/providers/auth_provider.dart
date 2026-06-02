import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/patient_endpoints.dart';

class PatientAuthService {
  PatientAuthService(this._dioClient);
  final DioClient _dioClient;

  Future<Map<String, dynamic>> loginWithMobile(String mobileNumber) async {
    try {
      // ==========================================
      // TODO: UNCOMMENT THIS WHEN BACKEND IS READY
      // ==========================================
      /*
      final Response response = await _dioClient.post(
        PatientEndpoints.mobileLogin, 
        data: {'phone': mobileNumber} 
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
      */

      // ==========================================
      // DEV BYPASS: MOCK SUCCESS RESPONSE
      // ==========================================
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      return {
        'token': 'dev_bypass_token_12345',
        'linked_patients': [
          {'id': 101, 'full_name': 'Demo Patient', 'relation': 'Self', 'phone': mobileNumber},
          {'id': 102, 'full_name': 'Demo Child', 'relation': 'Son', 'phone': mobileNumber},
        ],
        'clinics': [
          {'id': 1, 'name': 'City Care Clinic', 'logo': 'https://placehold.co/100x100.png?text=City+Care'},
        ]
      };
      // ==========================================

    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Placeholders
  Future<bool> sendOtp(String mobileNumber) async => true;
  Future<Map<String, dynamic>> verifyOtp(String mobileNumber, String otp) async => {};
}

final patientAuthProvider = Provider<PatientAuthService>((ref) {
  final dioClient = ref.read(dioClientProvider); 
  return PatientAuthService(dioClient);
});

final authLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);