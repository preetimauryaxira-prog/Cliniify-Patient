import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_field.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key});
  static const String routerName = '/otp';

  @override
  ConsumerState<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  String get _otp => _controllers.map((c) => c.text).join();

  void _verify() async {
    if (_otp.length < 6) return;
    
    ref.read(authLoadingProvider.notifier).state = true;
    //final mobile = ref.read(mobileNumberProvider);

    try {
      //final response = await ref.read(patientAuthProvider).verifyOtp(mobile, _otp);
      
      // Save Token
      //HiveUser.saveAuthToken(response['token']);
      ref.read(authLoadingProvider.notifier).state = false;

      // Pass clinics data forward
      //final clinics = List<Map<String, dynamic>>.from(response['clinics']);
      
      if (mounted) {
        // If PIN is not setup, go to PIN Setup. Otherwise skip to Clinic Selection.
        if (!HiveUser.hasPin()) {
          //Navigator.pushNamedAndRemoveUntil(context, PinSetupPage.routerName, (route) => false, arguments: clinics);
        } else {
          //Navigator.pushNamedAndRemoveUntil(context, ClinicSelectionPage.routerName, (route) => false, arguments: clinics);
        }
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: AppColor.darkBlue)),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Enter OTP", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
            const SizedBox(height: 8),
            //Text("Sent to ${ref.watch(mobileNumberProvider)}", style: const TextStyle(fontSize: 14, color: AppColor.grey)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return OTPTextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
                    if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                  },
                );
              }),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoading ? null : _verify,
              child: isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColor.white))
                  : const Text("Verify & Proceed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColor.white)),
            ),
          ],
        ),
      ),
    );
  }
}