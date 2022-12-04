class FormatDateTime {
  static String formatDay(DateTime dateTime) {
    final String day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : dateTime.day.toString();
    final String month = dateTime.month.toString().length == 1
        ? '0${dateTime.month}'
        : dateTime.month.toString();
    final String year = dateTime.year.toString().substring(2);

    return "$day/$month/$year";
  }

  static String formatTime(DateTime dateTime) {
    final String hour = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : dateTime.hour.toString();
    final String minute = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();

    return "$hour:$minute ";
  }
}
