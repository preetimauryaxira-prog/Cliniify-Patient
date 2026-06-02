import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../widgets/otp_field.dart';
import 'mobile_login_page.dart';
import 'clinic_selection_page.dart';
import '../../home/pages/dashboard_page.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});
  static const String routerName = '/pin_login';

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  void _verifyPin() {
    String enteredPin = _controllers.map((c) => c.text).join();
    String savedPin = HiveUser.getPin();

    if (enteredPin == savedPin) {
      _routeToNextScreen();
    } else {
      setState(() {
        for (var c in _controllers) { c.clear(); }
      });
      _focusNodes[0].requestFocus(); // Reset focus to first box
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN. Please try again.'), backgroundColor: AppColor.red)
      );
    }
  }

  void _routeToNextScreen() {
    final selectedClinic = HiveUser.getSelectedClinic();
    
    if (selectedClinic == null) {
      // Fetch dynamic clinics saved during mobile login
      final dynamicClinics = HiveUser.getAllClinics();
      
      // Pass the dynamic clinics to the selection page
      Navigator.pushReplacementNamed(
        context, 
        ClinicSelectionPage.routerName, 
        arguments: dynamicClinics,
      );
    } else {
      // Route to Dashboard
      Navigator.pushReplacementNamed(context, DashboardPage.routerName);
    }
  }

  void _logoutAndReset() {
    // If they forgot their PIN, wipe data and send to Mobile Login
    HiveUser.logout();
    Navigator.pushReplacementNamed(context, MobileLoginPage.routerName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 60, color: AppColor.green),
            const SizedBox(height: 24),
            const Text(
              "Welcome Back",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.darkBlue),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your 4-Digit PIN to unlock",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.grey),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OTPTextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    // We can pass an error state to the OTPTextField if you modify it to accept one
                    // For now, we clear the fields on error.
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) _focusNodes[index + 1].requestFocus();
                      if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                      if (value.isNotEmpty && index == 3) {
                        // All 4 digits entered, auto-verify
                        _verifyPin(); 
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: _logoutAndReset,
              child: const Text(
                "Forgot PIN? Login with OTP",
                style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}