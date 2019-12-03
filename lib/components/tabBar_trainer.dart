import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/provider.dart';
import 'package:zing_fitnes_trainer/utils/myColors.dart';

class TrainerTabBar extends StatefulWidget {
  @override
  _TrainerTabBarState createState() => _TrainerTabBarState();
}

class _TrainerTabBarState extends State<TrainerTabBar> {
  BorderRadius activeRadius = BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      topRight: Radius.zero,
      bottomRight: Radius.zero);

  @override
  Widget build(BuildContext context) {
    var colors = MyColors();
    var mydata = Provider.of<AppBarData>(context);
    var width = MediaQuery.of(context).size.width;
    return Container(
        width: width * 0.93,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(color: colors.deepBlue, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: colors.deepBlue,
          indicatorColor: colors.deepBlue,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: colors.deepBlue,
            borderRadius: activeRadius,
          ),
          tabs: [
            Tab(
              text: "Active",
            ),
            Tab(
              text: "Pending",
            ),
            Tab(
              text: "Requested",
            )
          ],
          onTap: (index) {
            setState(() {
              if (index == 1) {
                activeRadius = BorderRadius.only(
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero);

                mydata.setTitle = "Bookings";
              } else if(index == 2) {
                activeRadius = BorderRadius.only(
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomRight:Radius.circular(10));
                mydata.setTitle = "Active";
              }else{
                activeRadius = BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero);
              }
            });
          },
        ));
  }
}
