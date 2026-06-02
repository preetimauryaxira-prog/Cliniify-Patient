import 'main_endpoint.dart';

class PatientEndpoints {
  static const String mobileLogin = '${MainEndpoint.mainEndPoint}/patient/auth/mobile-login/';
  
  static const String getPatientAppointments = '${MainEndpoint.mainEndPoint}/patient/appointments/';
}