import 'package:flutter/material.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:zing_fitnes_trainer/screens/home/zoom_scaffold.dart';
import 'package:zing_fitnes_trainer/screens/selectusertype/select_user_type_screen.dart';
import 'package:zing_fitnes_trainer/screens/shared_preferences/app_settings.dart';
import 'package:zing_fitnes_trainer/screens/shared_preferences/app_settings_inherited.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   AppSettings settings = AppSettingsInherited.of(context).settings;
   // print("admin value is"+settings.admin.getValue().toString());
    print("user Id value is"+settings.userId.getValue());
    print("user type is"+settings.userType.getValue());
    return PreferenceBuilder<String>(
        preference:settings.userId,
        builder: (context,String userId) {
     if(userId != Config.userId) {
       return ZoomScaffold(

           userId: userId,
           longitude: settings.longitude.getValue(),
           latitude: settings.latitude.getValue(),
          userType:settings.userType.getValue()



       );
     } else
       {
         return SelectUserTypeScreen();
       }
        });
  }
}
