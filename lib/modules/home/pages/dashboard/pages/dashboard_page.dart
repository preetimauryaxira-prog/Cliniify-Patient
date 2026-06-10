import 'package:flutter/material.dart';
import '../../../../../utils/apptheme.dart';
import '../../../../profile/pages/patient_profile_page.dart';
import '../../../../records/pages/patient_records_page.dart';

import '../../patient_appointments_page.dart';
import '../tabs/home_tab.dart';
import '../widgets/custom_bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const String routerName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const PatientAppointmentsPage(),
    const PatientRecordsPage(),
    const PatientProfilePage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}