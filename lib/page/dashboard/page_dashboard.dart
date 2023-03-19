  import 'package:flutter/material.dart';
import 'package:unai_reminder/page/dashboard/dashboard_schedule.dart/dashboard_list_content.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unai Reminder")),
      body: const ScheduleList(),
    );
  }
}
