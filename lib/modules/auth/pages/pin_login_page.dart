import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import 'mobile_login_page.dart';
import '../../home/pages/dashboard_page.dart';

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

  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Entrance Animation
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutQuart));
    
    _entranceController.forward();

    // Shake Animation (Error State)
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    // Listeners for Focus States
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {}); // Rebuild to update border highlight
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _entranceController.dispose();
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

    // Smooth UI delay for verification
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
      
      // Clear fields and refocus after animation
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
      Navigator.pushReplacementNamed(
        context, 
        DashboardPage.routerName, 
        arguments: dynamicClinics,
      );
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
    
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (value.isNotEmpty && index == 3) {
      _verifyPin(); 
    }
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderIllustration(),
                      const SizedBox(height: 32),
                      _buildAuthCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIllustration() {
    return Column(
      children: [
        Container(
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
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
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
            "Welcome Back 👋",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.w900, 
              color: AppColor.darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Securely access your health account\nusing your 4-digit PIN.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, 
              color: AppColor.grey,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          
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
              children: List.generate(4, (index) {
                return _buildPremiumPinField(index);
              }),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // State Indicator (Loading or Error)
          SizedBox(
            height: 24,
            child: Center(
              child: _isVerifying 
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(color: AppColor.green, strokeWidth: 2.5),
                  )
                : AnimatedOpacity(
                    opacity: _hasError ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppColor.red, size: 16),
                        SizedBox(width: 6),
                        Text(
                          "Incorrect PIN. Try again.",
                          style: TextStyle(color: AppColor.red, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Divider(height: 1, color: AppColor.lightGrey),
          const SizedBox(height: 24),
          
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isVerifying ? null : _logoutAndReset,
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColor.darkBlue.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_reset_rounded, size: 20, color: AppColor.darkBlue.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    const Text(
                      "Forgot PIN? Login with OTP",
                      style: TextStyle(
                        color: AppColor.darkBlue, 
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPinField(int index) {
    bool isFocused = _focusNodes[index].hasFocus;
    
    return Container(
      width: 60,
      height: 68,
      decoration: BoxDecoration(
        color: _hasError ? AppColor.red.withValues(alpha: 0.05) : AppColor.welcomeBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasError 
              ? AppColor.red 
              : isFocused 
                  ? AppColor.green 
                  : AppColor.lightGrey,
          width: isFocused || _hasError ? 2.0 : 1.0,
        ),
        boxShadow: isFocused && !_hasError
            ? [BoxShadow(color: AppColor.green.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Center(
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
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: _hasError ? AppColor.red : AppColor.darkBlue,
          ),
          cursorColor: AppColor.green,
          onChanged: (value) => _onPinChanged(value, index),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}