import 'package:flutter/material.dart';
import '../../../utils/apptheme.dart';
import '../../../utils/hive_config.dart';
import 'mobile_login_page.dart';
import 'pin_login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const String routerName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Show splash screen for at least 2 seconds for branding
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final hasToken = HiveUser.getAuthToken().isNotEmpty;
    final hasPin = HiveUser.hasPin();

    if (hasToken && hasPin) {
      // Returning user
      Navigator.pushReplacementNamed(context, PinLoginPage.routerName);
    } else {
      // New user or session expired
      Navigator.pushReplacementNamed(context, MobileLoginPage.routerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace with your actual SVG/Asset Logo
              Icon(Icons.local_hospital_rounded, size: 100, color: AppColor.green),
              SizedBox(height: 24),
              Text(
                "Cliniify",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColor.darkBlue,
                  letterSpacing: -1,
                ),
              ),
              Text(
                "Patient Portal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.grey,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}