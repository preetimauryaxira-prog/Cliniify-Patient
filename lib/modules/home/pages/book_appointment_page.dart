import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/apptheme.dart';
import '../../appointments/providers/patient_appointment_provider.dart';

class BookAppointmentPage extends ConsumerStatefulWidget {
  const BookAppointmentPage({super.key});
  static const String routerName = '/book_appointment';

  @override
  ConsumerState<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends ConsumerState<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select Date and Time", style: TextStyle(color: Colors.white)), backgroundColor: AppColor.red));
      return;
    }

    ref.read(bookingLoadingProvider.notifier).state = true;

    try {
      final reqData = {
        "scheduled_date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
        "scheduled_time": "${_selectedTime!.hour}:${_selectedTime!.minute}:00",
        "desc": _reasonController.text.trim(),
        // In production, add Selected Doctor ID and Selected Procedure ID based on your endpoints
      };

      await ref.read(patientApptServiceProvider).bookAppointment(reqData);
      
      ref.read(bookingLoadingProvider.notifier).state = false;
      ref.invalidate(myAppointmentsProvider); // Refresh the list
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Appointment Requested Successfully"), backgroundColor: AppColor.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ref.read(bookingLoadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to book"), backgroundColor: AppColor.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bookingLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.darkBlue),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Placeholder for Doctor Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColor.lightGrey)),
                child: const Row(
                  children: [
                    Icon(Icons.medical_services_rounded, color: AppColor.green),
                    SizedBox(width: 12),
                    Text("Select Doctor", style: TextStyle(fontSize: 16, color: AppColor.darkBlue)),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.grey)
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Date & Time Picker
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColor.lightGrey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date", style: TextStyle(color: AppColor.grey, fontSize: 12)),
                            Text(_selectedDate == null ? "Select Date" : DateFormat('dd MMM yyyy').format(_selectedDate!), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (time != null) setState(() => _selectedTime = time);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColor.lightGrey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Time", style: TextStyle(color: AppColor.grey, fontSize: 12)),
                            Text(_selectedTime == null ? "Select Time" : _selectedTime!.format(context), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.darkBlue)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reason Input
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Reason for visit",
                  alignLabelWithHint: true,
                  border: AppTheme.outlineInputBorder,
                  focusedBorder: AppTheme.focusedOutlineInputBorder,
                ),
                validator: (val) => val == null || val.isEmpty ? "Please enter a reason" : null,
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading 
                    ? const CircularProgressIndicator(color: AppColor.white)
                    : const Text("Confirm Booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}