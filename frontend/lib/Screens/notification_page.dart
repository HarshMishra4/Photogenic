import 'package:flutter/material.dart';
import 'package:social_media/Classes/sizeconfigration.dart';

class UserAccountNotification extends StatefulWidget {
  @override
  _UserAccountNotificationState createState() => _UserAccountNotificationState();
}

class _UserAccountNotificationState extends State<UserAccountNotification> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // If no notifications then show this 
    return 
    Container(
      child: Column(
        children: [
          Spacer(),
          Image.asset("assets/sleeping-bell.gif"),
          Text("NO NOTIFICATIONS",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w400)),
          SizedBox(height: 15),
          Container(height: 2,width: 70,color: Colors.black),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("We'll notify you when there is something new",style: TextStyle(fontSize: 20),textAlign: TextAlign.center),
          ),
          Spacer(),
        ],
      ),
    );
    // Else list all the notifications
    // Container(
    //   padding: EdgeInsets.only(top: SizeConfig.statusBarHeight.top,bottom: SizeConfig.setHeight(50)),
    //   child: ListView.builder(
    //     padding: EdgeInsets.symmetric(),
    //     itemCount: 20,
    //     physics: BouncingScrollPhysics(),
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         leading: CircleAvatar(backgroundImage: NetworkImage("https://static.toiimg.com/thumb/msid-76465573,width-800,height-600,resizemode-75,imgsize-158778,pt-32,y_pad-40/76465573.jpg")),
    //         title: Text("Message title"),
    //         subtitle: Text("message subtitle"),
    //         trailing: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Urvashi_Rautela_Final.jpg/1200px-Urvashi_Rautela_Final.jpg",height: 50,fit: BoxFit.cover,),
    //       );
    //     }
    //   ),
    // );
  }
}