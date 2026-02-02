import 'dart:math';
import 'package:flutter/material.dart';
import 'alarm_model.dart';
import '../../helpers/notification_helper.dart';

class AlarmController extends ChangeNotifier {
  final List<AlarmModel> _alarms = [];

  List<AlarmModel> get alarms => List.unmodifiable(_alarms);

  int _newId() => Random().nextInt(1000000);

  Future<void> addAlarm(DateTime dt) async {
    final id = _newId();
    final alarm = AlarmModel(id: id, dateTime: dt);
    _alarms.add(alarm);

    await NotificationHelper.scheduleAlarmNotification(
      id: id,
      dateTime: dt,
      title: 'Alarm',
      body: 'Time to relax Buddy 🌿',
    );

    notifyListeners();
  }

  Future<void> removeAlarm(int id) async {
    _alarms.removeWhere((a) => a.id == id);
    await NotificationHelper.cancel(id);
    notifyListeners();
  }
}
