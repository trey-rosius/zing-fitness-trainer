
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';
class AppSettings {
  AppSettings(StreamingSharedPreferences preferences)
      : userId = preferences.getString(Config.userId, defaultValue: Config.userId),
       userType = preferences.getString(Config.userType, defaultValue: Config.regularUser),
       longitude = preferences.getString(Config.longitude, defaultValue: "0"),
       latitude= preferences.getString(Config.latitude, defaultValue: "0");




  final Preference<String> userId;
  final Preference<String> userType;
  final Preference<String> longitude;
  final Preference<String> latitude;



}