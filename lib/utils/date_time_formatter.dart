import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String getFormattedTime(int seconds, [bool isShortForm = false]) {
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    if (hours > 0) {
      return "$hours ${isShortForm ? 'h.' : 'hours'}";
    } else if (minutes > 0) {
      return "$minutes ${isShortForm ? 'min.' : 'minutes'}";
    } else {
      return "$seconds ${isShortForm ? 'sec.' : 'seconds'}";
    }
  }

  static String getFormattedDate(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
    return formattedDate;
  }
}
