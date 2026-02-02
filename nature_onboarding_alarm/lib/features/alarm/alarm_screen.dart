import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/notification_helper.dart';

class AlarmScreen extends StatefulWidget {
  final String locationLabel;
  const AlarmScreen({super.key, required this.locationLabel});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<_AlarmItem> alarms = [];

  int _newId() => Random().nextInt(1000000);

  Future<void> _addAlarm() async {
    final now = DateTime.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))),
    );

    if (picked == null) return;

    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final id = _newId();
    final newAlarm = _AlarmItem(id: id, dateTime: scheduled, enabled: true);

    setState(() => alarms.insert(0, newAlarm));

    // for notificcation
    await NotificationHelper.scheduleAlarmNotification(
      id: id,
      dateTime: scheduled,
      title: "Travel Alarm",
      body: "It's time! Your alarm is ringing.",
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Alarm set for ${DateFormat('hh:mm a').format(scheduled)}",
        ),
      ),
    );
  }

  Future<void> _toggleAlarm(_AlarmItem alarm, bool value) async {
    setState(() {
      final idx = alarms.indexWhere((a) => a.id == alarm.id);
      alarms[idx] = alarm.copyWith(enabled: value);
    });

    if (value) {
      // schedule again
      await NotificationHelper.scheduleAlarmNotification(
        id: alarm.id,
        dateTime: alarm.dateTime,
        title: "Travel Alarm",
        body: "It's time! Your alarm is ringing.",
      );
    } else {
      await NotificationHelper.cancel(alarm.id);
    }
  }

  Future<void> _deleteAlarm(_AlarmItem alarm) async {
    await NotificationHelper.cancel(alarm.id);
    setState(() => alarms.removeWhere((a) => a.id == alarm.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _PurpleFab(onTap: _addAlarm),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0A2E), Color(0xFF06113A), Color(0xFF061A3B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selected Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // location show box
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.locationLabel,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Alarms",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: alarms.isEmpty
                      ? Center(
                          child: Text(
                            "No alarms yet.",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: alarms.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final a = alarms[i];
                            return _AlarmCard(
                              time: DateFormat(
                                'h:mm a',
                              ).format(a.dateTime).toLowerCase(),
                              date: DateFormat(
                                'EEE dd MMM yyyy',
                              ).format(a.dateTime),
                              enabled: a.enabled,
                              onChanged: (v) => _toggleAlarm(a, v),
                              onDelete: () => _deleteAlarm(a),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlarmItem {
  final int id;
  final DateTime dateTime;
  final bool enabled;

  _AlarmItem({required this.id, required this.dateTime, required this.enabled});

  _AlarmItem copyWith({bool? enabled}) =>
      _AlarmItem(id: id, dateTime: dateTime, enabled: enabled ?? this.enabled);
}

class _AlarmCard extends StatelessWidget {
  final String time;
  final String date;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  const _AlarmCard({
    required this.time,
    required this.date,
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeColor: const Color(0xFF6A00FF),
            activeTrackColor: const Color(0x806A00FF),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white24,
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _PurpleFab extends StatelessWidget {
  final VoidCallback onTap;
  const _PurpleFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        width: 62,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3D00FF), Color(0xFF6A00FF)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
