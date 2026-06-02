import 'package:hive_flutter/hive_flutter.dart';

class HiveUser {
  static const String boxName = 'patientBox';
  
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  // --- Auth Token ---
  static void saveAuthToken(String token) => _box.put('token', token);
  static String getAuthToken() => _box.get('token', defaultValue: '');
  
  // --- Quick Login PIN ---
  static void savePin(String pin) => _box.put('quick_pin', pin);
  static String getPin() => _box.get('quick_pin', defaultValue: '');
  static bool hasPin() => getPin().isNotEmpty;

  // --- Clinic White-labeling ---
  static void saveAllClinics(List<dynamic> clinics) => _box.put('all_clinics', clinics);
  static List<dynamic> getAllClinics() => _box.get('all_clinics', defaultValue: []);

  static void saveSelectedClinic(Map<String, dynamic> clinic) => _box.put('selected_clinic', clinic);
  static Map<dynamic, dynamic>? getSelectedClinic() => _box.get('selected_clinic');

  // --- Multiple Patients Management ---
  static void saveLinkedPatients(List<dynamic> patients) => _box.put('linked_patients', patients);
  static List<dynamic> getLinkedPatients() => _box.get('linked_patients', defaultValue: []);

  static void saveActivePatient(Map<String, dynamic> patient) => _box.put('active_patient', patient);
  static Map<dynamic, dynamic>? getActivePatient() => _box.get('active_patient');

  static void logout() {
    _box.clear();
  }
}