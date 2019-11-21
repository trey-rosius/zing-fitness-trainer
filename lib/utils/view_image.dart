import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class ViewImageScreen extends StatelessWidget {
  ViewImageScreen({this.tag,this.imageUrl});
  final String tag;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("View Image",style: TextStyle(fontSize: 20.0),),

      ),
      body: SingleChildScrollView(
        child: Hero(tag: tag, child:CachedNetworkImage(

          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context,url) => SpinKitWave(
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              );
            },
          ),


          errorWidget: (context,url,error) =>Icon(Icons.error),
        ),),
      ),
    );
  }
}
