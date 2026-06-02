import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../widgets/otp_field.dart';
import 'clinic_selection_page.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});
  static const String routerName = '/pin_setup';

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  void _savePin() {
    String pin = _controllers.map((c) => c.text).join();
    if (pin.length == 4) {
      HiveUser.savePin(pin);
      // Retrieve clinics passed from OTP page
      final clinics = ModalRoute.of(context)!.settings.arguments;
      Navigator.pushNamedAndRemoveUntil(context, ClinicSelectionPage.routerName, (route) => false, arguments: clinics);
    }
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
            const Icon(Icons.lock_person_rounded, size: 60, color: AppColor.green),
            const SizedBox(height: 24),
            const Text("Set 4-Digit PIN", textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
            const SizedBox(height: 8),
            const Text("Use this PIN for quick login next time.", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColor.grey)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OTPTextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) _focusNodes[index + 1].requestFocus();
                      if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                      if (value.isNotEmpty && index == 3) _savePin(); // Auto-save on 4th digit
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}