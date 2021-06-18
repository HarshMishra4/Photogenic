import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppDataDarkMode{
  static Color iconandtextColor = Colors.black87;
  static LinearGradient appThemecolor = LinearGradient(colors: [Color(0xFF56ab2f), Color(0xFFa8e063)]);
  static Color avatarBackgroundColor = Color(0xff303030);
  static Color borderDisabledColor = Color(0xff303030);
  static Color textField = Color(0xff303030);
  static Color backgroundColor = Color(0xff303030);
  static Color textColor = Colors.white;
  static Color subTextColor = Colors.grey[400];

}

class AppDataLightMode{
  static Color iconandtextColor = Colors.white10;
  static LinearGradient appThemecolor = LinearGradient(colors: [Color(0xFF56ab2f), Color(0xFFa8e063)]);
  static Color avatarBackgroundColor = Colors.white;
  static Color borderDisabledColor = Color(0xff303030);
  static Color textField = Colors.white;
  static Color backgroundColor = Color(0xff303030);
  static Color textColor = Colors.black;
  static Color subTextColor = Colors.grey[500];

}

showToast({String message}) {
  Fluttertoast.showToast(
    msg: message,
    textColor: Colors.white,
    backgroundColor: Colors.black,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM
  );
}

class TimeAgo{
  static String timeAgoSinceDate( dateString, {bool numericDates = true}) {
    final difference = DateTime.now().difference(DateTime.parse(dateString));

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

} 