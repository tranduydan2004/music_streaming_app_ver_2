import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? 'Guest';
}
