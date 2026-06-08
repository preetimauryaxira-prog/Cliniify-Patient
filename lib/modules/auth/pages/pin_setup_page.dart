import 'package:cliniify_patient/modules/home/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});
  static const String routerName = '/pin_setup';

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool _isPinComplete = false;
  bool _isSaving = false;

  void _checkPinCompletion() {
    String pin = _controllers.map((c) => c.text).join();
    setState(() {
      _isPinComplete = pin.length == 4;
    });
    
    if (_isPinComplete) {
      // Auto-dismiss keyboard when complete for better UX
      FocusScope.of(context).unfocus();
    }
  }

  void _savePin() async {
    if (!_isPinComplete) return;

    setState(() {
      _isSaving = true;
    });

    String pin = _controllers.map((c) => c.text).join();
    if (pin.length == 4) {
      HiveUser.savePin(pin);
      
      // Small delay for smooth UX transition
      await Future.delayed(const Duration(milliseconds: 400));
      
      if (!mounted) return;
      final clinics = ModalRoute.of(context)!.settings.arguments;
      Navigator.pushNamedAndRemoveUntil(
        context, 
        DashboardPage.routerName, 
        (route) => false, 
        arguments: clinics,
      );
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopIllustration(),
                  const SizedBox(height: 32),
                  _buildPinCard(),
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
        Icons.lock_person_rounded,
        size: 64,
        color: AppColor.green,
      ),
    );
  }

  Widget _buildPinCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Create Secure PIN",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColor.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "This PIN will be used for quick and secure login to your health portal.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return _buildEnhancedOTPField(index);
            }),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.green,
                disabledBackgroundColor: AppColor.green.withValues(alpha: 0.3),
                foregroundColor: AppColor.white,
                elevation: _isPinComplete ? 4 : 0,
                shadowColor: AppColor.green.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _isPinComplete && !_isSaving ? _savePin : null,
              child: _isSaving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColor.white,
                        strokeWidth: 3,
                      ),
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
    );
  }

  Widget _buildEnhancedOTPField(int index) {
    return SizedBox(
      width: 60,
      height: 68,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColor.darkBlue,
        ),
        cursorColor: AppColor.green,
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          _checkPinCompletion();
          
          // Optional: Auto-save immediately if desired, 
          // but relying on the Continue button is safer UX.
        },
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColor.welcomeBgColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.green, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.lightGrey, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_rounded, size: 16, color: AppColor.grey.withValues(alpha: 0.8)),
        const SizedBox(width: 8),
        const Text(
          "Do not share your PIN with anyone",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor.grey,
          ),
        ),
      ],
    );
  }
}