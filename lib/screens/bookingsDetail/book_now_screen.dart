import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zing_fitnes_trainer/providers/profile_provider.dart';
import 'package:zing_fitnes_trainer/screens/Profile/trainer_profile_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/distance_model.dart';
import 'package:zing_fitnes_trainer/screens/bookingsDetail/new_booking_model.dart';
import 'package:zing_fitnes_trainer/screens/trainers/trainer_user_item.dart';

class BookNowScreen extends StatefulWidget {
  BookNowScreen(this.userId,this.bookingModel);
  final String userId;
  final NewBookingModel bookingModel;

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {

  DistanceModel distanceModel = DistanceModel();
  List<DistanceModel> distanceModelList =[];

  double distance;
  Future<double> calculateDistance(TrainerProfileModel trainerProfileModel){
    final distanceInMeters =  ProfileProvider.instance().calculateDistance(trainerProfileModel, widget.bookingModel.longitude, widget.bookingModel.latitude)
        .then((distanceInMeters) {

      print("distance is " + distance.toString());

      return  distance = distanceInMeters;



    });
    return distanceInMeters;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("user id"+widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    var trainerList = Provider.of<List<TrainerProfileModel>>(context);

    if(trainerList == null){
      print("trainer is null");
    }else
    {
      for(int i = 0; i<= trainerList.length-1;i++){
        calculateDistance(trainerList[i]).then((value){
          print("this is the value"+value.toString());
          distanceModel = DistanceModel(distance: value,trainerId: trainerList[0].userId);

          distanceModelList.add(distanceModel);


          if(i == trainerList.length-1){

            distanceModelList.sort((a,b) => a.distance.compareTo(b.distance));

            print("distance list sorted" + distanceModelList[0].distance.toStringAsFixed(2));
          }else
          {

          }




        });



      }

    }





    return Scaffold(
        appBar: AppBar(
          title: Text('Trainers',style: TextStyle(fontSize: 20),),
          centerTitle: true,


        ),
        body: ChangeNotifierProvider(
            create: (_) => ProfileProvider.instance(),
            child: Consumer(
                builder: (context, ProfileProvider productRepo, _) {



                  //  productRepo.listDistance(trainerList, widget.bookingModel.longitude, widget.bookingModel.latitude);

                  // productRepo.listDistanceModel.sort((a,b) => productRepo.distanceModel.distance.compareTo(productRepo.distanceModel.distance));

                  //  print("sorted" + productRepo.listDistanceModel.toString());

                  return Text("asdasd");

                }))

      /*
      trainerList == null ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context,index){
        return FutureBuilder<String>(
          future: calculateDistance(trainerList[index]),
          builder: (context,snapshot){
            if(snapshot.hasData)
              {



                return TrainerUserItem(trainerInfo: trainerList[index],bookingModel:widget.bookingModel,userId: widget.userId,distance:snapshot.data);
              }else{
              return Container(child: Center(child: CircularProgressIndicator(),),);
            }

          },
        );
      },
      itemCount: trainerList.length,),

      */

    );
  }
}
