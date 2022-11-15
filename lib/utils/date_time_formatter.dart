import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String getFormattedTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    if (hours > 0) {
      return "$hours hours";
    } else if (minutes > 0) {
      return "$minutes minutes";
    } else {
      return "$seconds seconds";
    }
  }

  static String getFormattedDate(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
    return formattedDate;
  }
}
