import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modules/billing/pages/patient_billing_page.dart';
import 'modules/gallery/pages/clinic_gallery_page.dart';
import 'modules/home/pages/book_appointment_page.dart';
import 'modules/notification/pages/notifications_page.dart';
import 'modules/treatments/pages/patient_treatments_page.dart';
import 'utils/apptheme.dart';
import 'utils/hive_config.dart';

// Import Pages
import 'modules/auth/pages/splash_page.dart';
import 'modules/auth/pages/mobile_login_page.dart';
import 'modules/auth/pages/otp_verification_page.dart';
import 'modules/auth/pages/pin_setup_page.dart';
import 'modules/auth/pages/pin_login_page.dart';
import 'modules/auth/pages/clinic_selection_page.dart';

import 'modules/home/pages/dashboard_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Storage
  await HiveUser.initHive();

  runApp(
    // ProviderScope is required for Riverpod
    const ProviderScope(
      child: CliniifyPatientApp(),
    ),
  );
}

class CliniifyPatientApp extends StatelessWidget {
  const CliniifyPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliniify Patient',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.green),
        useMaterial3: true,
        textTheme: GoogleFonts.manropeTextTheme(), // Standardizing font
      ),
      initialRoute: SplashPage.routerName,
      routes: {
        SplashPage.routerName: (context) => const SplashPage(),
        MobileLoginPage.routerName: (context) => const MobileLoginPage(),
        OtpVerificationPage.routerName: (context) => const OtpVerificationPage(),
        PinSetupPage.routerName: (context) => const PinSetupPage(),
        PinLoginPage.routerName: (context) => const PinLoginPage(),
        ClinicSelectionPage.routerName: (context) => const ClinicSelectionPage(),
        DashboardPage.routerName: (context) => const DashboardPage(),
        BookAppointmentPage.routerName: (context) => const BookAppointmentPage(),
        PatientBillingPage.routerName: (context) => const PatientBillingPage(),
        NotificationsPage.routerName: (context) => const NotificationsPage(),
        PatientTreatmentsPage.routerName: (context) => const PatientTreatmentsPage(),
        ClinicGalleryPage.routerName: (context) => const ClinicGalleryPage(),
      },
    );
  }
}