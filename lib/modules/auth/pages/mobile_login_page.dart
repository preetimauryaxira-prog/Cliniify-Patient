import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../providers/auth_provider.dart';
import 'pin_setup_page.dart';
import 'clinic_selection_page.dart';
import '../widgets/leafboard_header_painter.dart'; // Import custom painter here

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
      final responseData = await ref.read(patientAuthProvider).loginWithMobile(mobile);
      HiveUser.saveAuthToken(responseData['token']);

      final linkedPatients = List<dynamic>.from(responseData['linked_patients'] ?? []);
      if (linkedPatients.isNotEmpty) {
        HiveUser.saveLinkedPatients(linkedPatients);
        HiveUser.saveActivePatient(Map<String, dynamic>.from(linkedPatients.first));
      }

      final clinics = List<Map<String, dynamic>>.from(responseData['clinics'] ?? []);
      HiveUser.saveAllClinics(clinics);

      if (!mounted) return;
      ref.read(authLoadingProvider.notifier).state = false;

      if (!HiveUser.hasPin()) {
        Navigator.pushNamedAndRemoveUntil(context, PinSetupPage.routerName, (route) => false, arguments: clinics);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, ClinicSelectionPage.routerName, (route) => false, arguments: clinics);
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
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Curved Minimal Header Section
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(size.width, size.height * 0.36),
                            painter: const LeafboardHeaderPainter(),
                          ),
                          Positioned(
                            bottom: -80,
                            child: Container(
                              height: 200,
                              width: 150,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColor.black.withValues(alpha: 0.3), width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.darkBlue.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0), // Adds padding inside the white circle so your logo doesn't touch the edges
                                  child: Image.asset(
                                    'assets/images/logo.png', // path to your logo
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 100),
                      
                      // Central Header Titles
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cliniify Patient Login",
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColor.darkBlue, letterSpacing: -0.5),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Login to get medical insights, book appointments, and manage your health with ease.",
                              style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Input Fields Block
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mobile/Phone:",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.darkBlue),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColor.darkBlue),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: AppColor.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                prefixIcon: _buildCountryCodePicker(),
                                hintText: "00000 00000",
                                hintStyle: TextStyle(fontSize: 15, color: AppColor.grey.withValues(alpha: 0.4)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: AppColor.lightGrey.withValues(alpha: 0.8), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: AppColor.green, width: 1.5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: AppColor.red, width: 1.2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(color: AppColor.red, width: 1.5),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) return "Mobile number is required";
                                if (val.length < 10) return "Enter a valid 10-digit number";
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Submit Button Anchor Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _mobileController,
                          builder: (context, value, child) {
                            final bool isValidInput = value.text.length == 10;
                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isValidInput ? AppColor.green : AppColor.lightGrey.withValues(alpha: 0.6),
                                  foregroundColor: AppColor.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                ),
                                onPressed: (isLoading || !isValidInput) ? null : _login,
                                child: isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2.5))
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Continue", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_ios_rounded, size: 14),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                      _buildFooterText(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountryCodePicker() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountryCode,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.grey, size: 18),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.darkBlue),
              items: const [
                DropdownMenuItem(value: '+91', child: Text('🇮🇳 +91')),
                DropdownMenuItem(value: '+1', child: Text('🇨🇦 +1')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) setState(() => _selectedCountryCode = newValue);
              },
            ),
          ),
          const SizedBox(width: 4),
          Container(height: 18, width: 1, color: AppColor.lightGrey),
        ],
      ),
    );
  }

  Widget _buildFooterText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Text(
          "By continuing, you agree to our Terms of Service & Privacy Policy.",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColor.grey),
        ),
      ),
    );
  }
}