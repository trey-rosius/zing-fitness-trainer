package app.zing.com.zing_fitnes_trainer;

import android.os.Bundle;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterMain;
public class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    FlutterMain.startInitialization(this); //Added line
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
