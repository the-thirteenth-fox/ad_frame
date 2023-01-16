// Время от которого не будут посылаться запросы
bool isTimeToShowAD(DateTime? dateTime) {
  /// Время от
  final startDateTime = dateTime ?? DateTime.now();

  final nowDateTime = DateTime.now();

  return (nowDateTime.isAfter(startDateTime));
}
