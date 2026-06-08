import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _selectedCountryCode = '+91';

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(authLoadingProvider.notifier).state = true;
    final mobile = _mobileController.text.trim();

    try {
      final responseData =
          await ref.read(patientAuthProvider).loginWithMobile(mobile);

      HiveUser.saveAuthToken(responseData['token']);

      final linkedPatients =
          List<dynamic>.from(responseData['linked_patients'] ?? []);
      if (linkedPatients.isNotEmpty) {
        HiveUser.saveLinkedPatients(linkedPatients);
        HiveUser.saveActivePatient(
            Map<String, dynamic>.from(linkedPatients.first));
      }

      final clinics =
          List<Map<String, dynamic>>.from(responseData['clinics'] ?? []);
      HiveUser.saveAllClinics(clinics);

      if (!mounted) return;
      ref.read(authLoadingProvider.notifier).state = false;

      if (!HiveUser.hasPin()) {
        Navigator.pushNamedAndRemoveUntil(
            context, PinSetupPage.routerName, (route) => false,
            arguments: clinics);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, ClinicSelectionPage.routerName, (route) => false,
            arguments: clinics);
      }
    } catch (e) {
      if (!mounted) return;
      ref.read(authLoadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: AppColor.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopIllustration(),
                  const SizedBox(height: 32),
                  _buildLoginCard(isLoading),
                  const SizedBox(height: 32),
                  _buildFooterText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopIllustration() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.green.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.health_and_safety_rounded,
        size: 72,
        color: AppColor.green,
      ),
    );
  }

  Widget _buildLoginCard(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlue.withValues(alpha: 0.06),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to Cliniify",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColor.darkBlue,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your registered mobile number to access your healthcare portal.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 36),
            const Text(
              "Mobile Number",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColor.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.darkBlue,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: AppColor.welcomeBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.phone_rounded,
                        color: AppColor.green, size: 20),
                    const SizedBox(width: 4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColor.darkBlue, size: 20),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.darkBlue,
                        ),
                        // Adjust dropdown background color if needed
                        dropdownColor: AppColor.welcomeBgColor,
                        items: const [
                          DropdownMenuItem(
                            value: '+91',
                            child: Text('🇮🇳 +91'),
                          ),
                          DropdownMenuItem(
                            value: '+1',
                            child: Text('🇨🇦 +1'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCountryCode = newValue;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 8),
                    Container(
                      height: 24,
                      width: 1.5,
                      color: AppColor.grey.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                hintText: "00000 00000",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.grey.withValues(alpha: 0.5),
                  letterSpacing: 1.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: AppColor.green, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColor.red, width: 1.2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColor.red, width: 1.5),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Mobile number is required";
                }
                if (val.length < 10) return "Enter a valid 10-digit number";
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.green,
                  foregroundColor: AppColor.white,
                  elevation: 4,
                  shadowColor: AppColor.green.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: AppColor.white, strokeWidth: 3),
                      )
                    : const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "By continuing, you agree to our Terms of Service\n& Privacy Policy.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColor.grey,
          height: 1.5,
        ),
      ),
    );
  }
}
