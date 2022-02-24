import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';
import 'dart:convert';

class SPHelper {
  static late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future writeSession(Session session) async {
    prefs.setString(session.id.toString(), json.encode(session.toJson()));
  }

  List<Session> getSessions() {
    List<Session> sessions = [];
    Set<String> keys = prefs.getKeys();
    keys.forEach((key) {
      if (key != 'counter') {
        Session session =
            Session.fromJson(json.decode(prefs.getString(key) ?? ''));
        sessions.add(session);
      }
    });
    return sessions;
  }

  Future<int> getAndSetCounter() async {
    int counter = prefs.getInt('counter') ?? 0;
    counter++;
    await prefs.setInt("counter", counter);
    return counter;
  }

  Future<void> delete(Session session) async {
    await prefs.remove(session.id.toString());
  }
}
