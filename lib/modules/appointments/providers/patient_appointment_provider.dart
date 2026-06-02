import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../services/patient_appointment_service.dart';

final patientApptServiceProvider = Provider<PatientAppointmentService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return PatientAppointmentService(dioClient);
});

// Provider to fetch all appointments
final myAppointmentsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final service = ref.read(patientApptServiceProvider);
  return await service.getMyAppointments();
});

final bookingLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);