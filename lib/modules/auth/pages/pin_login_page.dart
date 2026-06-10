import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import '../../home/pages/dashboard/pages/dashboard_page.dart';
import 'mobile_login_page.dart';
import '../widgets/leafboard_header_painter.dart'; // Re-used Painter for seamless UI parity

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});
  static const String routerName = '/pin_login';

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> with TickerProviderStateMixin {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  
  bool _isVerifying = false;
  bool _hasError = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Shake Animation Engine (Triggered during failed entry matches)
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    for (var node in _focusNodes) {
      node.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyPin() async {
    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    String enteredPin = _controllers.map((c) => c.text).join();
    String savedPin = HiveUser.getPin();

    if (enteredPin == savedPin) {
      _routeToNextScreen();
    } else {
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });
      
      _shakeController.forward(from: 0.0);
      HapticFeedback.vibrate();
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            for (var c in _controllers) {
              c.clear();
            }
          });
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  void _routeToNextScreen() {
    final selectedClinic = HiveUser.getSelectedClinic();
    if (selectedClinic == null) {
      final dynamicClinics = HiveUser.getAllClinics();
      Navigator.pushReplacementNamed(context, DashboardPage.routerName, arguments: dynamicClinics);
    } else {
      Navigator.pushReplacementNamed(context, DashboardPage.routerName);
    }
  }

  void _logoutAndReset() {
    HiveUser.logout();
    Navigator.pushReplacementNamed(context, MobileLoginPage.routerName);
  }

  void _onPinChanged(String value, int index) {
    if (_hasError) {
      setState(() => _hasError = false);
    }
    
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else if (index == 3) {
        _verifyPin(); 
      }
    }
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
                    // 1. Replicated Custom Curved Header Section with Central Custom Logo Circle
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
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset(
                                  'assets/images/logo.png', // Uses your custom asset path exactly
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 100),
                    
                    // 2. Replicated Left-Aligned Header Typography Layout
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColor.darkBlue, letterSpacing: -0.5),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Enter your 4-digit security PIN to unlock and securely view your local health history records.",
                            style: TextStyle(fontSize: 14, color: AppColor.grey, fontWeight: FontWeight.w500, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 3. Horizontal Entry PIN Block (with integrated Shake Transforms)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Security PIN:",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.darkBlue),
                          ),
                          const SizedBox(height: 12),
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value, 0),
                                child: child,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) => _buildPinCell(index)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusFeedbackRow(),
                    
                    const Spacer(),
                    
                    // 4. Reset Account / Alt OTP Action Block
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: _buildForgotPinAction(),
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

  Widget _buildPinCell(int index) {
    bool isFocused = _focusNodes[index].hasFocus;
    
    return Container(
      width: 68,
      height: 64,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16), // Clean rounded bounding corners matching app input profiles
        border: Border.all(
          color: _hasError 
              ? AppColor.red 
              : isFocused 
                  ? AppColor.green 
                  : AppColor.lightGrey.withValues(alpha: 0.8),
          width: isFocused || _hasError ? 1.5 : 1.0,
        ),
        boxShadow: isFocused ? [
          BoxShadow(
            color: AppColor.green.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Center(
        child: RawKeyboardListener(
          focusNode: FocusNode(), 
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent && 
                event.logicalKey == LogicalKeyboardKey.backspace && 
                _controllers[index].text.isEmpty && 
                index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
            }
          },
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            obscureText: true,
            obscuringCharacter: '●',
            readOnly: _isVerifying,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _hasError ? AppColor.red : AppColor.darkBlue,
            ),
            cursorColor: AppColor.green,
            onChanged: (value) => _onPinChanged(value, index),
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFeedbackRow() {
    return SizedBox(
      height: 24,
      child: Center(
        child: _isVerifying 
          ? const SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(color: AppColor.green, strokeWidth: 2.5),
            )
          : AnimatedOpacity(
              opacity: _hasError ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: AppColor.red, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Incorrect PIN. Please try again.",
                    style: TextStyle(color: AppColor.red, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildForgotPinAction() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.lock_reset_rounded, size: 20),
        label: const Text("Forgot PIN? Login with OTP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        onPressed: _isVerifying ? null : _logoutAndReset,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.darkBlue,
          side: BorderSide(color: AppColor.lightGrey.withValues(alpha: 0.8), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), // Pill shape matching primary Continue button
        ),
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