// Report Dialog
import 'package:flutter/material.dart';
import 'package:social_media/Classes/app_settings.dart';
import 'package:social_media/Classes/sizeconfigration.dart';
import 'package:social_media/Screens/sub-screens/splash-screen.dart';
import 'package:social_media/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReportPostDialog extends StatelessWidget {
  final int postId;
  final int index;
  ReportPostDialog({this.postId, this.index});

  final List<String> reportTypes = ["It's spam", "It's inappropriate"];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: SizeConfig.setHeight(130),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(colors: [Colors.lightGreenAccent, Color(0xFFa8e063)]),
        ),
        padding: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Report Post',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
              SizedBox(height: 4.0),
              Text("Why are you reporting this post ?",style: TextStyle(fontSize: 17)),
              SizedBox(height: 6.0),
              Column(children: List.generate(reportTypes.length,(index) => customButton(label: reportTypes[index],onTap: ()=> reportPost(reportTypes[index],context)))),
          ]),
        ),
      ),
    );
  }

  Widget customButton({String label,Function onTap}) => 
  InkWell(onTap: onTap,child: SizedBox(width: double.infinity,child: Padding(padding: EdgeInsets.symmetric(vertical: 4.0),child: Text(' • ' + label, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16)))));

  reportPost(String type, BuildContext context) async{
    // todo add user's detail [ email-Id ]
    final isReported = await APIServices.reportPost(postid: '$postId',reportType: type, useremail: 'harsh@gmail.com');
    if(isReported) {
      apiController.feeds.value.posts.removeAt(index);
      showToast(message: "Report registered");
      Navigator.pop(context);
      // Toast Message [ Reported Successfully ] and remove post from the list
    }
    else {
      showToast(message: 'You are not logged in');
      // Toast Message [ Something went wrong ]
    }
  }
}