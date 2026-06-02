import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../providers/auth_provider.dart';
import 'pin_setup_page.dart';
import 'clinic_selection_page.dart';

class MobileLoginPage extends ConsumerStatefulWidget {
  const MobileLoginPage({super.key});
  static const String routerName = '/login';

  @override
  ConsumerState<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends ConsumerState<MobileLoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    ref.read(authLoadingProvider.notifier).state = true;
    final mobile = _mobileController.text.trim();

    try {
      final responseData = await ref.read(patientAuthProvider).loginWithMobile(mobile);
      
      // 1. Save Token
      HiveUser.saveAuthToken(responseData['token']);
      
      // 2. Handle Multiple Patients
      final linkedPatients = List<dynamic>.from(responseData['linked_patients'] ?? []);
      if (linkedPatients.isNotEmpty) {
        HiveUser.saveLinkedPatients(linkedPatients);
        HiveUser.saveActivePatient(Map<String, dynamic>.from(linkedPatients.first));
      }

      // 3. Save Dynamic Clinics
      final clinics = List<Map<String, dynamic>>.from(responseData['clinics'] ?? []);
      HiveUser.saveAllClinics(clinics);

      if (!mounted) return;
      ref.read(authLoadingProvider.notifier).state = false;

      // 4. Route based on PIN
      if (!HiveUser.hasPin()) {
        Navigator.pushNamedAndRemoveUntil(context, PinSetupPage.routerName, (route) => false, arguments: clinics);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, ClinicSelectionPage.routerName, (route) => false, arguments: clinics);
      }
    } catch (e) {
      if (!mounted) return;
      ref.read(authLoadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColor.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.local_hospital_rounded, size: 80, color: AppColor.green),
                const SizedBox(height: 24),
                const Text("Welcome to Cliniify", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                const SizedBox(height: 8),
                const Text("Enter your registered mobile number to login.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColor.grey)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: Icon(Icons.phone, color: AppColor.green),
                    border: AppTheme.outlineInputBorder,
                    focusedBorder: AppTheme.focusedOutlineInputBorder,
                  ),
                  validator: (val) => (val == null || val.length < 10) ? "Enter valid 10-digit number" : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : _login,
                  child: isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColor.white))
                      : const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColor.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}