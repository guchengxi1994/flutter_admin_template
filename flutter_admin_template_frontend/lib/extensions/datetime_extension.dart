extension ToString on DateTime {
  String toChinese() {
    return "$year年$month月$day日";
  }

  String toChineseWithSecond() {
    return "$year年 $month月 $day日 ${hour.toTime()}:${minute.toTime()}:${second.toTime()}";
  }

  String toEnglish() {
    return "$year/$month/$day";
  }
}

extension TimeStr on int {
  String toTime() {
    if (this >= 10) {
      return toString();
    } else {
      return "0${toString()}";
    }
  }
}
