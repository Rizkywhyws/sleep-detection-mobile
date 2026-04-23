class SleepData {
  final String day;
  final double durationHours;
  final double qualityPercent;
  final double lightPercent;
  final double deepPercent;
  final double remPercent;

  const SleepData({
    required this.day,
    required this.durationHours,
    required this.qualityPercent,
    required this.lightPercent,
    required this.deepPercent,
    required this.remPercent,
  });
}

final List<SleepData> weeklySleepData = [
  const SleepData(day: 'Sen', durationHours: 6.0, qualityPercent: 72, lightPercent: 45, deepPercent: 30, remPercent: 25),
  const SleepData(day: 'Sel', durationHours: 7.0, qualityPercent: 78, lightPercent: 40, deepPercent: 35, remPercent: 25),
  const SleepData(day: 'Rab', durationHours: 5.0, qualityPercent: 65, lightPercent: 50, deepPercent: 28, remPercent: 22),
  const SleepData(day: 'Kam', durationHours: 8.0, qualityPercent: 88, lightPercent: 38, deepPercent: 38, remPercent: 24),
  const SleepData(day: 'Jum', durationHours: 7.0, qualityPercent: 82, lightPercent: 40, deepPercent: 35, remPercent: 25),
  const SleepData(day: 'Sab', durationHours: 9.0, qualityPercent: 92, lightPercent: 35, deepPercent: 40, remPercent: 25),
  const SleepData(day: 'Min', durationHours: 8.0, qualityPercent: 87, lightPercent: 38, deepPercent: 37, remPercent: 25),
];

double get avgDuration =>
    weeklySleepData.map((e) => e.durationHours).reduce((a, b) => a + b) / weeklySleepData.length;

double get avgQuality =>
    weeklySleepData.map((e) => e.qualityPercent).reduce((a, b) => a + b) / weeklySleepData.length;

double get totalHours =>
    weeklySleepData.map((e) => e.durationHours).reduce((a, b) => a + b);

double get avgLight =>
    weeklySleepData.map((e) => e.lightPercent).reduce((a, b) => a + b) / weeklySleepData.length;

double get avgDeep =>
    weeklySleepData.map((e) => e.deepPercent).reduce((a, b) => a + b) / weeklySleepData.length;

double get avgRem =>
    weeklySleepData.map((e) => e.remPercent).reduce((a, b) => a + b) / weeklySleepData.length;