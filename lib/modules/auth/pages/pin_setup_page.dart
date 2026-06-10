import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../home/pages/dashboard/pages/dashboard_page.dart';
import '../widgets/leafboard_header_painter.dart'; // Import the unified custom background wave painter

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _checkPinCompletion() {
    String pin = _controllers.map((c) => c.text).join();
    setState(() {
      _isPinComplete = pin.length == 4;
    });

    if (_isPinComplete) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Curved Minimal Header Section (Mirrors MobileLoginPage Exactly)
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

                    // 2. Headings Text Block
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Secure PIN",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColor.darkBlue, letterSpacing: -0.5),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Set up a 4-digit numeric login sequence to quickly and securely access your health portal.",
                            style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. Pin Input Fields Matrix Area
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildPinInputRow(),
                    ),

                    const Spacer(),

                    // 4. Reactive Capsule Submit Button Block
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPinComplete ? AppColor.green : AppColor.lightGrey.withValues(alpha: 0.6),
                            foregroundColor: AppColor.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: (_isPinComplete && !_isSaving) ? _savePin : null,
                          child: _isSaving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColor.white, strokeWidth: 2.5))
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Secure Account", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 14),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    _buildFooterText(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPinInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return _buildEnhancedOTPField(index);
      }),
    );
  }

  Widget _buildEnhancedOTPField(int index) {
    return SizedBox(
      width: 64,
      height: 68,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        obscureText: true, // Safeguards PIN entry input visibility
        obscuringCharacter: '●',
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
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
        },
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColor.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColor.lightGrey.withValues(alpha: 0.8), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.green, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 14, color: AppColor.grey),
            SizedBox(width: 6),
            Text(
              "Do not share your security credentials with anyone.",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColor.grey),
            ),
          ],
        ),
      ),
    );
  }
}