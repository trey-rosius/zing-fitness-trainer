import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/provider.dart';
import 'package:zing_fitnes_trainer/components/MyDrawer.dart';
import 'package:zing_fitnes_trainer/screens/bookings_active/modules/active_session.dart';
import 'package:zing_fitnes_trainer/screens/bookings_active/modules/bookings.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';
import 'package:zing_fitnes_trainer/components/tabBar.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
  //  var myColor = Colors.green;
  //  var hex = '#${myColor.value.toRadixString(16)}';

   // print(hex);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => AppBarData(),
        )
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(

            appBar: AppBar(
              elevation: 0.0,
              iconTheme: IconThemeData(color: MyColors().deepBlue, size: 40),

              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 50),
                child: MyTabBar(),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                )
              ],
            ),
            body: BookingsBody(),
          ),

      ),
    );
  }
}

class BookingsBody extends StatelessWidget {
  //this will be modified later to make the list dynamic
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[ActiveSession(), Bookings()],
    );
  }
}
